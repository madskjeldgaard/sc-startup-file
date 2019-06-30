(
    /*


    todo
    . an event dict holding all data for all pads? fx pad[row][col].bus
    . bus for each pad
    . Splay in out

    */

var microtonal_organ = {
    arg basefreq=50, 
        padStates=4, // Between 1 and 4 

        sendOSCData = true, 
        targetAddress="127.0.0.1", 
        targetPort=7000;
    
    (
    
    init: {|self| 
        self.setupBusses;
        self.prepareForSynths;
        self.setupController;
    },

    prepareForSynths: {|self|
        self.synths = Array.fill2D(8,8); // Note, this has different behaviour from Array2D.new 

        // This is the mastergroup that will hold all synths from each pad and
        // run them through the output synth and other master effects
        self.masterGroup = Group.new;

            Synth.tail(self.masterGroup, 
                'out',
                [
                    \amp, self.controlBusses.sliders.at(8).asMap
                ]
            );

    },

    makeSynth: {|self, state, row, col|

        var synthgroup = Group.head(self.masterGroup);

        var r = row + 1;
        var c = col + 1 ;
        var freq = basefreq * c * r;

        s.makeBundle(nil, {

            (state < 3).if({

                // Source
                Synth.head(synthgroup, 
                   'organVoice',
                   [
                        \freq, freq,
                        \freqdiff, state,
                        \detune, self.controlBusses.sliders.at(col).asMap,
                        \pan,exprand(-1,1) ,
                        \amp, r.pow(2).reciprocal
                   ]
                );

            }, {

                // Source
                Synth.head(synthgroup, 
                   'grainsin',
                   [
                        \freq, freq,
                        \freqdiff, state,
                        \detune, self.controlBusses.sliders.at(col).asMap,
                        \amp, r.pow(2).reciprocal
                   ]
                );
            });
            
        });

        // Place the synth in a 2d matrix array equivalent to the pad matrix on
        // the controller
        // When the synth needs to be freed it's done from here as well
        self.synths[row][col] = synthgroup;

    },
    
    // FUNCTION FOR PADS
    padFunc: {|self, row, col, state|

        // Update bus
        self.controlBusses.pads[row][col].set(state);

        // If a synth is already playing in this pads memory, free it
        self.synths[row][col].notNil.if({ self.synths[row][col].free; });
        
        // If the state of the pad isn't 0, play a synth
        (state == 0).if(
            {self.synths[row][col].free},
            {self.makeSynth(state, row, col).value}
        );
    
        // Send data off via OSC
        self.oscSender("/padRow%Col%".format(row,col), state);
    },

    // FUNCTION FOR BUTTONS 
    btnFunc: {|self, type, btnNo, state| 

        // Do this if it's a horizontal button
        (type == \hor).if({
            self.controlBusses.horBtns.at(btnNo).set(state)
        });

        // Do this if it's a vertical button
        (type == \ver).if({
            self.controlBusses.verBtns.at(btnNo).set(state)
        });

        self.oscSender("/%Btn%".format(type, btnNo), state);
    },

    
    // BUS SETUP
    setupBusses: {|self|
        var sliderdefault = 0.5;

        self.controlBusses = ();

        // Slider busses
        self.controlBusses.sliders = Array.fill(9, { Bus.control(s,1).set(sliderdefault)});

        // Pad busses
        self.controlBusses.pads = Array.fill2D(8, 8, {Bus.control(s,1)});

        // Horizontal button busses
        self.controlBusses.horBtns = Array.fill(8, {Bus.control(s,1)}); 

        // Vertical button busses
        self.controlBusses.verBtns = Array.fill(8, {Bus.control(s,1)}); 

        },

    // CONTROLLER SETUP
    setupController: {|self| 

        // Instantiate script
        self.controller = APCmini.new;

        // Number of states for the pads
        self.controller.setNumStatesAll(padStates);

        // Set sliders
        9.do{|sliderNum|
            self.controller.setSliderFunction(sliderNum, {| sliderIndex, value|
                var v = value.linlin(0,127,0.0,1.0);
                self.controlBusses.sliders.at(sliderIndex).set(v);
                self.oscSender("/slider" ++ sliderNum, v);
            })
        };

        // Set pads (there are 8 x 8 and for each there are 4 states)
        8.do{|row|
            8.do{|col|
                padStates.do{|state|
                    self.controller.setPadFunction(row, col, state, {
                        self.padFunc(row, col, state);
                        }
                    );
                }
            }
        };

        // The horizontal and vertical buttons on the side of the controller
        // only have two modes: On or off
        8.do{|btnNo| 
            2.do{|state|
                2.do{|typeNo|
                    var types = [\hor, \ver];
                    self.controller.setButtonFunction(types[typeNo], btnNo, state, {
                        self.btnFunc(types[typeNo], btnNo, state);
                        }
                    );
                }
            }
        }
    },
            
    // OSC FUNCTIONS
    oscTarget: {|self| 
        NetAddr.new(targetAddress, targetPort);
    },	

	oscSender: {|self, message, parameter, base="/apcmini_HELLO"|
        if (sendOSCData, {
            self.oscTarget.sendMsg(base ++ message, parameter);   
        }, 
        {"Not sending OSC data"})
	}
)};

microtonal_organ.value(basefreq:80).init;

/************ 

    SYNTHS 

************/

SynthDef(\organVoice, {
    arg out=0, amp=1, freq, freqdiff=0, detune=0, effectBus, pan=0;
    var d = 1 + (detune / 10);
    var env, sig;

    sig = SinOsc.ar(d * [freq, freq-freqdiff]);
    sig = Pan2.ar(sig, pan);

    sig = sig * amp * 0.01;

    Out.ar(out, sig )
}).add;

SynthDef(\grainsin, {
    arg out=0, amp=1, freq, freqdiff=0, detune=0;
    var d = 1 + (detune / 10);
    var env, sig;

    sig = GrainSin.ar(2, 
        Dust.ar(d * freq.log2), 
        freq.log2.reciprocal * 2 , 
        d * freq, 
        0, 
        -1, 
        512
    );

    sig = sig * amp * 0.01;

    Out.ar(out, sig )
}).add;

/* --- SYNTH: out --- */
SynthDef(\out, {
    arg in, out=0, fadetime=2, amp=1.0, gate=1;
    var env, sig;

    sig = In.ar(in, 2);

    ReplaceOut.ar(out, sig * amp )
}).add;

s.plotTree;
s.meter;
)


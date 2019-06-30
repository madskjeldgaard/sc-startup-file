
(
var apctemplate= {

    var sendOSCData = true;
    var padStates = 4;
    
    (
    
    init: {|self| 
        self.setupBusses;
        self.prepareForSynths;
        self.setupController;
    },

    makeSynth: {|self|

        self.synthgroup = Group.new;

        s.makeBundle(nil, {

            // Source
            Synth.head(self.synthgroup, 
               'hehehe',
               [\freq, 440]
            );

            // All following effects etc. should be added using Synth.head

        });
    },

    prepareForSynths: {|self|
        self.synths = Array.fill2D(8,8);
    },

    // BUS SETUP
    setupBusses: {|self|
        self.controlBusses = ();

        // Slider busses
        self.controlBusses.sliders = Array.fill(9, { Bus.control(s,1)});

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
                self.controlBusses.sliders.at(sliderIndex).set(value / 128);
                self.oscSender("/slider" ++ sliderNum, value/128);
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

    // FUNCTION FOR PADS
    padFunc: {|self, row, col, state|

        self.oscSender("/padRow%Col%".format(row,col), state);

        /* "row: %, col: %, state: %".format(row,col,state).postln; */

        // Update bus
        self.controlBusses.pads[row][col].set(state);

        // Play synth
        self.synths.put(row,col, self.makeSynth());

    },

    // FUNCTION FOR BUTTONS 
    btnFunc: {|self, type, btnNo, state| 
        
        self.oscSender("/%Btn%".format(type, btnNo), state);

        /* "type: %, no: %, state: %".format(type , btnNo , state).postln; */

        // Do this if it's a horizontal button
        (type == \hor).if({
            self.controlBusses.horBtns.at(btnNo).set(state)
        });

        // Do this if it's a vertical button
        (type == \ver).if({
            self.controlBusses.verBtns.at(btnNo).set(state)
        });

    },
        
    // OSC FUNCTIONS
    oscTarget: {|self, targetAddress="127.0.0.1", targetPort=7000| 
        NetAddr.new(targetAddress, targetPort);
    },	

	oscSender: {|self, message, parameter, base="/apcmini_HELLO"|
        if (sendOSCData, {
            self.oscTarget.sendMsg(base ++ message, parameter);   
        }, 
        {"Not sending OSC data"})
	}
)};

// create an instance by calling the o objects value method to return the event
// containing the synth parts
var microtonal_organ  = apctemplate.value;

microtonal_organ.init;

/************ 

    SYNTHS 

************/

SynthDef(\organVoice, {
    arg out=0, amp=1.0, freq, effectBus, send=0,
    atk=1, sus=1, rel=1, pan=0;
    var env, sig;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);

    // Signal
    sig = SinOsc.ar([freq, freq*1.01]);
    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;

)

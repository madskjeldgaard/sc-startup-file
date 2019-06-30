/*

NAME: Granular Matrix

Description: GRANULAR INSTRUMENT FOR THE APC MINI CONTROLLER

TODO:
- Envelopes
- Filters
- Make radio buttons into scaling buttons for frequency
- Physical Modelling (gravity etc)
*/

//"~/Desktop/scripts/sc/apcmini_scripts/synthdefs.scd".standardizePath.loadRelative;

//~sf = "~/Desktop/scripts/sc/apcmini_scripts/snd/bluma9.wav".standardizePath;
~sf = "~/Desktop/scripts/sc/apcmini_scripts/snd/bluma9.wav".standardizePath;
~bach = Buffer.read(s, ~sf, startFrame: 0, numFrames: -1);

(
var apcgranular1 = {
    (
    mainSynth: {|self, x, y, state|

        // TODO HERE: MAKE GROUPS, LPF, BPF and HPF DEPENDENT ON VALUE OF BUTTON
        "Placing synth at %,%".format(x,y).postln;

        Synth.new(\apcwarp, 
            [
            \bus, 0,
            \x, x, 
            \y, y,
            \buffer, ~bach, 
            \grainsizeSlider,
            self.controlBusses.sliders.at(0).asMap,
            \overlapSlider,
            self.controlBusses.sliders.at(1).asMap,
            \randgrainSlider,
            self.controlBusses.sliders.at(2).asMap,
            \shimmerSlider, 
            self.controlBusses.sliders.at(3).asMap,
            \loopLengthSlider, 
            self.controlBusses.sliders.at(4).asMap,
            \hpf, 
            self.controlBusses.sliders.at(5).asMap,
            \q, 
            self.controlBusses.sliders.at(6).asMap,
            \freqSlider, state/4, 
            \envbuf, -1
            ]
            );
        },

    setupController: {|self| 
        var synths;
        self.controlBusses = ();
        self.controlBusses.sliders = ();

        // Initialise APC mini script
        a = APCmini.new;
        a.setPadModeAll('switch'); 
        a.setNumStatesAll(4);

        // MAP CONTROLLER VALUES TO BUSSES
        self.controlBusses.sliders = Array.fill(9, {Bus.control(s,1).set(0.25)});
        9.do{|slider| 
            a.setSliderFunction(slider, 
                {|sliderindex, slidervalue| 
                self.controlBusses.sliders.at(sliderindex).set(slidervalue/128) ;
                }
            )
        };

        self.controlBusses.verBtns = Array.fill(9, {Bus.control(s,1).set(0)});
        8.do{|verBtn| 
            2.do{|state| 
                a.setButtonFunction(\ver, verBtn, state,
                    { var value = a.verInternalState.sum;
                        self.controlBusses.verBtns.at(verBtn).set(state); // Individual button states
                        self.controlBusses.verBtns.at(8).set(value); // Sum of button states;
                    });
                }
        };

        self.controlBusses.horBtn = Array.fill(9, {Bus.control(s,1).set(0)});
        8.do{|horBtn| 
            2.do{|state|
                a.setButtonFunction(\hor, horBtn, state,
                    {self.controlBusses.horBtn.at(horBtn).set(state)});
                }
        };
        
        // Assign synths to pads
        synths = Array2D.new(8,8);
        //self.controlBusses.padStates = Array.fill2D(8,8, {Bus.control(s,1).set(0)});
        8.do{|x| 
            8.do{|y| 

                // ON STATES 1-3
                3.do{|i| 
                    var state = i+1; 

                    a.setPadFunction(x,y,state,{ 
                        //self.controlBusses.padStates.at(x,y).set(state);
                        synths.at(x,y).free;                        
                        synths.put(x, y, self.mainSynth(x,y,state)); 
                    });

                };

                // OFF
                a.setPadFunction(x,y,0,{ synths.at(x,y).free });
            }
        }
    },

    init: {|self, buffer| 
        self.setupController;
    }
    )

};
c = apcgranular1.value;
c.init;
s.meter;
s.plotTree;
)

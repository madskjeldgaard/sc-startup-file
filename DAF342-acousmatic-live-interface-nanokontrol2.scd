/*
    LAYOUT
    
    FADERS + KNOBS:
    1: VOLUME + PAN
    2: PLAYBACK RATE + ?
    3: LPF + RES
    4: HPF + RES
    5: WARP W/D + GRAINSIZE 
    6: FREQSHIFT + FREQ
    7: JPVERB W/D + ROOM
    8: VERB TIME + modDepth

    SPECTRLA FREEZE? 
*/


(


n.rBtns.do {|rBtn, i|
    rBtn.onChange = {|val|
        "This is rBtn % its value is %\n".postf(i+1, val);
    }
};

n.mBtns.do {|mBtn, i|
    mBtn.onChange = {|val|
        "This is mBtn % its value is %\n".postf(i+1, val);
    }
};

n.sBtns.do {|sBtn, i|
    sBtn.onChange = {|val|
        "This is sBtn % its value is %\n".postf(i+1, val);
    }
};

)


(
var daf342 = (
	setupMidi: {|self|
		
		n = NanoKontrol2();
		
        // FADERS 
		n.faders.do{|fader, i|

			fader.onChange = {|val|
				"This is fader % its value is %\n".postf(i+1, val);
			}
		};

        // KNOBS
        n.knobs.do{|knob, i|
            knob.onChange = {|val|
                "This is knob % its value is %\n".postf(i+1, val);
            }
        };
	},

	setupSoundFile: {|self|},
	routeSound: {|self|},
	init: {|self|

	self.setupMidi;
	},
);

daf342.init;
daf342.controlBusses.at(3).scope;

)

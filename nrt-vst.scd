( 
SynthDef(\insert, { arg bus;
    ReplaceOut.ar(bus, VSTPlugin.ar(In.ar(bus, 2), 2));  
}).add;
)

// Search system for vsts
VSTPlugin.search();

// Make a synth which will be used to hold a vst
~synth = Synth.tail(1, \vst2, [\bus, 0]);

// get a handle to the VSTPlugin:
~fx = VSTPluginController(~synth);

// open a plugin:
~fx.open("FabFilter Pro-R", info: true);

// show the GUI:
~fx.gui;

// Play a sound
( 
Ndef(\soundsource,{
    var sig = VarSaw.ar(MouseX.kr(45,800), 0, SinOsc.kr(0.01).abs + 0.5, 0.125);

    Pan2.ar(sig, LFNoise2.kr(1));
}).play;

)

// Set first parameter to something else
~fx.set(0, 0.1)

// Make some lfos to modulate some parameters
Ndef(\lfo1, {LFSaw.kr(0.01)});
Ndef(\lfo2, {LFCub.kr(0.31)});
Ndef(\lfo3, {LFPar.kr(Ndef(\lfo1))});
Ndef(\lfo4, {LFPar.kr(Ndef(\lfo3) + Ndef(\lfo1))});

Ndef(\mousey, {MouseY.kr});

// Add lfos some of the parameters
~fx.map(0, Ndef(\lfo1));
~fx.map(5, Ndef(\lfo2));
~fx.map(4, Ndef(\lfo3));
~fx.map(7, Ndef(\lfo4));
~fx.map(2, Ndef(\mousey));

/************************************

    basic nrt

*************************************/
( 
    var score = Score.new([
        [0,
            (~s01 = Synth.basicNew(\vstsynth, s)).newMsg,

        ],
        [0,
            VSTPluginController(~s01).open("FabFilter Pro-R")
        ]
    ]);

    SynthDef.new(\vstsynth, {|out=0|
        var sig = Crackle.ar;
        sig = VSTPlugin.ar(sig,  numOut: 1);
        Out.ar(out, sig);
    }).load(s);

    // end after 16 seconds
    score.add([16, [0]]);

    score.recordNRT("/tmp/trashme", "~/test.aiff".standardizePath, options: ServerOptions.new.numOutputBusChannels_(1));

    // also save the Score to a file
    score.saveToFile("~/test.sc".standardizePath);
)

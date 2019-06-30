(
    s.reboot;
    s.options.numOutputBusChannels = 24;
    s.meter;
    s.plotTree;

    s.doWhenBooted{
        ~numChans = 24;
    };
)

// Decoder
~decoder = VSTPluginController(Synth.after(1, "vst" ++ ~numChans, [\bus, 0]));
( 
    ~decoder.open("SimpleDecoder", info: true, action: 
        { ~decoder.readProgram("~/.decoders/simpledecoder.FXP".asAbsolutePath)}    
    );

)
~decoder.gui;

// Group
~group1 = Group.new;

// StereoEncoder
~stereoencoder = VSTPluginController(Synth.tail(~group1, "vst" ++ ~numChans, [\bus, 0]));
~stereoencoder.open("StereoEncoder", info: true);
// ~stereoencoder.gui;
(
    Pdef(\pat1, Pbind(
        \instrument, \noise,
        \degree, Pwhite(0,10),
        \dur, 0.1, //Pseq([0.1, Rest(0.1)], inf),
        \amp, 0.5,
        \group, ~group1,
        \addAction, \addToHead,
        \az, Psine(0.01).abs,
        \ro, Psine(0.1).abs,
        \pi, Psine(0.1598).abs,
        \pos, Pfunc({|ev|
            ~stereoencoder.set(6, ev[\az], 7, ev[\ro], 8, ev[\pi])
        })
        )).play;
)
(
    r=Routine({
        loop{
            0.1.wait;
            ~stereoencoder.set(6, { 0.0.rand(1.0) }, 7, { 0.0.rand(1.0) }, 8, { 0.0.rand(1.0) });
            (instrument: 'saw', freq: 100.rrand(1000), group: ~group1, dur:0.1).play;
        }
    });

    r.stop;
)
// Make some lfos to modulate some parameters
Ndef(\lfo1, {LFSaw.kr(0.1)});
Ndef(\lfo2, {LFCub.kr(0.55)});
Ndef(\lfo3, {LFPar.kr(Ndef(\lfo1))});
Ndef(\lfo4, {LFPar.kr(Ndef(\lfo3) + Ndef(\lfo1))});

Ndef(\mousey, {MouseY.kr});

// Add lfos some of the parameters

// Azimuth
~stereoencoder.map(6, Ndef(\lfo1));
~stereoencoder.set(8, 0.5) 


// Elevation
~stereoencoder.map(7, Ndef(\lfo2));

// Roll
~stereoencoder.map(8, Ndef(\lfo3));

~stereoencoder.map(7, Ndef(\lfo4));
~stereoencoder.map(6, Ndef(\mousey));

Synth(\noise)

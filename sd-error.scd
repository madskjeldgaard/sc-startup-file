// Supplying the freq argument with an erronous value
SynthDef(\errorSynthDef, {
    arg out=0, amp=1.0, freq = 'this should not work';

    var sig = SinOsc.ar([freq, freq*1.01]);

    Out.ar(out, sig )
}, rates:  0.1).add;

// Doesn't produce any errors
Synth(\errorSynthDef)

s.plotTree;

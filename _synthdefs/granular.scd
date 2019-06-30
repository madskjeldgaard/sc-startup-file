/**************************** 
        GRANULAR SYNTHS  
*****************************/
(
/* --- SYNTH: singrain --- */
SynthDef(\singrain, {
    arg out = 0,
    amp = 1.0,
    freq=440,
    foldLo = -1,
    foldHi = 1,
    dur=1,
    detune=1,
    send = 0,
    atk = 1,
    sus = 1,
    rel = 1,
    pan = 0;
    var env, sig;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction: 2);

    // Signal
    sig = Fold.ar(SinGrain.ar(trigger:1, dur:dur, freq: [detune*freq, freq]), foldLo, foldHi);
    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(out, sig)
	}).add;
)

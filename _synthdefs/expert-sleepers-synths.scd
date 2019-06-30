(
// Synths for use with the Expert Sleepers eurorack modules

SynthDef(\es3mono, {
    arg out=0, velocity=1.0, dur=1, note=4, gateLength=0.25, 
    atk=0, rel=0.25, t_trig=0;

    var gate, env, sig, n;

    //env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);
 	gate = EnvGen.ar(Env([0, 1, 1, 0], [0, gateLength, 0]), timeScale:dur, levelScale:velocity, gate: t_trig);
    env = EnvGen.ar(Env([0.00001, 1, 0.000001], [atk, rel], curve: 'exp'), timeScale:dur, levelScale:velocity, gate: t_trig);

	n = (0.089 / 11) * note; // Taken from Reprimandes tidal setup: https://gist.github.com/reprimande/9d6f78da364fcd7a106b6bccd9e05926 

    OffsetOut.ar(out, K2A.ar(n)); // Note value
    OffsetOut.ar(out+1, env); // Envelope output
    //OffsetOut.ar(out+2, gate); // Gate output
}).add;

)

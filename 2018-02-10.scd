(
SynthDef(\echo, { arg out=0, maxdtime=0.2, dtime=0.2, decay=2, gate=1;
    var env, in;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    in = In.ar(out, 2);
    XOut.ar(out, env, CombL.ar(in * env, maxdtime, dtime, decay, 1, in));
}).add;

SynthDef(\dropper, { arg out=0, time=1, droprate=0.01;
    var env, in;

    env = Linen.kr(1, 0.05, 1, 4.1, 2);

    in = In.ar(out, 2);

    //in = WaveLoss.ar(in:in, drop: Saw.kr(droprate).wrap(0,1) * 40, outof: 40, mode: 2);
    in = FreqShift.ar(in, freq: Saw.kr(droprate).wrap(1,2)*444, phase: 0);
    in = DFM1.ar(in, freq: 400, res: 0.1, 
        inputgain: 1, type:0, noiselevel: 0.0003); 

    XOut.ar(out, env, in);
}).add;

)

(
var p, q, r, o;

p = Pbind(\degree, Prand((0..7),14), \dur, 0.1);

q = Pn(Pfx(p, , \droprate, Pwhite(0.1,1.5, 1)), 1);

Pseq([p, q], inf).play;
)

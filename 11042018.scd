/* --- SYNTH: zzz1 --- */
SynthDef(\zzz1, {
    arg out=0, velocity=1.0, dur=1, note=4, time=0.01, 
    atk=0, rel=0.25, t_trig=0;
    var gate, env, sig, n;

    //env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);
 	gate = EnvGen.ar(Env([0, 1, 1, 0], [0, dur, 0]), gate: t_trig);
    env = EnvGen.ar(Env([0.00001, 1, 0.000001], [atk, rel]), curve: 'exp',
    timeScale:dur, levelScale:velocity, gate: t_trig);

	n = (0.089 / 11) * note; 

    OffsetOut.ar(out, K2A.ar(n));
    OffsetOut.ar(out+1, env);
    //OffsetOut.ar(out+2, gate);
}).add;

(
~p1[0] = Pmono(
    \es3,
    \degree, Pseq([0,4,5,0],inf),
    \mtranspose, Pstutter(6, Pseq([1,0,-1],inf))-3,
    \scale, Scale.major,
    \stretch, 0.125, //Pstutter(8*7, Pseq([1, 0.5],inf)),
    \atk, 0.001, //Pseq((0.1, 0.2 .. 1.0),inf),
    \velocity, Pstutter(32, Pseq((0.2,0.3..0.8),inf)),
    \rel, 1,
    \dur, Pseq([0.25, 0.5, Rest(0.5), 0.75, 0.5, Rest(0.5), 2],inf)
).trace(\dur);
~p1.fadeTime=0;
~p1.mold(3);
~p1.play(10, numChannels:3, fadeTime:0);
)
~l = {SinOsc.ar(0.001) };
~l.play(16, fadeTime:0);

(0.0, 0.1 .. 1.0).log2

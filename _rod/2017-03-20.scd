(
s.boot;
p = ProxySpace.push(s);
)
p.fadeTime = 4;

(
~s1={f = all {: x*80, x <- (1..25), x.odd }; f.size.postln; c = LFPar.kr(_);
d = Dust.kr(_); a = (1..f.size)*c.(0.25).range(0.01, 0.5); e = EnvGen.kr(Env.perc, gate: d.(a));
z = WhiteNoise.ar(); z = ComplexRes.ar(in: z, freq: f+c.(2.25))*e;
Splay.ar(DFM1.ar(z, freq: 1050, mul: 1.0), c.(0.01))
};
~s1.play(0,2)
)

p = _ * 2;
p.(3)

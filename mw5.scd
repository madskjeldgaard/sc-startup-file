(
p = ProxySpace.push(s);
p.fadeTime = 16;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
)
x = 30;
x.collect{|i| ~z[i] = ~f + ~f*i};
x.collect{|i| ~l[i] = (~i + ~i*i)/10};

(
~i = 0.258;
~f = 88.8;
~d1 = 1.001;
~d2 = {~d1+ LFTri.kr(~l[1]/10).range(0.001, 0.01)}; 
)
~pm1 = {SinOsc.ar(freq: [~z[1], ~z[1]]).range(-8pi, 8pi)};
~s1 = {SinOsc.ar(freq: [~z[3]*~d1, ~z[3]], phase: ~pm1, mul: 0.000025) };
~s1.play(2,2)
~s1.free;

~s2.play(4,2)
~s2 = {var x=2; SinOsc.ar(freq: [~z[x]*~d2, ~z[x]], phase: ~lfo1*~pm1*0.005, mul: 0.01)};
~s2.free
~fm1 = {var x=0; SinOsc.ar(freq: [~z[x], ~z[x]], phase: 0, mul: 1)};

(
~fb.play(2,2);
~fb = {var x=1; SinOscFB.ar(freq: [~z[x], ~z[x]*~d1], feedback: 0.125*~fblfo, mul: 0.275)};
~fblfo = {LFCub.kr(freq: ~l[1], mul: 0.50)};
)
~fb.free;
(
~fb2.play(4,2);
~fb2 = {var x=2; SinOscFB.ar(freq: [~z[x], ~z[x]*~d2], feedback: ~fblfo2, mul: 0.100)};
~fblfo2 = {LFTri.kr(freq: ~l[3], mul: 0.33)};
)
~fb2.free;
(
~saws.play(6,2);
~saws = {var x=5; Splay.ar(0.33*~lfo1*DFM1.ar(SawDPW.ar(freq: [~z[x+2], ~z[x+2]*~d2, ~z[x], ~z[x]*~d2], iphase: 0.85*~pm1), 100), ~pan1)};
~lfo1 = {LFCub.kr(freq: ~l[2], mul: 1, add:0.01).range(0.3,1)};
~pan1= {LFTri.kr(freq: ~l[3])};
)
~saws.free;
(
~sq.play(8,2);
~sq = {var x=5; Splay.ar(0.015*~lfo2*DFM1.ar(LFPulse.ar(freq: [~z[x+2], ~z[x+2]*~d1, ~z[x], ~z[x]*~d1], width: ~lfo1), 150), ~pan2)};
~lfo2 = {LFTri.kr(freq: ~l[5], mul: 1, add:0.01).range(0.25,1)};
~pan2= {LFTri.kr(freq: ~l[6]).range(0,1)};
)
~sq.free;
~lfo1 = {LFPar.kr(freq: 0.125, mul: 1, add: 0.1)};


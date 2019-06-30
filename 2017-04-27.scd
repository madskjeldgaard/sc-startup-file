(
p = ProxySpace.push(s);
p.fadeTime = 4;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
)
pi.sqrt/2pi
(
~dlfo = {LFPar.kr(0.101).range(0.005,0.025)};
~d = 1.0000 + ~dlfo;
~i = pi.sqrt/2pi;
~b = 32pi ;
~f[0] = ~b;
~f[1] = ~f[0] * ~d;
~f[2] = ~f[0] + (~f[0]* ~i);
~f[3] = ~f[2] * ~d;
~f[4] = ~f[2] + (~f[2]* ~i);
~f[5] = ~f[3] * ~d;
~f[5] = ~f[4] + (~f[4]* ~i);
~f[6] = ~f[5] * ~d;
~f[7] = ~f[6] + (~f[6]* ~i);
~f[8] = ~f[7] * ~d;
)
(
~l[0] = {LFPar.kr(freq: ~f[0]/100, iphase: 0, mul: 1, add: 0).range(-8pi, 8pi)};
~l[1] = {LFSaw.kr(freq: ~f[0]/10000, iphase: 0, mul: 1, add: 0).range(-8pi, 8pi)};
~l[2] = {LFCub.kr(freq: ~f[0]/1000, iphase: 0, mul: 1, add: 0).range(0.25, 3)};
~l[3] = {LFSaw.kr(freq: ~f[0]/10000, iphase: 0, mul: 1, add: 0).range(-1,1)};
~l[5] = {LFSaw.kr(freq: ~f[0]/100, iphase: 0, mul: 1, add: 0).range(-1,1)};
~l[4] = {LFSaw.kr(freq: ~f[0]/10000, iphase: 0, mul: 1, add: 0).range(0.25, 1.95)};
~l[6] = {LFCub.kr(freq: ~f[0]/1000, iphase: 0, mul: 1, add: 0).range(0.05, 0.9)};

)
//~l[0] = {0};
~s.play(2,2);
~s = {DFM1.ar(SinOsc.ar(freq: [~f[0], ~f[1]], phase: ~l[1], mul: 0.020), ~f[0], 0.96)};


~s2.play(4,2);
~s2 = {Pan2.ar(SinOscFB.ar(freq: [~f[5], ~f[6]], feedback: ~l[4], mul: 0.001), ~l[3])};

~s3.play(6,2);
~s3 = {SinOscFB.ar(freq: [~f[2], ~f[3]], feedback: 0, mul: 0.0009*~l[6])};

~s4.play(8,2);
~s4 = {DFM1.ar(Pan2.ar(SinOscFB.ar(freq: [~f[5], ~f[6]], feedback: 0.25*~l[4], mul: 0.002), ~l[5]), 1200, ~l[6])};

~s.free;
~s2.free;
~s3.free;
~s4.free;

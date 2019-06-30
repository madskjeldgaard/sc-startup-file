
(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
)
~i = 0.17; 
~d = 1.007;
~b = {100 + LFSaw.kr(~l[0]).range(0.000001, ~d)};
~d2 = { ~d + LFSaw.kr(~l[0]).range(0.000001, 0.010)};
30.collect{|i| ~f[i] = ~b + (~b * ~i * i) };
30.collect{|i| ~l[i] = 0.15/(i+1)};
(
~s0.play(2,2);
~s0 = 
{ var z, lfo = LFCub.kr([~l[0], ~l[1], ~l[0], ~l[1]]).range(0.1,0.95),
phaser=LFSaw.kr(~l[1]).range(-8pi, 8pi), cutter = LFPar.kr(~l[0]).range(1,1.25);
z = SawDPW.ar(freq: [~f[0]/2, (~f[0]/2)*~d2], iphase: 0.95*phaser);
z = DFM1.ar(z, freq: cutter*60, res: lfo, inputgain: 3.75 - cutter, type:0, noiselevel: 0.0018); 
z = Splay.ar(z, lfo[0]);
z * 0.04;
})


(
~s1.play(2,2);
~s1 = 
{ var z, lfo = LFSaw.kr([~l[0], ~l[1], ~l[0], ~l[1]]).range(0.1,0.95), phaser=LFSaw.kr(~l[0]).range(-8pi, 8pi);
z = SawDPW.ar(freq: [~f[9], ~f[9]*~d2, ~f[11], ~f[11]*~d2], iphase: phaser);
z = DFM1.ar(z, freq: 700, res: lfo, inputgain: 1.75, type:0, noiselevel: 0.0018); 
z = Splay.ar(z, 1);
z * 0.002;
})

// 2
(~s2.play(4,2);
~s2 = 
{ var z, phaser=LFSaw.kr(~l[0]).range(-8pi, 8pi), cutter = LFSaw.kr(~l[0]).range(1,2);
z = SawDPW.ar(freq: [~f[3], ~f[3]*~d2], iphase: phaser);
z = DFM1.ar(z, freq: 275*cutter, res: 0.9, inputgain: 1, type:0, noiselevel: 0.0008); 
z * 0.015;
})

// 3
(
~s3.play(6,2);
~s3 = 
{ var z;
z = SawDPW.ar(freq: [~f[6], ~f[6]*~d2], iphase: 0);
z = DFM1.ar(z, freq: 250, res: 0.7, inputgain: 1, type:0, noiselevel: 0.0008); 
z * 0.01;
})

// 4
(
~s4.play(8,2);
~s4 = 
{ var z, lfo = LFSaw.kr([~l[0], ~l[1]]).range(0.1,0.35), plfo=LFCub.kr(~l[3]).range(-8pi, 8pi);
//z = SinOscFB.ar(freq: [~f[2], ~f[2]*~d1], feedback: lfo);
z = SinOsc.ar(freq: [~f[2], ~f[2]*~d2], phase: 0.8*plfo);
z = DFM1.ar(z, freq: 550, res: 0.1, inputgain: 1, type:0, noiselevel: 0.0018); 
z * 0.005;
})

(
~s5.play(10,2);
~s5 = 
{ var z, panner = LFPar.kr(~l[0]).range(0.1,0.75);
z = SinOscFB.ar(freq: [~f[13], ~f[13]*~d2], feedback: panner);
//z = Basinski.ar(in: z, loss:0.01, lossFreq:0.5, noise:0.0);
z = DFM1.ar(z, freq: 1750, res: panner, inputgain: 1, type:0, noiselevel: 0.0015); 
z = Pan2.ar(z.sum, panner.range(-1,1));
z * 0.003;
})

(
~s6.play(2,2);
~s6 = 
{ var z, lfo = LFTri.kr([~l[0]/2, ~l[1]/2]).range(0.1,0.95),
phaser=LFSaw.kr(~l[1]).range(-8pi, 8pi), cutter = LFTri.kr(~l[0]).range(1,1.25);
z = SawDPW.ar(freq: [~f[18], (~f[18])*~d2], iphase: 0.95*phaser);
z = DFM1.ar(z, freq: cutter*20, res: lfo, inputgain: 3.75 - cutter, type:0, noiselevel: 0.0028); 
z = Splay.ar(z, lfo[0]);
z * 0.05;
})
~s6.free;

(
~s7.play(2,2);
~s7 = 
{ var z, lfo = LFTri.kr([~l[0]/2, ~l[1]/2]).range(0.1,0.95),
panner=LFTri.kr(~l[0]), cutter = LFTri.kr(~l[0]).range(1,1.75), bal=LFPar.kr(~l[0]);
z = SinOscFB.ar(freq: [~f[13], ~f[13]*~d2], feedback: 0.85*panner.range(0,1));
z = DFM1.ar(z, freq: cutter*70, res: lfo, inputgain: 3.75 - cutter, type:0, noiselevel: 0.0020); 
z = Balance2.ar(z[0], z[1], bal);
z * 0.05;
})

(
~s8.play(2,2);
~s8 = 
{ var z, lfo = LFCub.kr([~l[0], ~l[1]]).range(0.0,0.15),
panner=LFTri.kr(~l[0]), cutter = LFTri.kr(~l[0]).range(1,1.75), bal=LFCub.kr(~l[5]);
z = SinOsc.ar(freq: [~f[0]/4, (~f[0]/4)*~d2]);
z = DFM1.ar(z, freq: cutter*1900, res: lfo, inputgain: 1.0, type:0, noiselevel: 0.0020); 
z = Balance2.ar(z[0], z[1], 0*bal);
z * 0.01;
})
~s8.free;

(
p.fadeTime = 8;
~u.clear;
~d = 0.44;
~z = 1.005;
~b = 66;
10.do{|i| ~f[i] = ~b + (~b*i*~d)}; 
10.do{|i| ~q[i] = ~z*~f[i]};

~plfo = {LFCub.kr(freq: ~b/1000, iphase: 0, mul: 1, add: 0).range(-8pi, 8pi)};
~plfo2 = {LFCub.kr(freq: ~b/100, iphase: 0, mul: 1, add: 0).range(-8pi, 8pi)};
~fblfo = {LFCub.kr(freq: ~b/1000, iphase: 0, mul: 1, add: 0).range(0.05,0.75)};
~panner = {LFSaw.kr(freq: ~b/100, iphase: 0, mul: 1, add: 0).range(-1, 1)};


~s.play(2,2);
~s = {SinOsc.ar(freq: [~f[1], ~q[1]], phase: [-4pi, 8pi], mul: 0.25)};
~s.free;

~s2.play(4,2);
~s2 = {SinOsc.ar(freq: [~f[2], ~q[2]], phase: ~plfo2*0.83, mul: 0.0003)};
~s2.free;

~s3.play(6,2);
~s3 = {SinOscFB.ar(freq: [~f[5], ~q[5]], feedback: ~fblfo, mul: 0.003)};
~s3.free;

~s4.play(8,2);
~s4 = {Pan2.ar(SinOsc.ar(freq: [~f[7], ~q[7]], phase: ~plfo2*0.8, mul: 0.01), ~panner)};
~s4.free;

)

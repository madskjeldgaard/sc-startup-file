(
y = 0.125;
f = 88.8;
x = 30;
z = x.collect{|i| if(i % 5 != 0 ){(y*f*i)}};
z = z.reject({|item, i| item == nil});
z = z.reject({|item, i| item < f});
)
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
~d = {1.001 + LFPar.kr(0.5).range(0.002,0.010)};
~panlfo = {LFTri.kr(0.25).range(-1,1)};
~panlfo2 = {LFCub.kr(0.25).range(-1,1)};

~fblfo = {var x=0.01; (LFPar.kr(x) + LFTri.kr(x)).range(0.1,0.50)};
~phaser = {var x=0.0001; LFTri.kr(x).range(-4pi, 4pi)};
~phaser2 = {var x=0.001; LFTri.kr(x).range(-8pi, 8pi)};
~phaser3 = {var x=1.000; LFTri.kr(x).range(-8pi, 8pi)};


~s1.play(2,2)
~s1.stop;
~s1 = {Pan2.ar(SinOsc.ar(freq: [z[1], z[1]*~d], phase: ~phaser*2, mul: 0.025), ~panlfo)}


~fm1 ={SinOsc.ar(freq: [z[0], z[0]*~d], phase: ~phaser)}; 
~fm3 ={SinOsc.ar(freq: [z[5], z[5]*~d], phase: ~phaser)}; 
~fm2 ={SinOsc.ar(freq: [z[8], z[8]*~d], phase: ~phaser)}; 

~s2.play(4,2)
~s2.stop;
~s2 = {Pan2.kr(SinOsc.ar(freq: [z[14], z[14]*~d]*~fm1, phase: ~phaser*2, mul: 0.033), ~panlfo2)}

~s3.play(6,2)
~s3 = {Pan2.ar(SinOsc.ar(freq: [z[11], z[11]*~d]*~fm2, phase: ~phaser3, mul: 0.010), ~panlfo)}

~s4.play(8,2)
~s4 = {Pan2.kr(SinOscFB.ar(freq: [z[6], z[6]*~d], feedback: ~fblfo*0.25, mul: 0.05), ~panlfo)}

~s5.play(10,2)
~s5 = {Pan2.ar(SinOsc.ar(freq: [z[5], z[5]*~d]*~fm2, phase:~phaser2, mul: 0.009), ~panlfo2)}

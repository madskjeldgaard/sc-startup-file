(
p = ProxySpace.push(s);
p.fadeTime = 8;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
//StageLimiter.activate;
)
(
x = 10;
~i = 1/4;
~f = 77.777;
~d = 1.015 ;
x.collect{|i| ~fs[i]=~f + (~f*~i*i)};
x.collect{|i| ~ds[i]=~fs[i] * ~d};
x.collect{|i| ~lfos[i] = {LFCub.kr(freq: i+ (~f/10000) + 0.01, iphase: 0, mul: 1, add: 0) }}; 
x.collect{|i| ~panlfos[i] = {LFCub.kr(freq: i* (~f/1000) + 0.01).range(-1,1) }}; 
x.collect{|i| ~phaselfo[i] = {LFPar.kr(freq: i*(~f/100000) + 0.01).range(-8pi,8pi) }}; 
x.collect{|i| ~iii[i] = {SinOsc.ar([~fs[i], ~ds[i]], 0)*0.1}}; 
x.collect{|i| ~pii[i] = {SinOsc.ar([~fs[i], ~ds[i]], ~phaselfo[i])*0.1}}; 
x.collect{|i| ~fb[i] = {SinOscFB.ar([~fs[i], ~ds[i]], ~lfos[i] *~iii[i])*0.1}}; 
)
~z.play(4,2);
~z = ~fb[0] * 1.55;

~y.play(6,2);
~y = ~pii[5]*0.425;

~x.play(8,2);
~x.free;
~x = {Pan2.ar(~pii[9]*0.33, ~panlfos[7])};

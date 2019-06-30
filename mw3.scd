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
~d = 1.019 ;
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
~z = ~iii[0] * 0.0000125;

~y.play(6,2);
~y = ~iii[4]*0.00005;

~x.play(8,2);
~x.free;
~x = {Pan2.ar(LinXFade2.ar(~fb[9], ~pii[8], ~panlfos[9]), ~panlfos[1])*0.5};

~u.play(8,2);
~u = {LinXFade2.ar(~fb[2], ~pii[2], pan: ~panlfos[2], level: 1)*0.0009};




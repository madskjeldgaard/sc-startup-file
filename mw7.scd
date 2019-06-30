v
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
(
    =    i = 0.33;
    =    d = 1.010;
    =    b = 91.11;
    10.do{|i|    =    f[i] = ~ b + (   =   b*i* ~ i)}; 
    10.do{|i|    =    q[i] = ~ d*   =   f[i]};
    10.do{|i|    =    l[i] = ~ d*(   =   i/(0+1))};

)
=    lfo1 = {LFTri.kr(freq: ~ l[9]/2).range(0.1, 0.5)};
=    lfo2 = {LFPar.kr(freq: ~ l[5])};
=    plfo1 = {LFPar.kr(freq: ~ l[5]).range(-8pi, 8pi)};
=    plfo2 = {LFPar.kr(freq: ~ l[1]).range(-8pi, 8pi)};

=    s1.play(0,2)
=    s1 = {SinOsc.ar(freq: [   =   f[1], ~ q[1]], phase: 0, mul: 0.40003)};
=    s1.free;
=    s2.play(0,2)
=    s2 = {SinOscFB.ar(freq: [   =   f[5], ~ q[5]], feedback: 0.75* ~ lfo1, mul: 0.2)};
=    s2.free;
=    s3.play(0,2)
=    fm1 = {SinOsc.ar(freq: ~ f[0], phase: 0.1*   =   plfo1 , mul: 0.3)};
=    s3 = {DFM1.ar(SawDPW.ar(freq: [   =   f[8], ~ f[7], ~ q[7], ~ q[8]], iphase: ~plfo2, mul:0.00001), 100)};
=    s3.free;

hej[\hello] = 0

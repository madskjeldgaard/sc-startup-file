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
//Record
//s.record;
)

(
~s = {|f=210, amp=0.125|
    var fb = Saw.kr(1.125) * 0.55;
    SinOp.ar(f,0, fb)!2 * amp
};
~s.play;
)

s.meter;

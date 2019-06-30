(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
//StageLimiter.activate;
//Record
//s.record;
)


(
~s = {var ff=[55, 55*2, 55*3, 55*4, 55*5, 55*6, 55*7, 55*8, 55*9, 55*10]; SinOsc.ar(ff).sum!2/10};
~s.scope;
~s.mold(2);
~s.play(fadeTime:8);
)

(
f = all {: 110*x, x <- (1..10)};
a = 1 ; //(1.0, 0.9 .. 0.1);
~s = {SinOsc.ar(f,0,a).sum!2/20};
~s.scope;
~s.mold(2);
~s.play(fadeTime:8);
)

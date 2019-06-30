(
p=ProxySpace.push(s); p.fadeTime = 2;
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
// 02-04-2018
play{i=0.05;z=SinOsc;y=z.kr(i).wrap;f=z.kr(z.kr*i,0,120,80);AllpassC.ar(z.ar([f+1,f]).fold2([y,1-y]),2,[1,1+(y/10)]*z.kr(y.lag3*(f/1000)).wrap(0,y.lag2))}//#SuperCollider
)

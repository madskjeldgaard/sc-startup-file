/* 

TODO: 
- MAke granulars
- Haas effect / Slow chorus 

*/

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

/*** Pattern p1 for grainbuf synth ***/
~p1 = Pbind(
    \instrument, \grainbuf2, 
    \buffer, o["fbsc"][0], 
    \amp, 0.5,
    \rate, 1.0, 
    \dur, Pseq([8, 12, 16], inf),
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p1.play(fadeTime:8);

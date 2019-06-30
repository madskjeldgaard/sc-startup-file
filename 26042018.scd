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

~p1[0] = Pbind(
    //\type, \dirt,
    \type, \SuperDirt,
    \buffer, Pseq(o["zung"],inf), 
    \amp, 0.3,
    \rate, 1.0, 
    \dur, Pseq([8, 12, 16], inf),
    \loop, 1,
    \atk, 0 * Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p1.play(fadeTime:8);

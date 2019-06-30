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

~p1[0] = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pxrand(o["ea1"],inf), 
    \amp, 0.3,
    \rate, Pseq([1.0, 0.5, 0.45, 0.38],inf), 
    \dur, Pseq([3, 1, 7, 4], inf),
    \loop, 0,
    \envcurve, \exp,
    \atk, 0 * Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p1.play(fadeTime:8);

o.keys

~p2[0] = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pseq(o["percspask"],inf), 
    \amp, 0.3,
    \rate, Pseq([0.5, 1, 1.5],inf), 
    \filterenv, Pseq([0,1],inf),
    \cutoff, 500,
    \dur, Pseq([8, 12, 16], inf),
    \loop, 0,
    \atk, 0.25 * Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p2.play(fadeTime:8);

~p3[0] = Pbind(
        \instrument, \samplePlayer2, 
        \buffer, Pxrand(o["fbsc"],inf), 
        \amp, 0.1,
        \rate, 1.5, 
        \loOrHi,1,
        \cutoff, 2500,
        \stretch, Pseq([2,5,4],inf),
        \dur, Pseq([2, Rest(3), 4, 6], inf),
        \loop, 1,
        \atk, Pkey(\dur), 
        \rel, Pkey(\dur), 
        \out, 0
    );

~p3.play(fadeTime:8);

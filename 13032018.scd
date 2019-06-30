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
s.record;
)


~p1[0] = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pseq(o["perchesitant"],inf), 
    \amp, 0.3,
    \rate, Pseq([1.5, 0.5, 0.75],inf), 
    \dur, Pseq([8, 12, 16], inf),
    \loop, 0,
    \atk, 0 , 
    \rel, 1, 
    \out, 0
);
o.keys
~p1.play(fadeTime:8);

~p2[0] = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pxrand(o["percspask"],inf), 
    \amp, 0.01,
    \rate, Pstutter(17, Pseq([0.25, 0.5, 1.0],inf)), 
    \stretch, 0.25,
    \dur, 0.125*Proly(steps: 100, curve: 'log', repeats: inf),
    \loop, 0,
    \atk, 0 , 
    \rel, 0.51, 
    \out, 0
).trace(\rate);

~p2.play(fadeTime:0);

s.meter;
~p3[0] = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pseq(o["fbsc"],inf), 
    \amp, 0.3,
    \rate, 1.0, 
    \dur, Pseq([8, Rest(5), 12, 16], inf),
    \loop, 1,
    \atk, 0 * Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p3.play(fadeTime:8);

s.meter;

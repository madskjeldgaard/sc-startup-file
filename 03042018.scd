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
    \instrument, \rawsaw, 
    \degree, Pn(Pseq([
        (0,2..7),
        (1,3..7),
        (0..7)
        ], 3), inf, \deg),
    \scale, Pgate(Pseq([Scale.minor, Scale.major]), repeats: inf, key: \deg), 
    \root, 0,
    \octave, Pstutter(36, Pseq([4,3,5],inf)),
    \cutoff, 1500,
    \res, 0.7,
    \amp, 0.3,
    \stretch, 0.25+Pseq((0.1..1.0),inf),
    \dur, Pgate(Pseq([0.5, 1]), repeats: inf, key: \deg),
    \atk, 0, 
    \envcurve, \sin,
    \rel, Pkey(\dur)/4, 
    \out, 0
);

~p1.play(fadeTime:8);

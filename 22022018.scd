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

~p1 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pstutter(2, Pseq(o["fbable"],inf)), 
    \loOrHi, 1,
    \cutoff, 800,
    \filterenv, Pwrand.new([1,0], [0.25, 0.75], repeats: inf),
    \amp, 0.4,
    \rate, 0.5 * Pstutter(3, Pseq([0.25, 0.71253, 0.751234, 1.052314, 0.33],inf)), 
    \loop, Pstutter(2, Pwrand.new([0,1], [0.6, 0.4], repeats: inf)),
    \dur, Pn(pattern: Pseq([8, 4, 13],1), repeats: inf, key: \hello),
    \atk, Pgate(Pseq([0.25, 0.5, 1],inf), repeats: inf, key: \hello), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p2 = Pbindf(~p1.source, 
    \instrument, \phaseSyncSamplePlayer2_vox3,
    \buffer, Pxrand(o["fbsc"],inf), 
    \cutoff, Pseq([300, 1000, 500],inf), 
    \amp, 0.3, 
    \loop,1,
    \rate, 0.75,
    \autopan, 0.5,
    \panfreq, Pwhite(0.01, 0.001, inf),
    \stretch, 2.5,
    \atk, Pkey(\stretch) * Pkey(\dur),
    \rel, Pkey(\stretch) *  Pkey(\dur))



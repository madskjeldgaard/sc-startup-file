(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1.25;
// Activate limiter
StageLimiter.activate;
)
(
~s1 = {SinOsc.kr(freq: 0.02, phase: Rand(-2pi, 2pi), mul: 2)+1};
~s2 = {LFSaw.kr(freq: ~s1, mul: 2)+1};

~p1 = Pbind(
    \instrument, Pseq([
        \samplePlayer2,
        \unisonSamplePlayer2_vox5, 
        \shimmeringSamplePlayer2_vox3,
        \samplePlayer2,
        \spreadSamplePlayer2_vox4,
        \phaseSyncSamplePlayer2_vox5], inf), 
    \buffer, Pxrand(o["handling"] ++ o["spol"] ++ o["guitarklange"].reverse, inf, [0, 3, 7]), 
    \amp, 0.5,
    \dur, Prorate(Pseq((0.0, 0.1 .. 1.0), inf), Prand([10,20,30,1,3,6], inf)),
    \stretch, Pseq([1.5, 0.25, 0.33, 0.517, 0.5], inf),
    \rate, 0.25*Pkey(\stretch) *(Pseq([1,1,-1,1],inf)*Pkey(\dur) * Pkr(~s1)), 
    \pitchenv, Pseq([0, 1, 0, 1, 0, 0, 1, 0, 1],inf) * Pkr(~s2).wrap(0,1) * Pseq((0.0, 0.1 .. 1.0), inf),
    \filterenv, Pseq([0, 0.9, 0.5, 0.1, 0.12346, 0.61234, 0.7658491287384917],inf), 
    \cutoff, Pn(pattern: Pgeom(20, 10, 100), repeats: inf, key: nil).wrap(20,20000),
    \am, Pseq([0, 0, 0.13, 0, Pwhite(0,0.2,inf)], inf),
    \start, Pwhite(0.0,0.55, inf),
    \detune, Pbrown(lo: 0.05, hi: 0.34, step: 0.04, length: inf),
    \autopan, Pseq([0, 0, Pbrown(lo: 0, hi: 1, step: 0.125, length: inf)], inf),
    \panfreq, Pseq([1,-1],inf) * Pkey(\rate) * 0.05 * Pkey(\detune) * Prand((1..8),inf),
    \pan, Pwhite(-1.0,1.0,inf),
    \atk, Pbrown(lo: 0, hi: 1, step: 0.125, length: inf) * Pkey(\dur) / Pkr(~s1).wrap(0.1,1) ,
    \rel, Pkr(~s1).wrap(0,1) * Pkey(\dur) * Pseq([1,1,0,1,0,0],inf), 
    \envcurve, Prand([\lin, \exp, \sin, \cub, \wel, \sqr], inf),
    \out, 0
);
)
~p1.play(fadeTime:8);
~p2.play(fadeTime:8);

~p2 = Pbindf(~p1.source, \buffer, Pseq(o["guitarklange"], inf) , \pitchenv, 1, \stretch, 3);

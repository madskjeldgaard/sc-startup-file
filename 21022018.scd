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
o.keys

~p1 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pstutter(3, Pxrand(o["tense"] ++ o["omenhits"] ++ o["diablo"],inf)), 
    \amp, 0.8,
    \envcurve, Pxrand([\lin, \exp, \sin, \wel, \sqr, \cub], inf),
    \loop, Pn(Pseq([1, -1]), key: \loopkey),
    \rate, Pstutter(3, Pkrlive(~s1) * Pseq([0.25, 0.5, 0.75],inf) *
    Pgate(Pseq([1,-1],inf), repeats: inf, key: \loopkey)), 
    \dur, Pseq([4, 6, 8, 10, 12], inf),
    \cutoff, Pseq([0.25, 0.5, 1.25, 1.5],inf) * 1250,
    \hiOrLo,1,
    \filterenv, Pseq([0,1,1,1,0,0,1,1],inf),
    \pitchenv, 1-Pkey(\filterenv), 
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur)*2.0, 
    \out, 0
);

~p1.play(fadeTime:8);

~p2 = Pbind(
    \instrument, Pseq([\phaseSyncSamplePlayer2_vox3, \unisonSamplePlayer2_vox3,
        \shimmeringSamplePlayer2_vox3],inf),
    \cutoff, 1500,
    \loOrHi,0,
    \buffer, Pstutter(3, Pxrand(o["fbsc"],inf)), 
    \amp, 0.5,
    \rate, 1.5 * Pseq([-1, 1],inf) * Pstutter(3, Pkrlive(~s1) * Pseq([0.5,0.25, 0.75],inf)),
    \pitchenv, 0,
    \loop,1,
    \envcurve, Pxrand([\lin, \exp, \sin, \wel, \sqr, \cub], inf),
    \dur, Pseq([18, 7, 12, 16], inf),
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p2.play(fadeTime:8);

~s1 = {SinOsc.kr(SinOsc.kr(0.001) )};

~p3 = Pbindf(~p2.source, 
    \hiOrLo, 1,
    \rate, 1,
    \cutoff, 500,
    \dur, Pkrlive(~s1) * Pseq([12, 8, 5],inf), 
    \buffer, Pxrand(o["spol"] ,inf), 
    \atk, Pkey(\dur)/2, \loop, Pseq([1, 0],inf), \rate, 1.0, \amp, 0.5);

~p3.play(fadeTime:8);


p.proxiesPlaying

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
s.record;
)

~p1[0] = Pbind(
        \instrument, \unisonSamplePlayer2_vox3, 
        \buffer, Pxrand(o["fbsc"],inf), 
        \amp, Pseq([0.3, 0.25, 0.33],inf),
        \rate, 0.5* Pseq([0.5, 1.0, 0.75],inf), 
        \stretch, Pseq([1,2,3],inf),
        \dur, 3*Pseq([8, Rest(3), 5, Rest(3), 7], inf),
        \cutoff, 1.25*Pseq([1000, 1100, 1250, 1350, 1500, 2500],inf),
        \loop, 1,
        \envcurve, Pseq([\lin, \exp, \sin, \wel, \sqr, \cub],inf),
        \atk, Pseq([0, 1, 0.5],inf) * Pkey(\dur), 
        \rel, Pseq([0, 1, 0.5].reverse,inf) * Pkey(\dur), 
        \out, 0
    );

~p1.play(fadeTime:8);

~p2 = Pbindf(~p1.source, 
    \instrument, \phaseSyncSamplePlayer2_vox3, 
    \cutoff, 1500,
    \amp, 0.25,
    \loop, Pwrand([0,1], [0.3, 0.7], repeats: inf),
    \loOrHi,1,
    \buffer, Pxrand(o["tense"],inf)
);

~p2.play(fadeTime:8);

~p3 = Pbindf(~p1.source, 
    \stretch, 2, 
    \instrument, \samplePlayer2, 
    \dur, Pxrand([7, Rest(7), 3, 9],inf),
    \amp, 0.15,
    \rate, 1.5,
    \filterenv, Pseq([0,1,1,0,1],inf),
    \atk, Pkey(\dur), \rel, Pkey(\dur),
    \buffer, Pxrand(o["ga"],inf)
);

~p3.play(fadeTime:12);

~p1.stop(fadeTime:4); 
~p2.stop(fadeTime:4); 
~p3.stop(fadeTime:4);

~p4[0] = Pbind(
        \instrument, \samplePlayer2, 
        \buffer, Pstutter(200, Pseq(o["percemerge"],inf)), 
        \amp, 0.45,
        \rate, Pstutter(100, Pseq([0.5, 1.0],inf)), 
        \dur, Proly(steps: 100, stretch: 1, repeats: inf),
        \loop, 0,
        \atk, 0 * Pkey(\dur), 
        \rel, 0.125, 
        \envcurve, \exp,
        \out, 0
    );

~p4.play(fadeTime:8);

~p5[0] = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pseq(o["emf"],inf), 
    \amp, 0.3,
    \rate, 1.5, 
    \cutoff, 1500,
    \loOrHi, 1,
    \dur, 2*Pseq([8, 12, 16], inf),
    \loop, 1,
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p5.play(fadeTime:8);

~p1 = Pbind(
    \instrument, \phaseSyncSamplePlayer2_vox3, 
    \buffer, Pseq(o["8klange"], inf), 
    \amp, 0.3,
    \rate, 0.125, 
    \dur, 2 * Pseq([8, 12, 16], inf),
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur) / 2 , 
    \out, 0
);

~p1.play(fadeTime:8);
~p1.stop;

~p2 = Pbind(
    \instrument, \shimmeringWarpPlayer2_vox3, 
    \buffer, Pxrand(o["8klange"], inf), 
    \amp, 0.75,
    \rate, [0.2, 0.5], 
    \grainsize, Pseq([0.1, 0.5, 0.25, 0.75, 0.35],inf),
    \autopan, 0.5,
    \panfreq, Pseq([0.01, 0.051, 0.0012349, 0.0512],inf),
    \filterenv, 0.75,
    \dur, Pseq([8, 12, 16], inf) ,
    \atk, Pkey(\dur)/2, 
    \rel, Pkey(\dur)/2, 
    \out, 0
);

~p2.play(fadeTime:8);
~p2.stop;

~p3 = Pbind(
    \instrument, \shimmeringSamplePlayer2_vox3, 
    \buffer, Pseq(o["fbsc"].reverse, inf), 
    \amp, 0.3,
    \detune, 0.01,
    \rate, 0.925, 
    \dur, Pseq([17, 12, 19, 16], inf),
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur) / 2 , 
    \out, 0
);

~p3.play(fadeTime:8);

~p3.stop;


(
p = ProxySpace.push(s);
p.fadeTime = 8;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
)


~p1.play(fadeTime: 8);
~p1.stop;

/*** Pattern p1 for shimmer synth ***/
~p1 = Pbind(
    \instrument, \unisonSamplePlayer2_vox3, 
    \buffer, Pxrand(o["fbsc"].reverse, inf), 
    \rate, Pseq([0.5, 0.25, 0.125], inf) * 2,
    \detune, 0.5,
    \amp, 0.2,
    \dur, Pseq([8, 12, 16], inf) * 3,
    \atk, Pkey(\dur),
    \rel, Pkey(\dur),
    \out, 0
);

~p2 = Pbind(
    \instrument, \unisonSamplePlayer2_vox3, 
    \buffer, Pseq(o["fbsc"], inf), 
    \rate, Pseq([0.5, 0.25, 0.125], inf),
    \detune, 0.1,
    \grainsize, Pwhite(0.1, 0.5),
    \amp, 0.3,
    \dur, Pseq([8, 12, 16], inf) * 5,
    \atk, Pkey(\dur)/2,
    \rel, Pkey(\dur)/2,
    \out, 0
);

~p2.play(fadeTime: 12);

~p2.stop;

~p3 = Pbind(
    \instrument, \shimmeringSamplePlayer2_vox3, 
    \buffer, Pseq(o["8klange"].reverse, inf), 
    \rate, Pseq([0.5, 0.25, 0.125], inf) * Pseq([2, 0.5, 1.25, 1.75], inf),
    \detune, Pseq([0.5, 0.2, 0.1, 0.3], inf),
    \grainsize, Pbrown(0.1, 0.95, 0.05, inf),
    \grainrandomization, Pwhite(0.001, 0.1, inf),
    \amp, 0.4,
    \dur, Pseq([8, 12, 16], inf) * 6,
    \atk, Pkey(\dur),
    \rel, Pkey(\dur),
    \out, 0
);

~p3.play(fadeTime:16);
~p3.stop;




/*** Pattern p6 for shimmeringSamplePlayer2 synth ***/
~p6 = Pbind(
    \instrument, \shimmeringSamplePlayer2_vox3, 
    \buffer, Pseq(o["fbsc"], inf, 13), 
    \amp, 0.3,
    \rate, Pseq([0.5, 0.25, 0.75], inf),
    \detune, 0.2,
    \autopan, Pseq((1..3), inf) * 0.333,
    \panfreq, Pseq((1..3), inf) * 0.0176423,
    \dur, Pseq([8, 12, 16], inf),
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p6.play(fadeTime:12);


/*** Pattern p7 for shimmeringWarpPlayer2_vox3 synth ***/
~p7 = Pbind(
    \instrument, \shimmeringWarpPlayer2_vox3, 
    \buffer, Pseq(o["8klange"],inf), 
    \amp, 0.2,
    \rate, Pwhite(0.1, 0.75, inf), 
    \grainsize, 0.5,
    \dur, Pseq([8, 12, 16], inf) * 0.75,
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p7.play(fadeTime:12);




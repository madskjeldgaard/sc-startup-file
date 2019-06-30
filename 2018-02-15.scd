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

~s1 = {SinOsc.kr(0.1432)};
~s2 = {SinOsc.kr(~s1)};


/*** Pattern p1 for samplePlayer2 synth ***/
~p1 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pseq(o["tense"], inf), 
    \amp, 0.3,
    \detune, Pseq((0.0, 0.1 .. 0.4),inf),
    \loop, 0,
    \rate, Pseq([0.5, 0.25, 1.0], inf) * [0.25, 1] * 0.2 + Pkrlive(~s2), 
    \pitchenv,[0, 1], 
    \envcurve, Pseq([\lin, \cub, \exp],inf),
    \dur, 1.0*Pkrlive(~s2) * Pseq([2, 5, 6], inf), \atk, 0, //Pkrlive(~s2) * 0.25, 
    \rel, 1, //Pkey(\dur)/2, 
    \out, 0
);

~p1.play(fadeTime:2);

/*** Pattern p2 for phase synth ***/
~p2 = Pbind(
    \instrument, Pseq([\unisonSamplePlayer2_vox5,  \spreadSamplePlayer2_vox3,
        \shimmeringSamplePlayer2_vox3, \phaseSyncSamplePlayer2_vox3],inf), 
    \buffer, Pseq(o["fbsc"], inf), 
    \amp, 0.75,
    \rate, Pstutter(12, Pseq([0.5, 0.25, 1.0],inf)), 
    \pitchenv, 1,
    \filterenv, 1,
    \cutoff, 5000, 
    \res, 0.93,
    \dur, 0.25*Pseq([8, 12, 16], inf),
    \atk, Pkey(\dur)/8, 
    \rel, Pkey(\dur)/2, 
    \out, 0
);

~p2.play(fadeTime:8);
~p2.stop;

~p1.stop;

~p1 = Pbindf(~p2.source, \buffer, Prand(o["tense"],inf), \stretch, 2, \loop,1, \filterenv, 0, \cutoff, 250);


/*** Pattern p3 for samplePlayer2 synth ***/
~p3 = Pbind(
    \instrument, \phaseSyncSamplePlayer2_vox3, 
    \buffer, o["tense"][46], 
    \amp, 0.5,
    \rate, 0.5*Pseq([1.0, 0.5, 0.75],inf), 
    \loop, 0,
    \dur, 0.5*Pseq([3, 4, 1], inf),
    \pan, Pwhite(-1,1,inf),
    \atk, 0, //Pkey(\dur), 
    \rel, Pkey(\dur)/4, 
    \out, 0
);

~p3.play(fadeTime:2);

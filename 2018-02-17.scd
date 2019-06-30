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

~s1 = {SinOsc.kr(0.001)};

~s2 = {SinOsc.kr(~s1 * 0.5)};

~p1 = Pbind(
    \instrument, Pseq([\phaseSyncSamplePlayer2_vox3,
        \shimmeringSamplePlayer2_vox3, 
        \unisonSamplePlayer2_vox3],inf),
    \buffer, Prand(o["tensehits"], inf), 
    \detune, Pseq((0.0 .. 0.5), inf),
    \loop, Pseq([0,1,1],inf),
    \amp, 0.8,
    \start, Pkrlive(~s1, 0.0, 0.5),
    \rate, 1.5*Pseq([-1,1],inf)*Pkrlive(~s1, 0.5, 1.5) * Pseq([1, 0.5, 0.75],inf), 
    \cutoff, Pwhite(100, 300, inf) + 1200,
    \loOrHi, 1,
    \res, 0.9,
    \autopan, 1,
    \panfreq, Pseq([1,-1],inf) * Pkrlive(~s2, 0.001, 0.5),
    \envcurve, Prand([\lin, \exp, \cub, \sin],inf),
    \dur, 3*Pseq([1, 2, 1.5], inf),
    \atk, 0, // Pkey(\dur)/4, 
    \rel, Pkey(\dur)/2, 
    \out, 0
);


~p1.play(fadeTime:8);
~p1.stop;

~p2 = Pbindf(~p1.source, 
    \instrument, \samplePlayer2, 
    \dur, Pkrlive(~s2) * Pseq((4..8),inf),
    \filterenv,1,
    \cutoff, Pkrlive(~s2,1,1.5) * Pseq([500, 2500, 3000, 4000], inf),
    \loOrHi,0,
    \res, Pwhite(0.5, 0.75, inf), // hello
    \autopan, 0,
    \rate, 1.0, 
    \buffer, Prand(o["fbsc"], inf));

~p2.play(fadeTime: 8);
~p2.stop;


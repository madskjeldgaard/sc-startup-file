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

~p1[0] = Pbind(
        \instrument, \samplePlayer2, 
        \buffer, Pstutter(200, Pseq(o["percstrung"],inf)), 
        \amp, 0.5,
        \rate, Pstutter(100, Pseq([1.0, 0.5],inf)), 
        \dur, Proly(100, 1, inf),
        \loop, 0,
        \atk, 0 * Pkey(\dur), 
        \rel, 0.125 , 
        \envcurve, \exp,
        \out, 0
    );

~p1.play(fadeTime:2);


~p2[0] = Pbind(
    \instrument, \unisonSamplePlayer2_vox3, 
    \buffer, Pxrand(o["fbtape"],inf), 
    \amp, 0.2,
    \rate, 4*Pseq([0.25, 0.75, 0.33],inf), 
    \dur, Pseq([8, 12, 16], inf),
    \loop, 1,
    \cutoff , 800,
    \res, 0.75,
    \filterenv, 1,
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);
~p2[1] = \filter -> {|in| Klank.ar(`[
    [333,444,555],  // Frequencies
    [0.1, 0.1, 0.1], // Amplitudes
    [0.1, 0.1, 0.1]], // Ring times
    in,
    freqscale: 0.5, freqoffset: 0, decayscale: 0.25)*0.5}

~p2.play(fadeTime:8);

~p3[0] = Pbind(
    \instrument, \phaseSyncSamplePlayer2_vox3, 
    \buffer, Pseq(o["reflex"],inf), 
    \amp, 0.12,
    \rate, 0.5, 
    \dur, Pseq([8, Rest(3), 12, Rest(5), 16], inf),
    \loop, 1,
    \cutoff, 800, 
    \loOrHi, 1,
    \atk, 0 * Pkey(\dur), 
    \rel, Pkey(\dur), 
    \envcurve, Pseq([\lin, \exp, \sin, \wel, \sqr, \cub],inf),
    \out, 0
);

~p3.play(fadeTime:8);

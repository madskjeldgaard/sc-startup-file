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
(
l = Prewrite(1, // start with 1
        (    1: [0.25,2],
            0.25: [3,3,2]/4,
        3/4: [0.25,1,0.125,0.125],
        ), 4);

~p1[0] = Pbind(
    \instrument, \phaseSyncSamplePlayer2_vox3, 
    \buffer, Pxrand(o["fbable"][0..],inf), 
    \amp, 0.3,
    \rate, Pseq([0.25, 0.5, 1.0],inf),
    \stretch, 2*Pwrand([2,0.25], [0.8, 0.2], repeats: inf),
    \dur, l,
    \loop, 0,
    \envcurve, \exp,
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

)
(
~p1[1] = \filterIn -> {|in| Klank.ar(`[
    [444, 888, 999],  // Frequencies
    [0.1, 0.1, 0.1], // Amplitudes
    [0.1, 0.1, 0.1]], // Ring times
    in,
    freqscale: 0.25, freqoffset: 0, decayscale: 0.125)*0.25};

~p1.set(\wet1, 0.5); 
)
~p1.play(fadeTime:8);

~p2 = Pbindf(~p1.source, 
    \stretch, 2, 
    \rate, 0.3614, 
    \buffer, Pxrand(o["percemerge"], inf)
);


~p3[0] = Pbind(
        \instrument, \samplePlayer2, 
        \buffer, Pstutter(200, Pseq(o["percemerge"],inf)), 
        \amp, 0.3,
        \stretch, 2,
        \dur, Proly(100, inf),         
        \rate, Pstutter(100, Pseq([1, 0.5],inf)),
        \loop, 0,
        \atk, 0 * Pkey(\dur), 
        \rel, 0.225, 
        \envcurve, \exp,
        \out, 0
    ).trace(\dur);

~p3.play(fadeTime:1);
o["percstrung"].size;

~p4 = Pbindf(~p3.source, 
    \stretch, 3, 
    \buffer, Pstutter(200, Pseq(o["desertloops"],inf))
);

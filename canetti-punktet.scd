p.pop;
(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1.33;
// Activate limiter
StageLimiter.activate;
)
(

~s3 = {(LFCub.kr(0.0164002571324) + 1) };
~s1 = {SinOsc.kr(freq: ~s3, phase: Rand(-2pi, 2pi), mul: 2)+1};
~s2 = {LFSaw.kr(freq: ~s1, mul: 2)+1};


~p1 = Pbind(
    \instrument, Pseq([
        \samplePlayer2,
        \unisonSamplePlayer2_vox5, 
        \shimmeringSamplePlayer2_vox3,
        \samplePlayer2,
        \spreadSamplePlayer2_vox4,
        \phaseSyncSamplePlayer2_vox5], inf), 
    \buffer, Prand(o["guitarklange"] ++ o["handling"] ++ o["spol"][0..4] ++ o["guitarklange"].reverse, inf, [0, 3, 7]), 
    \amp, 0.6,
    \dur, 0.125 + (Prorate(Pseq((0.0, 0.1 .. 1.0), inf), Prand([10,20,30,1,3,6], inf))),
    \stretch, Pseq([1.5, 0.25, 0.33, 0.517, 0.5], inf),
    \rate, (0.125*Pkey(\stretch) *(Pseq([1,1,-1,1],inf)*Pkey(\dur) * Pkr(~s1)))+0.15, 
    \pitchenv, Pseq([0, 1, 0, 1, 0, 0, 1, 0, 1],inf) * Pkr(~s2).wrap(0,1) * Pseq((0.0, 0.1 .. 1.0), inf),
    \filterenv, Pseq([0, 0.9, 0.5, 0.1, 0.12346, 0.61234, 0.7658491287384917],inf), 
    \cutoff, Pseq([1000, 2000, 5000, 10000],inf),
    \am, Pseq([0, 0, 0.33, 0, Pwhite(0,0.2,3)], inf),
    \loop, Pseq([1,0,1,0,1,1,0],inf),
    \start, Pkr(~s3).wrap(0,2) * Pwhite(0.01,0.55, inf),
    \detune, Pbrown(lo: 0.05, hi: 0.34, step: 0.04, length: inf),
    \autopan, Pseq([0, 0, Pbrown(lo: 0, hi: 1, step: 0.125, length: inf)], inf),
    \panfreq, Pseq([1,-1],inf) * Pkey(\rate) * 0.05 * Pkey(\detune) * Prand((1..8),inf),
    \modfreq, Pkr(~s3).wrap(1,2) * Pbrown(lo: 100, hi: 1000, step: 10, length: inf),
    \pan, Pwhite(-0.5,0.5,inf),
    \atk, Pbrown(lo: 0.1, hi: 1, step: 0.125, length: inf) * Pkey(\dur) / Pkr(~s1).wrap(0.1,1) ,
    \rel, Pkr(~s1).wrap(0,1) * Pkey(\dur) * Pseq([1,1,0,1,0,0],inf), 
    \envcurve, Prand([\lin, \exp, \sin, \cub, \wel, \sqr], inf),
    \out, 0
);

~p2 = Pbindf(~p1.source, 
    \buffer, Prand(o["guitarklange"] ++ o["guitarobj"], inf), 
    \pitchenv, 0.851, 
    \stretch, Pkr(~s3).wrap(1,2) *Pseq([1,2, 2.52,2.3],inf)
);

~p3 = Pbindf(~p2.source, 
    \buffer, Prand(o["serge"], inf), 
    \cutoff, Pkr(~s3) * 3000,
    \amp, 0.43, 
    \stretch, Pseq([0.25, Rest(1), 0.5, Rest(9)],inf)
    );

~p4 = Pbind(
    \instrument, Pseq([\unisonSamplePlayer2_vox4, \shimmeringSamplePlayer2_vox5, \spreadSamplePlayer2_vox5],inf),
    \buffer, Pseq(o["studer"], inf),  
    \amp, 1.5,
    \rate, Pwhite(-1.1, 1.0, inf), 
    \dur, Pseq([1,1.64123,2.1234,1.36145, 1.751234], inf),
    \pitchenv, Pseq([0,0,1,1,0,1],inf),
    \pan, Pbrown(lo: -1, hi: 1, step: 0.125, length: inf),
    \loop, Pseq([0,1,1,0,1,0,0],inf),
    \autopan, 0.1,
    \stretch, Pseq((1..4), inf) * Pseq([0.5, 0.25, 0.5, 0.75, 0.952, 0.125], inf),
    \atk, 0.1,  
    \rel, Pkey(\dur), 
    \out, 0
);

)
~p1.play(fadeTime:8);
~p2.play(fadeTime:8);
~p3.play(fadeTime:8);
~p4.play(fadeTime:8);

~p4.stop;

// Pevery()
Pif(Pfunc({Ptime().round(1) % 3 == 0}), Pfunc({"true".postln}), Pfunc({"false".postln})),    


~p4.stop(fadeTime:8);


o["studer"].indexOf

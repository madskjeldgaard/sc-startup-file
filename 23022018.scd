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
s.record();

)
~s1 = {SinOsc.kr(0.01)};



o.keys;
~p1 = Pbind(
    \instrument, Pseq([
            \samplePlayer2, 
            \unisonSamplePlayer2_vox3,
            \shimmeringSamplePlayer2_vox3],inf),
    \buffer, Pxrand(o["studer"],inf), 
    \amp, 0.4,
    \cutoff, 1500,
    \loOrHi, 1,
    \rate, Pwrand([-1, 1, 1.25, -1.25], [0.3,0.3,0.2,0.2], repeats: inf), 
    \dur, Pxrand([8, 12, 16], inf),
    \loop, Pwrand([0,1], [0.7,0.3], repeats: inf),
    \atk, Pkrlive(~s1) * Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p1.play(fadeTime:8);

~p1.stop;

~p2 = Pbind(
    \instrument,
        Pseq([\unisonSamplePlayer2_vox3,\shimmeringSamplePlayer2_vox3],inf), 
    \detune, Pwhite(0.1, 0.4, inf),
    \buffer, Pxrand(o["tense"][5..],inf), 
    \amp, 0.5,
    \rate, 1.5 * Pseq([0.5, 1.0, 0.75],inf) * Pseq([1,-1],inf), 
    \dur, Pn(pattern: Pseq([8,13, 17, 9, 12,14,16],inf), repeats: inf, key: \donegate),
    \atk, Pgate(Pseq([1,0.5,0],inf), repeats: inf, key: \donegate) * Pkey(\dur), 
    \cutoff, Pwhite(0.5, 0.75,inf) * Pseq([1500, 1000, 900, 1200],inf),
    \loOrHi, 1,
    \loop, Pseq([1,0,1,1],inf),
    \rel, 1 / Pkey(\atk), 
    \out, 0
);

~p2.play(fadeTime:8);

~p5 = Pbindf(~p2.source, \instrument, \samplePlayer2, 
        \buffer, Pxrand(o["fbable"],inf),
        \rate, Pseq([1.25, -1.05, -1.2534],inf) * Pseq([0.5, 0.25, 0.33, 0.44, 0.16234], inf),
        \filterenv, 1,
        \cutoff, 900, 
        \loOrHi, 1,
        \loop, 1,
        \envcurve, Pseq([\lin, \exp, \sin, \wel, \sqr, \cub], inf),
        \cutoff, Pseq([900, 1200, 1500, 1600, 2000, 2200],inf),
        \loOrHi, 0
        ); 

~p5.play(fadeTime: 12);

~p4 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pseq(o["diablo"].reverse,inf), 
    \amp, 0.3,
    \rate, -0.5, 
    \dur, 2 * Pseq([2,5,7,4], inf),
    \envcurve, Pseq([\lin, \exp, \sin, \wel, \sqr, \cub],inf),
    \cutoff, 500,
    \loop, 1,
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p4.play(fadeTime:8);

~p3 = Pbind(
    \instrument, \unisonSamplePlayer2_vox3, 
    \cutoff, 1000, 
    \filterenv, Pseq([0,1,1,0],inf),
    \loOrHi, 0,
    \buffer, Pseq(o["omenhits"],inf), 
    \amp, 0.4,
    \rate, Pwrand([1,-1], [0.7, 0.3], repeats: inf) * 0.8753 * Pseq([1.2, 1.33, 1.5],inf), 
    \filterenv, Pwrand([0,1], [0.3, 0.7], repeats: inf),
    \stretch, Pseq([0.5, 1.0, 0.75],inf),
    \dur, Pseq([2,5,7,4], inf),
    \loop, 0,
    \atk, 0 * Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p3.play(fadeTime:8);

s.stopRecording;

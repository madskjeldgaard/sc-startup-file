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

~s1 = {SinOsc.kr(0.001)};

~p1 = Pbind(
    \instrument, \phaseSyncSamplePlayer2_vox3, 
    \buffer, Prand(o["tense"],inf), 
    \amp, 0.5,
    \rate, Pkrlive(~s1,0.5, 1.5) * Pseq([0.5, 1.0, 1.5],inf), 
    \cutoff, 800+Pseq([250, 500, 1000],inf),
    \loOrHi, 0,
    \loop, 0,
    \dur, Pseq([8, 12, 16], inf),
    \pan, Pwhite(-0.25,0.25,inf),
    \atk, Pkey(\dur) / 2,  
    \rel, Pkey(\dur), 
    \out, 0
);

~p1.play(fadeTime:2);

~p2 = Pbindf(~p1.source,\amp, 0.75, \instrument,  \unisonSamplePlayer2_vox3, \stretch, 3, \buffer, Pseq(o["vand"],inf));

~p2.play(fadeTime:2);
~p2.stop;
/*** Pattern p3 for samplePlayer2 synth ***/
~p3 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pseq(o["fbsc"],inf), 
    \amp, 0.5,
    \rate, Pkrlive(~s1, 0.25, 1.25) * Pseq([0.5, 0.25, 0.75],inf), 
    \hiOrLo, 1,
    \cutoff, 500,
    \dur, Pseq([5, 13, Rest(4), 7], inf),
    \autopan, 1,
    \panfreq, Pkrlive(~s1, 0.01, 0.1),
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p3.play(fadeTime:8);

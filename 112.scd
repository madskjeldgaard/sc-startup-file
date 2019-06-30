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
~p1 = Pbind(
    \instrument, \unisonSamplePlayer2_vox3, 
    \stretch, Pseq((1.0..1.5),inf),
    \buffer, o["fbsc"][0],
    \dur, 2*Pseq([8, 7, 6], inf),
    \envcurve, Pseq([\lin, \exp, \sin, \wel, \sqr, \cub],inf),
    \autopan, 0.5,
    \cutoff, Pseq([500, 2500, 1500, 250],inf),
    \panfreq, Pkrlive(~s1, 0.0001, 0.5),
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p1.isPlaying
~p1.play;

if (~p1.isMonitoring, {~p1.stop; "Stopping p1".postln;}, {~p1.play(fadeTime:4); "Starting p1".postln;})

~p1.play(fadeTime:8);
~p1.stop;

~s1 = {SinOsc.kr(0.01) * LFSaw.kr(0.01523)};

/*** Pattern p2 for samplePlayer2 synth ***/
~p2 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Prand(o["emf"]++o["tools"],inf), 
    \detune, Pwhite(0.1,0.25,inf),
    \amp, 0.5,
    \loOrHi,1,
    \cutoff, 2000,
    \res, 0.0, 
    \rate, Pseq([-1,1],inf) * Pseq([0.25, 0.75, 0.33],inf), 
    \panfreq, Pkey(\rate)/2,
    \envcurve, Prand([\lin, \exp, \sin, \wel, \sqr, \cub],inf),
    \autopan, 0.5,
    \dur, Pseq([8, 12, 16], inf),
    \atk, 0, 
    \rel, Pkey(\dur), 
    \out, 0
);

~p2.play(fadeTime:8);

~p2.isMonitoring


p.at(p.activeProxies[0]).stop;

p.clean

~p3.stop;


~v1 = {0.25};
~v2 = {0.125};
~v3 = {0.125};

f = 220;
~f1 = {SinOsc.ar(f*1)* ~v1}
~f1.play;

~f2 = {SinOsc.ar(f*2)* ~v2}
~f2.play;

~f3 = {SinOsc.ar(f*3)* ~v3}
~f3.play;













/*** Pattern p1 for samplePlayer2 synth ***/
~p1 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pseq(o["vand"],inf), 
    \amp, 0.5,
    \rate, 1.0, 
    \dur, Pseq([8, 12, 16], inf),
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p1.play(fadeTime:8);







~p1 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pseq(o["buffer"],inf), 
    \amp, 0.5,
    \rate, 1.0, 
    \dur, Pseq([8, 12, 16], inf),
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p1.play(fadeTime:8);

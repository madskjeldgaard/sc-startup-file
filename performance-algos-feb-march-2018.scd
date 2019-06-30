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

~d = {SinOsc.kr(0.701)};
~e = {SinOsc.kr(0.301).linlin(-1,1,0,1)};
~f = {SinOsc.kr(0.001,0,1,1.1)};


~p1 = Pbind(
    \instrument, \unisonSamplePlayer2_vox3, 
    \buffer, Pxrand(o["fbable"], inf), 
    \amp, 0.5,
    \rate, 0.5*Pkr(~d),    
    \detune, Pseq([0.1,0.25, 0.1875],inf),
    \start, Pwhite(0,0.75, inf),
    \dur, Pseq((2,4..12), inf)*Pkr(~f), 
    \atk, Pkr(~e), //Pkr(~kbus), //Pkey(\dur), 
    \rel, 4+Pkr(~e), 
    \pan, Pwhite(-1,1,inf),
    \out, 0
);

~p1.play(fadeTime:1);

~p2 = Pbind(
    \instrument, \unisonSamplePlayer2_vox3, 
    \buffer, Pxrand(o["fbable"], inf), 
    \pitchenv, 0.5,
    \amp, 0.5,
    \rate, 1.0+Pkr(~d),    
    \detune, Pseq([0.05,0.125, 0.15].reverse,inf),
    \start, Pwhite(0,0.75, inf),
    \dur, 8+(2*Pseq((2,4..12), inf)*Pkr(~f)), 
    \atk, 1+Pkr(~e), //Pkr(~kbus), //Pkey(\dur), 
    \rel, 1+(Pkey(\dur) * Pkr(~e)), 
    \pan, Pwhite(-1,1,inf),
    \out, 0
);

~p2.play(fadeTime:4);

~p3 = Pbind(
    \instrument, \shimmeringWarpPlayer2_vox3, 
    \buffer, Pxrand(o["cluster"], inf), 
    \amp, 0.5,
    \rate, 1.5+Pkr(~d),    
    \detune, Pseq([0.05,0.125, 0.15].reverse,inf),
    \start, Pwhite(0,0.75, inf),
    \dur, 7+(2*Pseq((1,3..15), inf)*Pkr(~f)), 
    \atk, 1+Pkr(~e), //Pkr(~kbus), //Pkey(\dur), 
    \rel, 1+(Pkey(\dur) * Pkr(~e)), 
    \pan, Pwhite(-1,1,inf),
    \out, 0
);

~p3.play(fadeTime:4);

~p3.stop;

~p2.stop;

~p4 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pxrand(o["gw"], inf), 
    \pitchenv, 0.5,
    \amp, Pseq([0.5, 0.25, 0.75], inf) * 0.5,
    \rate, 1.0+Pkr(~d),    
    \detune, Pseq([0.05,0.125, 0.15].reverse,inf),
    \start, Pwhite(0,0.75, inf),
    \dur, 3+(2*Pseq((2,4..12), inf)*Pkr(~f)), 
    \atk, 1+Pkr(~e), //Pkr(~kbus), //Pkey(\dur), 
    \rel, 1+(Pkey(\dur) * Pkr(~e)), 
    \pan, Pwhite(-1,1,inf),
    \out, 0
);

~p4.play(fadeTime:4);

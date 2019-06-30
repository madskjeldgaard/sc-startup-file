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

~saw1 = {LFCub.kr(0.02) * LFSaw.kr(0.001) };
~saw2 = {LFSaw.kr(0.01)};


(
~p1[0] = Pbind(
    \instrument, \samplePlayer2, 
    \detune, Pwhite(0.1, 0.5, inf),
    \buffer, Pxrand(o["desertloops"],inf), 
    \amp, 0.1,
    \rate, Pseq([0.25, 1.0, 1.75],inf), 
    \dur, Pwhite(1,2,inf) * Pseq([8, 12, 16], inf),
    \loop, 1,
    \atk, Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p1[1] = \filterIn -> {|in| SwitchDelay.ar(in, drylevel: 1, wetlevel: 1,
    delaytime: 1.34, delayfactor: 1.37, maxdelaytime: 50, mul: 1, add: 0) };
~p1.set(\wet1, 1);
~p1[2] = \filterIn -> {|in| InGrain.ar(trigger: Dust.kr(10), dur: LFNoise2.kr + 0.11, in: in)};

\filter -> {|in|  }
)

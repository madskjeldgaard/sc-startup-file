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
~p1 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pseq(o["hesitant"],inf),
    \amp, 0.3,
    \detune, 0.25,
    \rate, 1.0, 
    \dur, Pseq([2, Rest(3), 2, 7, Rest(3), 4, 6], inf),
    \stretch, Pwrand([1,2,3], [0.5, 0.25, 0.25], repeats: inf),
    \loop, 0,
    \envcurve, Pxrand([\lin, \exp, \sin, \wel, \sqr, \cub],inf),
    \pan, Pwhite(-0.5, 0.5, inf),
    \atk, 0* Pkey(\dur), 
    \rel, 0*Pkey(\dur), 
    \out, 0
);

~p1.play(fadeTime:8);

(
    
var array;

currentEnvironment.sortedKeysValuesDo({arg k, v; if (v.class == NodeProxy && v.isMonitoring) {v.postln} });


)
~p2 = Pfsmmorph(~p1.source,         
        [
            #[0,1,2], // entry states (chosen randomly)
            Pbind(\cutoff, 1100, \loOrHi, 1, \rate, Pseq([0.25, 0.9138, -2])), #[1, 1, 2], // 0
            Pbind(\pitchenv,0, \dur, Pstutter(2, Pxrand((1..3)))), #[0,2,1], // 1
            Pbind(\cutoff, 2500+Pseq([950, 600, 1100]), \rate, -0.5, \filterenv, 1), #[0, 1, 3, 2], // 2
            // terminal state
            nil, nil // 3 (if the machine reaches this state, it stops)
        ]
).trace;

~p2.play;

(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
//StageLimiter.activate;
//Record
s.record;
)

~p1 = Pbind(
    \instrument, \rawsaw, 
    \amp, 0.3,
    \freq, 110,
    \dur, Pseq([8, 12, 16], inf),
    \out, 0
);

~p1.play(fadeTime:8);



~p3 = {~p1.source <> Pbind(\atk, Pkey(\dur), \sus,0, \rel, 0)};
~p1 = ~swap.(~p1);

~p1.play;
~bi

s.meter;

(
// Browse SynthDefs
SynthDescLib.global.read;
SynthDescLib.global.browse;
)






(
{ arg dur=2;

var sig = PinkNoise.ar(0.3)!2;

var env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [dur, dur, dur], \lin), gate: 1, doneAction:2);

var movements = [
    [0,1,-1,0], // Center to right to left to center
    [0,-1,1,0], // Center to left to right to center
    [0,1,0,-1], // Center to right to center to left
    [0,0.5,0,1], // Center to halfway right to center all the way right 
    [0,-0.5,0,-1] // Center to halfway left to center all the way left 
    ];

var panenv = EnvGen.kr(Env(movements.choose, [dur-0.1, dur-0.1, dur-0.01]), gate: 1, doneAction:0);

var pan = Balance2.ar(sig[0], sig[1], pos: panenv);

panenv.poll(label:[\env1, \env2]);

Out.ar(0, pan * env);
}.play;
)





EnvGen





p.pop;
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
d = {arg degrade, pattern; Preject({  coin(degrade)}, pattern)}; 

~b1 = {SinOsc.kr(SinOsc.kr(SinOsc.kr(-0.0001, 1pi), 2pi))};

~p1 = Pbind(
    \instrument, \unisonSamplePlayer2_vox3, 
    \buffer, o["fbsc"][24],
    \rate, 0.75*Pkrlive(~b1),
    \detune, Pkrlive(~b1, 0.51, 0.1),
    \start, 0.25,
    \amp, 0.5,
    \dur, 4 * d.(0.325, Pkrlive(~b1, 0.11, 0.5) * Pseq([1, 0.52, 0.73], inf)),
    \pan, Pbrown(lo: -1, hi: 1, step: 0.21, length: inf),
    \atk, 0, 
    \rel, 0.5*Pkrlive(~b1, 0,1) * Pkey(\dur), 
    \out, 0
).trace(\pan);
)
~p1.play(fadeTime:8);

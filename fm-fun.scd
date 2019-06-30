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
//s.record;
)


SynthDef(\fmfun, {arg out=0,
            amp=0.3,
            freq = 220,
            rates = #[1,
                    1.565, 
                    2.2134, 
                    4.523, 
                    5.234, 
                    2.424, 
                    1.34],
            atks = #[0.5,
                    0.5,
                    0.25,
                    0.5,
                    0.33,
                    0],
            decs = #[1,
                    0.75,
                    0.25,
                    0.0,
                    0.33,
                    0.11],
            rels = #[0.1,
                    0.25,
                    0.25,
                    0.2,
                    0.33,
                    0.2],
            pitchenv = #[1,
                    0.5,
                    0.25,
                    0.2,
                    0.33,
                    1],
            dur;
                    
    var size = 6;

    var envs = Array.fill(size, {|i| 
                EnvGen.kr(
                    Env([0, 1.0, 0.5, 0.0], [atks[i], decs[i], rels[i]]), 
                timeScale:dur,
                doneAction:0)});

    var op1 = SinOsc.ar(freq * rates[0] ) * envs[0];
    var op2 = SinOsc.ar(freq * rates[1] * op1) * envs[1];
    var op3 = SinOsc.ar(freq * rates[2] * op2) * envs[2];

    var op4 = SinOsc.ar(freq * rates[3]) * envs[3];
    var op5 = SinOsc.ar(freq * rates[4] * op4) * envs[4];
    var op6 = SinOsc.ar(freq * rates[5] * op5 ) * envs[5];

    var sig = Mix.ar([op6, op3]) ;

    DetectSilence.ar(sig, doneAction:2);

    Out.ar(out, sig!2 * amp)
}).add;


~p1[0] = Pbind(
    \instrument, \fmfun, 
    \amp, 0.1,
    \freq, 380,
    \dur, Pseq([3,1,2],inf),
    \atks, 0!6,
    \out, 0
);

~p1.play(fadeTime:0);

(
SynthDef(\analog, { |out, gate = 1, amp = 0.1, pan = 0,
    freq = 440, detun = 1.008,
    atk = 0.01, dcy = 0.2, sus = 0.6, rel = 0.1,
    ffreq = 600, rq = 0.4, filterEgAmt = 5,
    fAtk = 0.01, fDcy = 0.1, fSus = 0, fRel = 5|

    // oscillator pair
    var sig = Saw.ar(freq * [1, detun]).sum,  // sum = mix

    // filter envelope generator
    feg = EnvGen.kr(Env.adsr(fAtk, fDcy, fSus, fRel), gate),

    // main EG (also handles cutoff = 'doneAction')
    eg = EnvGen.kr(Env.adsr(atk, dcy, sus, rel), gate, doneAction: 2);

    // apply filter EG
    ffreq = (ffreq * (feg * filterEgAmt + 1)).clip(20, 20000);

    // filter
    sig = RLPF.ar(sig, ffreq, rq);

    // stereo
    sig = Pan2.ar(sig, pan);

    Out.ar(out, sig * (amp * eg));
}).add;
)

(
TempoClock.tempo = 132/60;

p = Pbind(
    \instrument, \analog,
    \degree, Pwhite(-7, 7, inf),
    \dur, 0.25,
    \ffreq, Pseries(0.0, 0.02, inf).fold(0.0, 1.0).linexp(0, 1, 400, 12000),
    \rq, 0.1
).play;
)

p.stop;

(
TempoClock.tempo = 132/60;

p = PmonoArtic(\analog,
    \scale, Scale.locrian, \octave, 3,
    \dur, Pseq([3, 1, 1, 1, 1, 1], inf) / 4,
    \legato, Pseq([0.9, 0.2, 0.2, 1.1, 0.5, 0.2], inf),
    \degree, Pseq([0, 0, 6, 3, 9, 1], inf),
    \ffreq, Pseries(0.0, 0.02, inf).fold(0.0, 1.0).linexp(0, 1, 400, 12000),
    \rq, 0.1,
    \detun, 0.5008
).play;
)

p.stop;

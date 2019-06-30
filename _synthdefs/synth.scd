/****************************
    SYNTHS
*****************************/
/////////////
(

/* --- SYNTH: rawsaw --- */
SynthDef(\rawsaw, {
    arg out=0, amp=1.0, freq, effectBus, send=0,
    envcurve=\lin,
    atk=1, rel=1, pan=0, autopan=0, panfreq=1,
    cutoff = 5000, loOrHi=0, res=0.1, gain=1, dur;
    var env, sig, panner;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.0], [atk, rel], curve: envcurve), timeScale:
    dur, doneAction:2);

    // Signal
    sig =  SawDPW.ar(freq:freq, iphase: 0);

    sig = DFM1.ar(sig, freq: cutoff, res: res,
        inputgain: gain, type:loOrHi, noiselevel: 0.0003);

    panner = SinOsc.kr(panfreq,0,autopan).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);
    sig = Pan2.ar(sig, panner);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;

/* --- SYNTH: rawsquare --- */

SynthDef(\rawsquare, {
    arg out=0, amp=1.0, freq, effectBus, send=0, width=0.5,
    atk=1, sus=1, rel=1, pan=0, autopan=0, panfreq=1,
    cutoff = 5000, loOrHi=0, res=0.1, gain=1, dur;
    var env, sig, panner;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, sus, rel]), doneAction:2);

    // Signal
    sig =  PulseDPW.ar(freq: freq, width: width);

    sig = DFM1.ar(sig, freq: cutoff, res: res,
        inputgain: gain, type:loOrHi, noiselevel: 0.0003);

    panner = SinOsc.kr(panfreq,0,autopan).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);
    sig = Pan2.ar(sig, panner);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;


/* --- SYNTH: ringmod1 --- */
SynthDef(\ringmod1, {
    arg out=0, amp=1.0, freq=110, modfreq=freq*2, effectBus, send=0,
    atk=1, dur=1, rel=1, pan=0;
    var env, sig, modder;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);
    modder = SinOsc.ar(modfreq);

    // Signal
    sig = SinOsc.ar(freq, 0, modder);
    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;

/* --- SYNTH: fmChaos --- */
SynthDef(\fmChaos, {
    arg out=0, amp=1.0, freq, modfreq, effectBus, send=0,
    modamount=1, dur, chaosFreq=30, cutoff=5000, res=0.1, gain=1,
    atk=1, sus=1, rel=1, pan=0;
    var env, sig, modder, chaos;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

    // Signal
    modder = SinOsc.ar(modfreq,0, modamount*env);

    chaos = LorenzL.ar(freq: chaosFreq, s: 10, r: 28,
        b:2.667, h: 0.05, xi: 0.1, yi: 0, zi: 0);

    sig = SinOsc.ar([freq*modder*chaos]).fold2(4);
    sig = DFM1.ar(sig, freq: cutoff, res: res,
        inputgain: gain, type:0, noiselevel: 0.0003);
    sig = Pan2.ar(sig.sum, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;

/* --- SYNTH: sawChaos --- */
SynthDef(\sawChaos, {
    arg out=0, amp=1.0, freq, modfreq, effectBus, send=0,
    modamount=1, dur, chaosFreq=30, cutoff=1000, res=0.1, gain=1,
    atk=1, sus=1, rel=1, pan=0;
    var env, sig, modder, chaos;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

    // Signal
    modder = SinOsc.ar(modfreq,0, modamount*env);

    chaos = LorenzL.ar(freq: chaosFreq, s: 10, r: 28,
        b:2.667, h: 0.05, xi: 0.1, yi: 0, zi: 0, mul:chaosFreq);

    sig = SawDPW.ar(freq: freq+chaos, iphase: 0).cubed;
    sig = DFM1.ar(sig, freq: cutoff, res: res*modder,
        inputgain: gain, type:0, noiselevel: 0.0009);
    sig = Pan2.ar(sig, pan);

    sig = Basinski.ar(in: sig, loss:0.11, lossFreq:1.0, noise:0.3);
    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;

/* --- SYNTH: crackle1 --- */
SynthDef(\chaosCrackle1, {
  arg out=0, amp=1.0, freq, density, spread=1, effectBus, send=0,
  atk=1, dur, rel=1, pan=0, cut = 12000, res=0.85, gain=2,
  envmod=0, loOrHi=0;

  var env, sig, mod;

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

  // Signal
  mod = LinXFade2.kr(1, env, pan: envmod, level: 1);

  sig = Array.fill(3, { |i| x = i+1; Dust.ar(freq*x) + Crackle.ar(1.99, 0.6)});

  sig = DFM1.ar(sig, freq: 40 + (cut*mod) , res: res,
    inputgain: gain, type:loOrHi, noiselevel: 0.005);

  sig = Splay.ar(sig, spread, 1, pan);
  sig = sig * env * amp;
  Out.ar(effectBus, sig*send);
  Out.ar(out, sig )
}).add;

/* --- SYNTH: sine --- */
SynthDef(\sine, {
  arg out=0, amp=1.0, freq,effectBus, send=0,
  atk=1, dur=1, rel=1, pan=0;
  var env, sig;

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

  // Signal
  sig = SinOsc.ar([freq, freq*1.01]) ;
  sig = Balance2.ar(sig[0], sig[1], pan);

  sig = sig * env;

  Out.ar(effectBus, sig*send);
  Out.ar(out, sig*amp)
}).add;

/* --- SYNTH: fmClassic --- */
SynthDef(\fmClassic, {
    arg out=0, amp=1.0, freq, modfreq, effectBus, send=0,
    modamount=1, dur,
    atk=1, sus=1, rel=1, pan=0;
    var env, sig, modder;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

    // Signal
    modder = SinOsc.ar(modfreq,0, modamount*env);

    sig = SinOsc.ar(freq*modder);
    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;

/* --- SYNTH: pmClassic --- */
SynthDef(\pmClassic, {
    arg out=0, amp=1.0, freq, modfreq = freq*2, effectBus, send=0,
    pmi=1.0, mod=1.0, autopanfreq=1, autopan=0,
    atk=1, dur=1, rel=1, pan=0;
    var env, sig, modder;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

    // Signal
    modder = SinOsc.kr(autopanfreq, 0, autopan).range(-1,1);
    modder = Select.kr(autopan > 0, [0, modder]);

    sig = PMOsc.ar(freq, modfreq, pmindex: pmi, modphase: mod);
    sig = Pan2.ar(sig, pan);
    sig = Balance2.ar(sig[0], sig[1], modder);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;

/* --- SYNTH: pmPerc --- */
SynthDef(\pmPerc, {
    arg out=0, amp=1.0, freq, modfreq = freq*2, effectBus, send=0,
    pmi=1.0, mod=1.0, autopanfreq=1, autopan=0,
    cutoff=10000, res=0.0, gain=1.0,
    atk=1, dur=1, rel=1, pan=0;
    var env, sig, modder;

    // Envelope
    env = EnvGen.kr(Env.perc(atk, dur+rel), doneAction:2);

    // Signal
    modder = SinOsc.kr(autopanfreq, 0, autopan).range(-1,1);
    modder = Select.kr(autopan > 0, [0, modder]);

    sig = PMOsc.ar(freq, modfreq, pmindex: pmi, modphase: mod);
    sig = DFM1.ar(sig, freq: cutoff, res: res,
        inputgain: gain, type:0, noiselevel: 0.0007);
    sig = Pan2.ar(sig, modder);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;

/* --- SYNTH: folded1 --- */
SynthDef(\folded1, {
    arg out=0, amp=1.0, freq, effectBus, send=0,
    atk=1, dur=1, rel=1, pan=0;
    var env, sig;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

    // Signal
    sig = SinOsc.ar(freq, 0, 0.5).fold(0.11,0.9);
    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;

/* --- SYNTH: hurdy --- */
SynthDef(\hurdy, {
    arg out=0, amp=1.0, freq, effectBus, send=0, width=0.5,
    cutoff=2500, res=0.75, gain=1.5, loOrHi=0, dur=1, modlvl=0.1,
    atk=1, sus=1, rel=1, pan=0, autopan=0.25, panfreq=1, detunepercent=0.5;
    var env, sig, ampmod, panner, n=12;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 1.00, 0.75, 0.0], [atk, dur, sus, rel]), doneAction:2);

    // Signal
    ampmod = LFSaw.kr(freq/100, 0, modlvl, 1);

    sig = Array.fill(n, { |i|
        PulseDPW.ar(freq: freq * (1+i), width: width) + SawDPW.ar(freq:
            freq*(1+i)*(1+(detunepercent/100)), iphase: -1 + (i+1/n));
        });

    sig = Splay.ar(sig.sum)*ampmod;
    sig = DFM1.ar(sig, freq: cutoff, res: res,
        inputgain: gain, type:loOrHi, noiselevel: 0.0003);


    panner = SinOsc.kr(panfreq,0,autopan).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);
    sig = Balance2.ar(sig[0], sig[1], panner);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;

/* --- SYNTH: complexRes --- */
SynthDef(\complexRes, {
    arg out=0, amp=1.0, freq, effectBus, send=0, dur,
    atk=1, sus=1, rel=1, pan=0;
    var env, sig, noise;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, sus, rel]), doneAction:2);

    // Signal
    noise = WhiteNoise(0.3);
    sig = ComplexRes.ar(in: noise*env, freq: freq, // resonating frequency, can be modulated at audiorate.
        decay: 0.2);
    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;

/////////////
)


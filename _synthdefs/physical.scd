/**************************** 
    Physical modelling synths  
*****************************/
/* --- SYNTH: chaosZen --- */
(

/* --- SYNTH: klanker --- */
SynthDef(\klanker, {
    arg out=0, amp=1.0, freq, effectBus, send=0, dur,
    atk=1, sus=1, rel=0, pan=0, autopan=0, panfreq=1;
    var env, sig, frequencies, amplitudes, ringtimes, noise, panner;

    frequencies = [freq, freq*2, freq*3];
    amplitudes = nil;
    ringtimes = [dur*2,dur*2,dur*2];

    // Envelope
    env = EnvGen.kr(Env.perc(atk, dur+rel), doneAction:2);

    // Signal
    noise = WhiteNoise.ar(0.03);
    sig = DynKlank.ar(`[frequencies, amplitudes, ringtimes], noise,
        freqscale: 1, freqoffset: 0, decayscale: 1);

    panner = SinOsc.kr(panfreq,0,autopan).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);

    //sig = Splay.ar(sig);
    sig = Pan2.ar(sig, pan);
    sig = Balance2.ar(sig[0], sig[1], panner);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).store;

/* --- SYNTH: membraneHex --- */
SynthDef(\membraneHex, {
    arg out=0, amp=1.0, freq, effectBus, send=0,
    atk=1, sus=1, rel=1, pan=0;
    var env, sig;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);

    // Signal
    sig = SinOsc.ar([freq, freq*1.01]);
    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).store;

/* --- SYNTH: membraneCircle --- */
SynthDef(\membraneCircle, {
    arg out=0, amp=1.0, freq, effectBus, send=0, dur,
    atk=0, sus=0, rel=0.1, pan=0, tension=0.05;
    var env, sig, excitation;

    // Envelope
    env = EnvGen.kr(Env.perc(atk, dur+rel), doneAction:2);

    // Signal
    sig = MembraneCircle.ar(LFPulse.ar(freq)*env, tension: tension, loss: 0.99999);
    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).store;

/* --- SYNTH: membraneHex --- */
SynthDef(\membraneHex, {
    arg out=0, amp=1.0, freq, effectBus, send=0, dur,
    atk=0, sus=0, rel=0.1, pan=0, tension=0.05;
    var env, sig, excitation;

    // Envelope
    env = EnvGen.kr(Env.perc(atk, dur+rel), doneAction:2);

    // Signal
    sig = MembraneHexagon.ar(LFPulse.ar(freq)*env, tension: tension, loss: 0.99999);
    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).store;

/* --- SYNTH: plukker --- */
SynthDef(\plukker , {
    arg out=0, amp=1.0, freq, effectBus, send=0, dur,
    cutoff=2, coef=0.1, time=2, trig=1, spring=1.0, damp=0.0, 
    atk=0, sus=0, rel=0.1, pan=0, tension=0.005;
    var env, sig, excitation;

    // Envelope
    env = EnvGen.kr(Env.perc(atk, dur+rel), doneAction:2);

    // Signal
    excitation= LPF.ar(WhiteNoise.ar(0.5), freq*cutoff);

    sig = Pluck.ar(in: excitation, trig: trig, 
        maxdelaytime: freq.reciprocal, 
        delaytime: freq.reciprocal, 
        decaytime: time, coef: coef);

    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).store;


/* --- SYNTH: friction --- */
SynthDef(\friction, {
    arg out=0, amp=1.0, freq, effectBus, send=0, dur, trig=1,
    atk=0, sus=0, rel=0.1, pan=0, tension=0.05, spring=1.00, damp=0.001;
    var env, sig, excitation, t, m0, m1, m2, m3, m4;

    // Envelope
    env = EnvGen.kr(Env.perc(atk, dur+rel), doneAction:2);

    // Signal
    sig = SinOsc.ar(freq);
    sig = Friction.ar(sig, friction: 5.41322e-5, mass: 8.05501);

    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).store;

/* --- SYNTH: fmbell --- */
SynthDef(\fmbell, {
    arg out=0, amp=1.0, freq, effectBus, send=0, dur, trig=1,
    atk=0, sus=0, rel=0.1, pan=0, tension=0.05, spring=1.00, damp=0.001, q=4;
    var env, sig, excitation, t, m0, m1, m2, m3, m4;

    // Envelope
    env = EnvGen.kr(Env.perc(atk, dur+rel), doneAction:2);

    // Signal
    sig = SinOsc.ar(freq*SinOsc.ar(freq*2))*0.10;
    sig = PinkNoise.ar(0.15) + sig;

    sig = MembraneCircle.ar(sig, tension: tension, loss: 0.99999);

    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).store;

SynthDef(\marimba, {
    arg out=0, amp=1.0, freq, effectBus, send=0, dur, trig=1, 
    atk=0, sus=0, rel=0.1, pan=0, tension=0.05, spring=1.00, damp=0.001, q=0.001;
    var env, sig, excitation, rho, theta, b1, b2;

    // Envelope
    env = EnvGen.kr(Env.perc(atk, dur+rel), doneAction:2);

    // Signal
    sig = SinOsc.ar(freq*SinOsc.ar(freq*2))*0.10;
    sig = PinkNoise.ar(0.15) + sig;

    sig = MembraneCircle.ar(sig, tension: tension, loss: 0.99999);

    b1 = 1.987 * 0.9889999999 * cos(0.09);
    b2 = 0.998057.neg;

    sig = SOS.ar(K2A.ar(trig), 0.3, 0.0, 0.0, b1, b2);

    sig = RHPF.ar(sig*0.8, freq, q) +
        DelayC.ar(RHPF.ar(sig*0.9, freq*0.99999, q*0.999),
        0.02, 0.01223);

    sig = Decay2.ar(sig, 0.4, 0.3, sig);

    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).store;


)


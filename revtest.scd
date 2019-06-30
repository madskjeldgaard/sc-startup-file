/* --- SYNTH: samplePlayer2 --- */
SynthDef(\samplePlayer2, {
    arg out=0, buffer, amp=1.0, rate=1, ratescale=1, trig=1, start=0, loop=1, effectBus, send=0,
    loOrHi=0, gain=1, cut=25000, res=0, autopan=0, panfreq=1,
    channels=2, atk=1, dur=1, rel=1, pan=0;
    var env, sig, panner;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

    panner = SinOsc.kr(panfreq,0,autopan).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);
    // Signal
    sig = PlayBuf.ar(2, buffer, 
        BufRateScale.kr(buffer) * rate * ratescale, trig,
        start * BufFrames.kr(buffer), loop, doneAction:2);

    sig = Balance2.ar(sig[0], sig[1], panner);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = DFM1.ar(sig, freq: cut , res: res, 
        inputgain: gain, type:loOrHi, noiselevel: 0.005); 

    sig = sig + (MouseX.kr * JPverb.ar(sig, t60: MouseY.kr,damp: 0, size:
        MouseY.kr*3, 
        earlyDiff: 0.707, modDepth: MouseY.kr(1,0), modFreq: 2, 
        lowcut: 500, highcut: 2000));

    sig = sig * env * amp * 0.5;

    Out.ar(out, sig );
    Out.ar(effectBus, sig*send);
}).add;

/*** Pattern revpat1 for samplePlayer2 synth ***/
~revpat1 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, o["vand"][0], 
    \rate, Pseq([1.0, 1.5, 1.75],inf),
    \amp, 1.0,
    \dur, Pseq([32, 68], inf),
    \out, 0
);

~revpat1.play;

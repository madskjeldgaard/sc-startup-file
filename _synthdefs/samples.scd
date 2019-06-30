/**************************** 
        SAMPLE RELATED SYNTHS  
*****************************/

///
(

/* --- SYNTH: samplePlayer1 --- */
SynthDef(\samplePlayer1, {
    arg out=0, buffer, amp=1.0, rate=1, ratescale=1, trig=1, start=0, loop=0, effectBus=10, send=0,
    loOrHi=0, gain=1, cutoff=25000, res=0, autopan=0, autopanfreq=1,
    channels=2, atk=1, dur=1, rel=1, pan=0, envcurve='lin';
    var env, sig, modder;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel], envcurve), doneAction:2);

    // Signal
    modder = SinOsc.kr(autopanfreq, 0, autopan).range(-1,1);
    modder = Select.kr(autopan > 0, [0, modder]);

    sig = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * rate * ratescale, trig,
        start, loop, doneAction:2);
    sig = Pan2.ar(sig, modder);

    sig = DFM1.ar(sig, freq:40 +  cutoff , res: res, 
        inputgain: gain, type:loOrHi, noiselevel: 0.0); 

    sig = sig * env * amp;
    Out.ar(out, sig );
    Out.ar(effectBus, sig*send);
}).add;

SynthDef(\oneShotSamplePlayer2, {
    arg out=0, buffer, amp=1.0, rate=1, ratescale=1, trig=1, 
    start=0, loop=0, effectBus, send=0, shimmer=0,
    loOrHi=0, gain=1, cutoff=25000, res=0, autopan=0, panfreq=1, 
    pitchenv=0, pitchenvdest=0.001, filterenv=0,
    fm=0, modfreq=440, am=0, envcurve='lin',
    atk=1, dur=1, rel=1, pan=0;

    var env, sig, panner, pitchenvelope, fmmod, ammod, filterenvelope;

    // Modulation signals 
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel], envcurve), doneAction:2);

    pitchenvelope = EnvGen.kr(Env([1, pitchenvdest], [atk+dur+rel], curve: 'exp'));
    pitchenvelope = XFade2.kr(1, pitchenvelope, pitchenv.linexp(0, 1, -1, 1)); 

    filterenvelope = EnvGen.kr(Env([1, 0.001], [atk+dur+rel], curve: 'exp'));
    filterenvelope = XFade2.kr(1, filterenvelope, filterenv.linexp(0,1,-1, 1)); 

    panner = SinOsc.kr(panfreq,0,autopan).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);
    
    fmmod = SinOsc.ar(modfreq);
    fmmod = XFade2.ar(DC.ar(1), fmmod, fm.linexp(0,1, -1.00,1.00)); 

    ammod = SinOsc.ar(modfreq);
    ammod = XFade2.ar(DC.ar(1), ammod, am.linexp(0,1,-1.00,1.00)); 
    
    // Signal
    sig = PlayBuf.ar(2, buffer, 
        BufRateScale.kr(buffer) * rate * ratescale * pitchenvelope * fmmod , 
        trig, start * BufFrames.kr(buffer), loop, doneAction:2);

    sig = sig * ammod;

    sig = LeakDC.ar(sig);

    sig = Balance2.ar(sig[0], sig[1], panner);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = DFM1.ar(sig, freq: 40 + (cutoff * filterenvelope), res: res, inputgain: gain, type:loOrHi, noiselevel: 0.0); 

    sig = sig * env * amp;

    Out.ar(out, sig );
    Out.ar(effectBus, sig*send);
}).add;

SynthDef(\loopingSamplePlayer2, {
    arg out=0, buffer, amp=1.0, rate=1, ratescale=1, trig=1, 
    start=0, loop=1, effectBus, send=0, shimmer=1, end=1,
    loOrHi=0, gain=1, cutoff=25000, res=0, autopan=0, panfreq=1, 
    pitchenv=0, pitchenvdest=0.001, filterenv=0,
    fm=0, modfreq=440, am=0, envcurve='lin',
    atk=1, dur=1, rel=1, pan=0;

    var env, phase, sawrate, numFrames, sig, panner, pitchenvelope, fmmod, ammod, filterenvelope;

    // Modulation signals 
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel], envcurve), doneAction:2);

    pitchenvelope = EnvGen.kr(Env([1, pitchenvdest], [atk+dur+rel], curve: 'exp'));
    pitchenvelope = XFade2.kr(1, pitchenvelope, pitchenv.linexp(0, 1, -1, 1)); 

    filterenvelope = EnvGen.kr(Env([1, 0.001], [atk+dur+rel], curve: 'exp'));
    filterenvelope = XFade2.kr(1, filterenvelope, filterenv.linexp(0,1,-1, 1)); 

    panner = SinOsc.kr(panfreq,0,autopan).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);
    
    fmmod = SinOsc.ar(modfreq);
    fmmod = XFade2.ar(DC.ar(1), fmmod, fm.linexp(0,1, -1.00,1.00)); 

    ammod = SinOsc.ar(modfreq);
    ammod = XFade2.ar(DC.ar(1), ammod, am.linexp(0,1,-1.00,1.00)); 
    
    // Signal
    sig = LoopingSampler2.ar(buffer, rate, start, end);	

    sig = sig * ammod;

    sig = LeakDC.ar(sig);

    sig = Balance2.ar(sig[0], sig[1], panner);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = DFM1.ar(sig, freq: 40 + (cutoff * filterenvelope), res: res, inputgain: gain, type:loOrHi, noiselevel: 0.0); 

    sig = sig * env * amp;

    Out.ar(out, sig );
    Out.ar(effectBus, sig*send);
}).add;

)

/**************************** 
    Effect synths for audio busses  
*****************************/
///
(
/* --- SYNTH: jpverb --- */
SynthDef(\jpverb, {
    arg out=0, amp=1.0, time=1, damp=0, size=1, mod=0.25, modfreq=2; 
    var sig;

    sig = In.ar(out, 2); // Stereo

    // Signal
    sig = JPverb.ar(sig, t60: time,    damp: damp, size: size, 
        earlyDiff: 0.707, modDepth: mod, modFreq: modfreq, 
        lowcut: 500, highcut: 2000);

    sig = sig * amp;
    Out.ar(out, sig )
}).add;



/**************************** 
        PANNING  
*****************************/
SynthDef(\autopanner2, {
    arg out=0, amp=1.0, freq, send=0, gdur=0.3, random=1, durmod=1,
    atk=1, sus=1, rel=1, pan=0, inBus, panfreq=1, autopan=1;
    var in, sig, trigger, panner, durmodder;

    in = In.ar(inBus, 2); // Stereo

    panner = SinOsc.kr(panfreq,0,autopan).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);

    sig = in;
    sig = Pan2.ar(sig, panner);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = sig * amp;
    Out.ar(out, sig )
}).store;

SynthDef(\autopanner2Env, {
    arg out=0, amp=1.0, freq, send=0, dur, 
    atk=1, sus=1, rel=1, pan=0, inBus, panfreq=1, autopan=0;
    var in, panner, sig, env;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

    in = In.ar(inBus, 2); // Stereo

    panner = SinOsc.kr(panfreq*env,0,autopan*env).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);

    sig = in;
    sig = Pan2.ar(sig, panner);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = sig * amp;
    Out.ar(out, sig )
}).store;

/**************************** 
        MACHINE LISTENING  
*****************************/

/* --- SYNTH: amp2trig--- */
SynthDef(\amp2trig2, {
    arg out=0, inBus, threshold=0.5, aboveOrBelow=0;     

    var in, trigger, sig, aboveSig, belowSig;

    in = In.ar(inBus, 2); // Stereo

    aboveSig = threshold < Amplitude.kr(in);  
    belowSig = threshold > Amplitude.kr(in);  

    sig = Select.kr(aboveOrBelow > 0, [aboveSig, belowSig]);

    //sig = Amplitude.kr(in);
    sig.postln;    
    Out.kr(out, sig )
}).store;

/**************************** 
        GRANULAR STUFF  
*****************************/

/* --- SYNTH: ingrain --- */
SynthDef(\ingrain, {
    arg out=0, amp=1.0, freq, cutoff=0, send=0, gdur=0.3, random=1, durmod=1, dur,
    atk=1, sus=1, rel=1, pan=0, inBus, panfreq=1, autopan=0, res=0.1;
    var in, sig, trigger, panner, durmodder, env;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

    trigger = Select.kr(random > 0.99, [Impulse.kr(freq), Dust.kr(freq)]);

    panner = SinOsc.kr(panfreq,0,autopan).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);

    durmodder = SinOsc.kr(freq/10).range(1,2);

    in = In.ar(inBus, 2); // Stereo

    sig = InGrain.ar(trigger: trigger!2, dur: gdur!2*durmodder, in: [in[0], in[1]]);

    sig = Pan2.ar(sig, panner);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = DFM1.ar(sig, 20 + cutoff + LFNoise0.kr(freq*1000, 15000), LFNoise0.kr(freq*10, res));

    sig = sig * amp * env;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: concatter --- */
SynthDef(\concatter, {
    arg out=0, amp=1.0, inBus1, inBus2, send=0,
    storesize=1, seektime=1, seekdur=1,
    freezestore=0, 
    length=0.05, zcr=1, lms=1, sc=1, st=0, rand=0,
    atk=1, dur, sus=1, rel=1, pan=0;
    var env, sig, ctrl, src;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

    ctrl = In.ar(inBus1, 2); // Stereo
    src = In.ar(inBus2, 2); // Stereo

    // Signal
    sig = Concat.ar(
        ctrl, src, storesize: storesize, 
        seektime: seektime, seekdur: seekdur, matchlength: length, 
        freezestore: freezestore, zcr: zcr, lms: lms, 
        sc: sc, st: st, randscore: rand);
    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp;
    Out.ar(out, sig )
}).store;

/**************************** 
        JUST EFFECTS  
*****************************/
/* --- SYNTH: squizzer --- */
SynthDef(\squizzer, {
    arg out=0, amp=1.0, cutoff=0, send=0, gdur=0.3, dur,
    rate=2, chunks=2, 
    atk=1, sus=1, rel=1, pan=0, inBus, panfreq=1, autopan=0, res=0.1;
    var in, sig, panner, env;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

    panner = SinOsc.kr(panfreq,0,autopan).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);

    in = In.ar(inBus, 2); // Stereo

    sig = Squiz.ar(
        in,
        pitchratio: rate, // the ratio by which pitch will be raised (e.g.  pitchratio of 2 will raise by one octave)
        zcperchunk: chunks, // indicates how many positive-going zero-crossings are used to delimit a chunk. 
        memlen: gdur// the amount (in seconds) of memory the unit allocates internally to remember each fragment, i.e. the longest a given fragment can become.
    );

    sig = Pan2.ar(sig, panner);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = DFM1.ar(sig, 20 + cutoff , res);

    sig = sig * amp * env;
    Out.ar(out, sig )
}).store;


/**************************** 
        SPECTRAL STUFF  
*****************************/

/* --- SYNTH: freezer --- */
SynthDef(\freezer, {
    arg inBus, out=0, amp=1.0, freq=10;

    var env, sig, in, chain1, chain2;

    in = In.ar(inBus, 2); // Stereo

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    //random spectral freeze effect, when random numbers (generated at 10 times a second) go above 0
    sig = IFFT(PV_MagFreeze([chain1, chain2], LFNoise0.kr(freq))); 

    sig = sig * amp;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: freezerTrig --- */
SynthDef(\freezerTrig, {
    arg inBus, out=0, amp=1.0, inTrig, trig=0, atk=1, dur=1, rel=1;

    var env, sig, in, chain1, chain2, triggerIn;

    triggerIn = In.kr(inTrig, 1); 

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), gate: triggerIn, doneAction:2);

    in = In.ar(inBus, 2); // Stereo

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    //random spectral freeze effect, when random numbers (generated at 10 times a second) go above 0
    sig = IFFT(PV_MagFreeze([chain1, chain2], triggerIn)); 

    sig = sig * amp * env;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: binscrambler--- */
SynthDef(\binscrambler, {
    arg inBus, out=0, amp=1.0, freq=10;

    var env, sig, in, chain1, chain2, chain;

    in = In.ar(inBus, 2); // Stereo

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_BinScramble([chain1, chain2], wipe: LFTri.kr(freq).range(0,1), width: LFPulse.kr(freq).range(0,1) );

    sig = IFFT(chain);
    sig = sig * amp;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: binscrambler--- */
SynthDef(\binscramblerTrig, {
    arg inBus, inTrig, out=0, amp=1.0, freq=10, atk=1, dur=1, rel=1;

    var env, sig, in, chain1, chain2, chain, triggerIn;
    
    triggerIn = In.kr(inTrig, 1); 

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), gate: triggerIn, doneAction:2);

    in = In.ar(inBus, 2); // Stereo

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_BinScramble([chain1, chain2], wipe: LFTri.kr(freq).range(0,1), width: LFPulse.kr(freq).range(0,1) );

    sig = IFFT(chain);
    sig = sig * amp*env;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: rectcomb --- */
SynthDef(\rectcomb, {
    arg inBus, out=0, amp=1.0, freq=10, teeth=32, width=0.5;

    var env, sig, in, chain1, chain2, chain;

    in = In.ar(inBus, 2); // Stereo

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_RectComb( [chain1, chain2], numTeeth: teeth, phase:LFSaw.kr(freq), width:width);

    sig = IFFT(chain);

    sig = sig * amp;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: rectcombEnv --- */
SynthDef(\rectcombEnv, {
    arg inBus, out=0, amp=1.0, atk=1, rel=1, dur=1, freq=10, teeth=32, width=0.5;

    var env, sig, in, chain1, chain2, chain;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

    in = In.ar(inBus, 2); // Stereo

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_RectComb( [chain1, chain2], numTeeth: teeth, 
        phase:LFSaw.kr(freq), width:width);

    sig = IFFT(chain);

    sig = sig * amp * env;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: morph --- */
SynthDef(\morph, {
    arg inBus1, inBus2, out=0, amp=1.0, freq=10;

    var sig, in1, in2, chain1, chain2, chain;

    in1 = In.ar(inBus1, 2); 
    in2 = In.ar(inBus2, 2); 

    chain1 = FFT(LocalBuf(2048)!2, in1);	
    chain2 = FFT(LocalBuf(2048)!2, in2);

    chain = PV_Morph(chain1, chain2, SinOsc.kr(freq) );

    sig = IFFT(chain).dup;

    sig = sig * amp;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: phaseshift--- */
SynthDef(\phaseshift, {
    arg inBus, out=0, amp=1.0, freq=10;

    var sig, in, chain1, chain2, chain;

    in = In.ar(inBus, 2); 

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_PhaseShift([chain1, chain2], shift: SinOsc.kr(freq,0, 360)); 

    sig = IFFT(chain);

    sig = sig * amp;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: spectralenhance --- */
SynthDef(\spectralenhance, {
    arg inBus, out=0, amp=1.0, freq=10, ratio=2;

    var sig, in, chain1, chain2, chain;

    in = In.ar(inBus, 2); 

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_SpectralEnhance([chain1, chain2], 8, ratio, SinOsc.kr(freq).range(0,0.99) ); 

    sig = IFFT(chain);

    sig = sig * amp;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: splitbins--- */
SynthDef(\splitbins, {
    arg inBus, out=0, amp=1.0, freq=10, ratio=2;

    var sig, in, chain1, chain2, chain;

    in = In.ar(inBus, 2); 

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain1 = PV_OddBin(chain1); 
    chain1 = PV_EvenBin(chain2); 

    sig = IFFT([chain1, chain2]);

    sig = sig * amp;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: binshifter --- */
SynthDef(\binshifter, {
    arg inBus, out=0, amp=1.0, freq=10, ratio=2, shift=1, interp=0;

    var sig, in, chain1, chain2, chain;

    in = In.ar(inBus, 2); 

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_BinShift([chain1, chain2], stretch:LFSaw.kr(freq).range(0.05,1), shift:shift, interp:interp); 

    sig = IFFT(chain);

    sig = sig * amp;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: harmonic comb --- */
SynthDef(\harmoniccomb, {
    arg inBus, out=0, amp=1.0, freq=10, ratio=2, shift=1, interp=0,
     width=0.25, teeth=8;

    var sig, in, chain1, chain2, chain, freqs, teeths;

    freqs = Array.fill(10, {|i| freq*(1+i)});
    teeths= Array.fill(10, {|i| teeth*(1+i)});

    in = In.ar(inBus, 2); 

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_RectComb( [chain1, chain2], numTeeth: teeth, 
        phase:LFSaw.kr(freqs), width:width);

    sig = IFFT(chain);

    sig = sig * (amp/10);
    Out.ar(out, sig )
}).store;

/* --- SYNTH: diffuser --- */
SynthDef(\diffuser, {
    arg inBus, out=0, amp=1.0, freq=10, ratio=2, shift=1, interp=0, maxdelay=2;

    var sig, in, chain1, chain2, chain;

    in = In.ar(inBus, 2); 

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_Diffuser([chain1, chain2], trig: Dust.kr(freq));

    sig = IFFT(chain);
    Out.ar(out, sig);

    sig = sig * amp;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: magfreezer --- */
SynthDef(\magfreezer, {
    arg inBus, out=0, amp=1.0, freq=10;

    var sig, in, chain1, chain2, chain;

    in = In.ar(inBus, 2); 

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_MagFreeze([chain1, chain2], freeze: Dust.kr(freq));

    sig = IFFT(chain);
    Out.ar(out, sig);

    sig = sig * amp;
    Out.ar(out, sig )
}).store;


/* --- SYNTH: magsmear --- */
SynthDef(\magsmear, {
    arg inBus, out=0, amp=1.0, freq=10, maxbins=100;

    var sig, in, chain1, chain2, chain;

    in = In.ar(inBus, 2); 

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_MagSmear([chain1, chain2], bins: LFTri.kr(freq).range(0,maxbins));

    sig = IFFT(chain);
    Out.ar(out, sig);

    sig = sig * amp;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: randcomb --- */
SynthDef(\randcomb, {
    arg inBus, out=0, amp=1.0, freq=10, maxbins=100;

    var sig, in, chain1, chain2, chain;

    in = In.ar(inBus, 2); 

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_RandComb([chain1, chain2], wipe: LFTri.kr(freq), trig: Dust.kr(freq));

    sig = IFFT(chain);
    Out.ar(out, sig);

    sig = sig * amp;
    Out.ar(out, sig )
}).store;

/* --- SYNTH: randwipe --- */
SynthDef(\randwipe, {
    arg inBus1, inBus2, out=0, amp=1.0, freq=10;

    var sig, in1, in2, chain1, chain2, chain3, chain4, chain;

    in1 = In.ar(inBus1, 2); 
    in2 = In.ar(inBus2, 2); 

    chain1 = FFT(LocalBuf(2048), in1[0]);	
    chain2 = FFT(LocalBuf(2048), in1[1]);

    chain3 = FFT(LocalBuf(2048), in2[0]);	
    chain4 = FFT(LocalBuf(2048), in2[1]);

    chain = PV_RandWipe([chain1, chain2], [chain3,chain4], LFTri.kr(freq), Dust.kr(freq));

    sig = IFFT(chain);
    Out.ar(out, sig);

    sig = sig * amp;
    Out.ar(out, sig )
}).store;


/* --- SYNTH: spectralVoid --- */
SynthDef(\spectralVoid, {
    arg out=0, inBus, amp=1.0, freq=0.1, send=0, dur, autopan=0.1,
    panfreq=1, cutoff=20000, loOrHi=1, res=0.1, gain=1, 
    atk=1, sus=1, rel=1, pan=0, stretch=10, shift=1, teeth=16, phase=0,
    width=0.2;

    var sig, in, chain1, chain2, chain, stretchs, panner, wipeL, wipeR;

    // Signal
    in = In.ar(inBus, 2); 

    chain1 = FFT(LocalBuf(2048), in[0]);	
    chain2 = FFT(LocalBuf(2048), in[1]);

    chain = PV_BinScramble([chain1, chain2], wipe: LFSaw.kr(freq).range(0,1), width: width);

    wipeL = PV_Diffuser(chain, trig: 1);

    wipeR = PV_RectComb(chain, numTeeth:stretch*teeth, phase: phase, width: width);

    chain = PV_RandWipe(wipeL, wipeR, SinOsc.kr(freq), Dust.kr(freq));

    chain = PV_RandWipe(chain, PV_MagFreeze(chain, freeze: Dust.kr(freq)), LFTri.kr(freq), Dust.kr(freq/10));

    sig = IFFT(chain);
    
    panner = SinOsc.kr(panfreq,0,autopan).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);

    sig = Splay.ar(sig);
    sig = Pan2.ar(sig, panner);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = DFM1.ar(sig, freq: Line.kr(20, cutoff, atk+dur+rel), res: res, 
        inputgain: gain, type:loOrHi, noiselevel: 0.0003);

    sig = sig * amp;

    Out.ar(out, sig )
}).add;


)


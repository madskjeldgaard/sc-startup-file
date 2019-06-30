(
var number_of_voices = 8;

/*

These are Sample players with unison effects inspired by (Ableton's) wavetable synthesizers 

All of the synthdefs have a suffix ala _vox# where # is the number of voices in
the unison effect. Which means "unisonSamplePlayer2_vox5" has 5 voices for
example. If you want more or you can increase the number_of_voices variable.

The most important arguments in each are detune and rate which both have
significant effect on the unison.

*/

number_of_voices.do{|i| x = 1+i;

    /* --- SYNTH: unisonSamplePlayer2 ,--- */
    SynthDef("unisonSamplePlayer2_vox%".format(x), {
        arg out=0, buffer, amp=1.0, rate=1, ratescale=1, trig=1, 
        start=0, loop=1, effectBus, send=0, detune=0.5,
        loOrHi=0, gain=1, cutoff=25000, res=0, autopan=1, panfreq=1, 
        pitchenv=0, pitchenvdest=0.001, filterenv=0,
        fm=0, modfreq=440, am=0,
        atk=1, dur=1, rel=1, pan=0, envcurve='lin';

        var env, sig, panner, pitchenvelope, fmmod, ammod, filterenvelope, detunes,
        voices=x, offsets;

        // Modulation signals 
        env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel], envcurve), doneAction:2);

        pitchenvelope = EnvGen.kr(Env([1, pitchenvdest], [atk+dur+rel], curve: 'exp'));
        pitchenvelope = XFade2.kr(1, pitchenvelope, pitchenv.linexp(0, 1, -1, 1)); 

        filterenvelope = EnvGen.kr(Env([1, 0.1], [atk+dur+rel], curve: 'exp'));
        filterenvelope = XFade2.kr(1, filterenvelope, filterenv.linexp(0,1,-1, 1)); 

        panner = SinOsc.kr(panfreq * (1..voices) * detune ,0,autopan);
        panner = Select.kr(autopan > 0, [0, panner]);
        
        fmmod = SinOsc.ar(modfreq);
        fmmod = XFade2.ar(DC.ar(1), fmmod, fm.linexp(0,1, -1.00,1.00)); 

        ammod = SinOsc.ar(modfreq);
        ammod = XFade2.ar(DC.ar(1), ammod, am.linexp(0,1,-1.00,1.00)); 
        
        detunes = Array.fill(voices, {|i| 1 + ((i + detune)/(voices*10))});

        // Signal
        sig = PlayBuf.ar(2, buffer, 
            BufRateScale.kr(buffer) * rate * ratescale * pitchenvelope * fmmod * detunes, 
            trig, start * BufFrames.kr(buffer), loop, doneAction:2) / voices;

        sig = sig * ammod;

        sig = LeakDC.ar(sig);
   
        sig = Splay.ar(sig);         

        sig = DFM1.ar(sig, freq: 40 + (cutoff * filterenvelope), res: res, inputgain: gain, type:loOrHi, noiselevel: 0.0); 
        
        //sig = Balance2.ar(sig[0], sig[1], panner);
        //sig = Balance2.ar(sig[0], sig[1], pan);

        sig = Pan2.ar(sig, pan);

        sig = sig * env * amp;

        Out.ar(out, sig );
        Out.ar(effectBus, sig*send);
    }).add;

    /* --- SYNTH: phaseSyncSamplePlayer2,--- */
    SynthDef("phaseSyncSamplePlayer2_vox%".format(x), {
        arg out=0, buffer, amp=1.0, rate=1, ratescale=1, trig=1, 
        start=0, loop=1, effectBus, send=0, detune=0.5,
        loOrHi=0, gain=1, cutoff=25000, res=0, autopan=1, panfreq=1, 
        pitchenv=0, pitchenvdest=0.001, filterenv=0,
        fm=0, modfreq=440, am=0,
        atk=1, dur=1, rel=1, pan=0, envcurve='lin';

        var env, sig, panner, pitchenvelope, fmmod, ammod, filterenvelope, detunes,
        voices=x;

        // Modulation signals 
        env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel], envcurve), doneAction:2);

        pitchenvelope = EnvGen.kr(Env([1, pitchenvdest], [atk+dur+rel], curve: 'exp'));
        pitchenvelope = XFade2.kr(1, pitchenvelope, pitchenv.linexp(0, 1, -1, 1)); 

        filterenvelope = EnvGen.kr(Env([1, 0.001], [atk+dur+rel], curve: 'exp'));
        filterenvelope = XFade2.kr(1, filterenvelope, filterenv.linexp(0,1,-1, 1)); 

        panner = SinOsc.kr(panfreq * (1..voices) * detune * rate * 3, voices.mod(2pi), autopan/2);
        panner = Select.kr(autopan > 0, [0, panner]);
        
        fmmod = SinOsc.ar(modfreq);
        fmmod = XFade2.ar(DC.ar(1), fmmod, fm.linexp(0,1, -1.00,1.00)); 

        ammod = SinOsc.ar(modfreq);
        ammod = XFade2.ar(DC.ar(1), ammod, am.linexp(0,1,-1.00,1.00)); 
        
        detunes = Array.fill(voices, {|i| 1 + ((i + detune)/(voices*10))});

        // Signal
        sig = BufRd.ar(2, buffer,
            LFSaw.ar(rate*detunes*BufDur.ir(buffer).reciprocal).range(0,
                BufFrames.ir(buffer))) / voices; 

        sig = sig * ammod;

        sig = LeakDC.ar(sig);

        sig = Splay.ar(sig);

        sig = DFM1.ar(sig, freq: 40 + (cutoff * filterenvelope), res: res, inputgain: gain, type:loOrHi, noiselevel: 0.0); 

        //sig = Balance2.ar(sig[0], sig[1], panner);
        sig = Balance2.ar(sig[0], sig[1], pan);

        sig = sig * env * amp;

        Out.ar(out, sig );
        Out.ar(effectBus, sig*send);
    }).add;

    /* --- SYNTH: shimmeringSamplePlayer2,--- */
    SynthDef("shimmeringSamplePlayer2_vox%".format(x), {
        arg out=0, buffer, amp=1.0, rate=1, ratescale=1, trig=1, 
        detune=0.1, shimscale=15,
        start=0, loop=1, effectBus, send=0, 
        loOrHi=0, gain=1, cutoff=25000, res=0, autopan=0, panfreq=1, 
        pitchenv=0, pitchenvdest=0.001, filterenv=0, envcurve='lin',
        fm=0, modfreq=440, am=0,
        atk=1, dur=1, rel=1, pan=0;

        var env, sig, panner, pitchenvelope, fmmod, ammod, filterenvelope, shim,
        voices=x, offsets;

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
        
        shim = Array.fill(voices, {LFNoise1.kr(110).linlin(-1,1,1.0, 1.00 + (detune/10))});
        
        offsets = Array.fill(voices, {|i| x = i+1; i/((1+detune)*shimscale)});

        // Signal
        sig = PlayBuf.ar(2, buffer, 
            BufRateScale.kr(buffer) * rate * ratescale * pitchenvelope * fmmod * shim, 
            trig, (offsets + start) * BufFrames.kr(buffer), loop, doneAction:2) / voices;

        sig = sig * ammod;

        sig = LeakDC.ar(sig);

        sig = Splay.ar(sig);

        sig = Balance2.ar(sig[0], sig[1], panner);
        sig = Balance2.ar(sig[0], sig[1], pan);

        //sig = LPF.ar(sig, 40 + (cutoff * filterenvelope));

        sig = DFM1.ar(sig, freq: 40 + (cutoff * filterenvelope), res: res, inputgain: gain, type:loOrHi, noiselevel: 0.0); 

        sig = sig * env * amp;

        Out.ar(out, sig );
        Out.ar(effectBus, sig*send);
    }).add;

    /* --- SYNTH: spreadSamplePlayer2,--- */
    SynthDef("spreadSamplePlayer2_vox%".format(x), {
        arg out=0, buffer, amp=1.0, rate=1, ratescale=1, trig=1, 
        start=0, loop=1, effectBus, send=0, detune=0.5,
        loOrHi=0, gain=1, cutoff=25000, res=0, autopan=0, panfreq=1, 
        pitchenv=0, pitchenvdest=0.001, filterenv=0,
        fm=0, modfreq=440, am=0,
        atk=1, dur=1, rel=1, pan=0, envcurve='lin';

        var env, sig, panner, pitchenvelope, fmmod, ammod, filterenvelope, detunes,
        voices=x, offsets;

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
        
        detunes = Array.fill(voices, {|i| 1 + ((i + detune)/(voices*10))});

        offsets = Array.fill(voices, {|i| x = i+1;
            BufFrames.ir(buffer)/((1+detune)*x*100)});

        // Signal
        sig = BufRd.ar(2, buffer, offsets +
            LFSaw.ar(rate*detunes*BufDur.ir(buffer).reciprocal).range(0,
                BufFrames.ir(buffer))) / voices; 

        sig = sig * ammod;

        sig = LeakDC.ar(sig);

        sig = Splay.ar(sig);

        sig = Balance2.ar(sig[0], sig[1], panner);
        sig = Balance2.ar(sig[0], sig[1], pan);

        sig = DFM1.ar(sig, freq: 40 + (cutoff * filterenvelope), res: res, inputgain: gain, type:loOrHi, noiselevel: 0.0); 

        sig = sig * env * amp;

        Out.ar(out, sig );
        Out.ar(effectBus, sig*send);
    }).add;
    
    /* --- SYNTH: shimmeringWarpPlayer2,--- */
    SynthDef("shimmeringWarpPlayer2_vox%".format(x), {
        arg out=0, buffer, amp=1.0, rate=1, ratescale=1, trig=1,  
        detune=0.1, shimscale=15, 
        grainsize=0.25, grainrandomization=0.01, // These arguments are specific to the warp players
        start=0, loop=1, effectBus, send=0, 
        loOrHi=0, gain=1, cutoff=25000, res=0, autopan=0, panfreq=1, q=2, 
        pitchenv=0, pitchenvdest=0.001, filterenv=0,
        fm=0, modfreq=440, am=0,
        atk=1, dur=1, rel=1, pan=0, envcurve='lin';

        var env, sig, panner, pitchenvelope, fmmod, ammod, filterenvelope, shim,
        voices=x, offsets, pointer;

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
        
        shim = Array.fill(voices, {LFNoise1.kr(110).linlin(-1,1,1.0, 1.00 + (detune/100))});
        
        offsets = Array.fill(voices, {|i| x = i+1; i/((1+detune)*shimscale)});

        // Signal
        pointer = offsets + LFSaw.ar(fmmod * rate*BufDur.ir(buffer).reciprocal).range(0, BufFrames.ir(buffer));

        sig =  Warp1.ar(2, bufnum: buffer, pointer: pointer, freqScale: rate,
            windowSize: grainsize, envbufnum: -1, overlaps: 8, windowRandRatio:
            grainrandomization, interp: 4) / voices;

        sig = sig * ammod;

        sig = BPF.ar(sig, 20 + ((rate + offsets) * 1000 * filterenv), q); 

        sig = LeakDC.ar(sig);

        sig = Splay.ar(sig);

        sig = Balance2.ar(sig[0], sig[1], panner);
        sig = Balance2.ar(sig[0], sig[1], pan);

        sig = sig * env * amp;

        Out.ar(out, sig );
        Out.ar(effectBus, sig*send);
    }).add;



};
)

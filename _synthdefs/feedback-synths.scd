(
// FEEDBACK BUS
~feedbackbus = Bus.audio(s, 2); 


// 
SynthDef('mousefb1', {
    arg out=0, feedbackBus=~feedbackbus, allocationtime = 60.0,
    delaytime=0.1, decaytime=2.0, pan=0, amp=0.1,
    cutoff=20000, res=0.0, loOrHi=0;

    var feedbackIn, chain1, chain2, sig, src, parallelchains;
    
    // Excite the feedback loop to make sound
    src = Clip.ar(WhiteNoise.ar(10.00) * Lag.kr(Impulse.kr(0.01).range(0.0, 1.0), 0.5));

    // Get feedback input from audio bus
    // InFeedback is necessarry to prevent the audio data from the previous
    // cycle  on the bus being overwritten
    feedbackIn = InFeedback.ar(feedbackBus, 2);
    
    // Add delay
    sig = Mix.ar(Array.fill(3, {|i| 
        Pan2.ar(
                CombC.ar(feedbackIn+src, allocationtime, MouseY.kr(0.1,1)*delaytime*(1+i), decaytime)/3, 
            1 - 2.rand)})); // Random panning 

    // PROCESS THE FEEDBACK

    chain1 = FFT(LocalBuf(2048), sig);
    chain1 = PV_BinShift(chain1, MouseX.kr(0.25,4, \exponential));

    chain2 = FFT(LocalBuf(2048), sig);
    chain2 = PV_Freeze(chain2, MouseY.kr < 0.5);

    
    // Set up parallel effects chain
    parallelchains = [sig, 
        3*IFFT(chain2)!2, 
        3*IFFT(chain1)!2,
        InGrain.ar(trigger: Impulse.ar(MouseY.kr(0.1, 100)), dur: MouseX.kr(0.01, 1), in: sig)!2,
        FreqShift.ar(sig, MouseY.kr(2,0.2, \exponential)*[440, 880, 1220], 2pi.rand)];
    
    sig = Mix.ar(parallelchains) * 0.5; // Mix down 
    
    // Make sure things don't get stuck because of DC
    sig = LeakDC.ar(sig); 

    sig = DFM1.ar(sig, freq:40 +  cutoff , res: res, type:loOrHi, noiselevel: 0.0); 

    // Limiter to keep things under (relative) control
    sig = Limiter.ar(sig, 0.85); 

    // Output
    Out.ar(feedbackBus, sig);
    Out.ar(out, sig * amp)
}).add;





// mousefb1 
SynthDef('mousefb1', {
    arg out=0, feedbackBus=~feedbackbus, allocationtime = 60.0,
    delaytime=0.1, decaytime=2.0, pan=0, amp=0.1;

    var feedbackIn, chain1, chain2, sig, src, parallelchains;
    
    // Excite the feedback loop to make sound
    src = Clip.ar(WhiteNoise.ar(10.00) * Lag.kr(Impulse.kr(0.01).range(0.0, 1.0), 0.5));

    // Get feedback input from audio bus
    // InFeedback is necessarry to prevent the audio data from the previous
    // cycle  on the bus being overwritten
    feedbackIn = InFeedback.ar(feedbackBus, 2);
    
    // Add delay
    sig = Mix.ar(Array.fill(3, {|i| 
        Pan2.ar(
                CombC.ar(feedbackIn+src, allocationtime, MouseY.kr(0.1,1)*delaytime*(1+i), decaytime)/3, 
            1 - 2.rand)})); // Random panning 

    // PROCESS THE FEEDBACK

    chain1 = FFT(LocalBuf(2048), sig);
    chain1 = PV_BinShift(chain1, MouseX.kr(0.25,4, \exponential));

    chain2 = FFT(LocalBuf(2048), sig);
    chain2 = PV_Freeze(chain2, MouseY.kr < 0.5);

    
    // Set up parallel effects chain
    parallelchains = [sig, 
        3*IFFT(chain2)!2, 
        3*IFFT(chain1)!2,
        InGrain.ar(trigger: Impulse.ar(MouseY.kr(0.1, 100)), dur: MouseX.kr(0.01, 1), in: sig)!2,
        FreqShift.ar(sig, MouseY.kr(2,0.2, \exponential)*[440, 880, 1220], 2pi.rand)];
    
    sig = Mix.ar(parallelchains) * 0.5; // Mix down 
    
    // Make sure things don't get stuck because of DC
    sig = LeakDC.ar(sig); 

    // Limiter to keep things under (relative) control
    sig = Limiter.ar(sig, 0.95); 

    // Output
    Out.ar(feedbackBus, sig);
    Out.ar(out, sig * amp)
}).add;

// mousefb2 
SynthDef('mousefb2', {
    arg out=0, feedbackBus=~feedbackbus, allocationtime = 60.0,
    delaytime=0.1, decaytime=2.0, pan=0, amp=0.1;

    var feedbackIn, chain1, chain2, sig, src, parallelchains;
    
    // Excite the feedback loop to make sound
    src = Clip.ar(WhiteNoise.ar(10.00) * Lag.kr(Impulse.kr(0.01).range(0.0, 1.0), 0.5));

    // Get feedback input from audio bus
    // InFeedback is necessarry to prevent the audio data from the previous
    // cycle  on the bus being overwritten
    feedbackIn = InFeedback.ar(feedbackBus, 2);
    
    // Add delay
    sig = Mix.ar(Array.fill(3, {|i| 
        Pan2.ar(
                CombC.ar(feedbackIn+src, allocationtime, MouseY.kr(0.1,1)*delaytime*(1+i), decaytime)/3, 
            1 - 2.rand)})); // Random panning 

    // PROCESS THE FEEDBACK

    // Set up parallel effects chain
    parallelchains = [sig, 
        InGrain.ar(trigger: Impulse.ar(MouseY.kr(0.1, 100)), dur: MouseX.kr(0.01, 1), in: sig)!2,
        FreqShift.ar(sig, MouseY.kr(2,0.2, \exponential)*[440, 880, 1220], 2pi.rand)];
    
    sig = Mix.ar(parallelchains) * 0.5; // Mix down 
    
    // Make sure things don't get stuck because of DC
    sig = LeakDC.ar(sig); 

    // Limiter to keep things under (relative) control
    sig = Limiter.ar(sig, 0.95); 

    // Output
    Out.ar(feedbackBus, sig);
    Out.ar(out, sig * amp)
}).add;

// fb1 
SynthDef('fb1', {
    arg out=0, feedbackBus=~feedbackbus, freqscale=1, allocationtime = 60.0,
    pitchdisp=0.1, timedisp=0.1, winsize=0.5, waveloss=0,
    cutoff=1500, res=0.1, loOrHi=0,
    delaytime=0.1, decaytime=2.0, pan=0, amp=0.1, slew=0.1;

    var feedbackIn, chain1, chain2, sig, src, parallelchains;
    
    // Excite the feedback loop to make sound
    src = Clip.ar(WhiteNoise.ar(10.00) * Lag.kr(Impulse.kr(0.01).range(0.0, 1.0), 0.5));

    // Get feedback input from audio bus
    // InFeedback is necessarry to prevent the audio data from the previous
    // cycle  on the bus being overwritten
    feedbackIn = InFeedback.ar(feedbackBus, 2);
    
    // Add delay
    sig = Mix.ar(Array.fill(3, {|i| 
                CombC.ar(feedbackIn+src, allocationtime, delaytime.lag(slew)*(1+i), decaytime)/3})); // Random panning 

    // PROCESS THE FEEDBACK

    // Set up parallel effects chain
    parallelchains = [
        sig,
        PitchShift.ar(in: sig, windowSize: winsize.lag(slew), pitchRatio: [1.0, 1.1, 1.2] * freqscale.lag(slew), pitchDispersion: pitchdisp.lag(slew), timeDispersion: timedisp.lag(slew)),
        FreqShift.ar(sig, freqscale.lag(slew)*[440, 880, 1220])];
    
    sig = Mix.ar(parallelchains) * 0.5; // Mix down 

	sig = Mix.ar(Array.fill(4, { AllpassL.ar(sig, 4, SinOsc.kr(0.001).linlin(-1,1,0.001, 0.5)+(0.01.rand), 0)} ))/2;
        
    // Make sure things don't get stuck because of DC
    sig = LeakDC.ar(sig); 

    // Limiter to keep things under (relative) control
    //sig = Limiter.ar(sig, 0.90); 
    sig = sig.softclip;
    
    // Filter
    sig = DFM1.ar(sig, freq: cutoff.lag(slew), res: res.lag(slew), inputgain:
    0.3, type:loOrHi, noiselevel: 0.000001);

    // Output to feedback bus
    Out.ar(feedbackBus, sig*0.9);
    
    // Final output
    Out.ar(out, sig * amp)


}).add;

)


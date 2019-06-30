////////////////////////////////////////////////////
// SET UP PROXY SPACE
////////////////////////////////////////////////////
(
p = ProxySpace.push(s);
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;

// Start the pattern that's about to be defined
~p1.play;
)

(
////////////////////////////////////////////////////
// feedback synth
////////////////////////////////////////////////////


SynthDef('fb1', {
    arg i_out=0, feedbackBus=~feedbackbus, allocationtime = 60.0,
    cutoff=1500, res=0.1, loOrHi=0,
    delaytime=0.1, decaytime=2.0, pan=0, amp=0.1, slew=0.1;

    var feedbackIn, sig, src, parallelchains;
    
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
    // Make sure things don't get stuck because of DC
    sig = LeakDC.ar(sig); 

    // Limiter to keep things under (relative) control
    sig = Limiter.ar(sig, 0.90); 
    //sig = sig.softclip;
    
    // Filter
    sig = DFM1.ar(sig, freq: cutoff.lag(slew), res: res.lag(slew), inputgain:
    0.3, type:loOrHi, noiselevel: 0.000001);

    // Output to feedback bus
    //Out.ar(feedbackBus, sig*0.9);
    
    // Final output
    Out.ar(i_out, sig * amp)


}).add;
)

////////////////////////////////////////////////////
// PATTERNS
////////////////////////////////////////////////////


// FEEDBACK BUS
b = Bus.audio(s,2);
b.scope;

(
// Main pattern

~p1[0] = Pmono(
    \fb1, 
    \amp, 1.7,
    \delaytime, Pseq([0.1, 0.25, 0.33],inf),
    \cutoff, 1.5*Pn(Pseq([1150, 1500, 2000, 1100],inf), inf, key: \cutkey),
    \dur, Pseq([8, 12, 16], inf),
    \i_out, b.index
).trace;
)

(
// CHANGE THE OUTPUT OF THE MAIN PATTERN
// THIS WILL KILL THE FEEDBACK LOOP
~p1[1] = \filterIn -> {|in| 

    //var sig = BPF.ar(in, 9000); 
    var final;
    var sig = in; // Uncomment this to revive the feedback-loop
    var dry = sig;
    var lf = LFSaw.kr(freq: 0.125, iphase: 0, mul: 1, add: 0);
    sig = FreqShift.ar(sig, 
        freq: [1,2,3] * SinOsc.kr(0.015).linlin(-1,1,310,630), 
        phase: 0);
    sig = Mix.ar(sig);
    sig = PitchShift.ar(in: sig, windowSize: 0.5, pitchRatio:
        lf.linlin(-1,1,0.25, 2),
        pitchDispersion: 0.11, timeDispersion: 0);

    final = sig;
    //DFM1.ar(final, freq: 100, res: 0.1, inputgain: 3, type:1, noiselevel: 0.0003) ;
    dry + final;

};

)

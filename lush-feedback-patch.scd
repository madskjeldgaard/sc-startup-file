l = Leap.new;


// FEEDBACK BUS
~feedbackbus = Bus.audio(s, 2); 

(
// FEEDBACK SYNTH
SynthDef('fbsynthttt', {
    arg out=0, feedbackBus=~feedbackbus, allocationtime = 60.0,
    delaytime=0.3432, decaytime=1.932, pan=0;

    var feedbackIn, sig, src, parallelchains;
    
    // Excite the feedback loop to make sound
    src = Clip.ar(WhiteNoise.ar(10.00) * Lag.kr(Impulse.kr(0.01).range(0.0, 1.0), 0.95));

    // Get feedback input from audio bus
    // InFeedback is necessarry to prevent the audio data from the previous
    // cycle  on the bus being overwritten
    feedbackIn = InFeedback.ar(feedbackBus, 2);
    
    // Add delay
    sig = Mix.ar(Array.fill(10, {|i| 
        Pan2.ar(
                CombC.ar(feedbackIn+src, allocationtime, delaytime*(1+i) *
                MouseX.kr , decaytime * LFTri.kr((1.rand+i)/10)), 
            1 - 2.rand)})); // Random panning 

    // PROCESS THE FEEDBACK

    // Set up parallel effects chain
    j = JPverb.ar(sig, 
            t60: MouseX.kr(0.04382), // approximate reverberation time in seconds (T60 - the time for the reverb to decay 60db) 
            damp: 0, 
            size: MouseY.kr(0.0123)*3, 
            earlyDiff: 0.707, //controls shape of early reflections. Values of 0.707 or more produce smooth exponential decay.
            modDepth: 1-MouseY.kr(0.01), 
            modFreq: LFTri.kr(0.5.rand,0,10), 
            low: 1,     
            mid: 1, 
            high: 1, 
            lowcut: 500, highcut: 2000);

    g = Greyhole.ar(sig, 
        delayTime: MouseY.kr(0.01)*2, 
        damp: 0, //  0 is no damping, 1 is very strong damping (0..1)
        size: 1-MouseX.kr(0.01), // Values below 1 can sound metallic. (0.5..5) 
        diff: 0.707, // controls pattern of echoes produced by the diffuser. 
        feedback: LFSaw.kr*0.9, 
        modDepth: 0.3, // (0..1) 
        modFreq: 2 // (0..10) 
    );

    parallelchains = [sig, FreqShift.ar(sig, [140,143,643], 2pi.rand), Squiz.ar(
        sig,
        pitchratio: [2.rand, 3.rand,4.rand], // the ratio by which pitch will be raised (e.g.  pitchratio of 2 will raise by one octave)
        zcperchunk:1, // indicates how many positive-going zero-crossings are used to delimit a chunk. 
        memlen: 0.1 // the amount (in seconds) of memory the unit allocates internally to remember each fragment, i.e. the longest a given fragment can become.
        ),
    Balance2.ar(j[0], j[1], pos:LFTri.kr(0.013,0).range(-1,1)),
    Balance2.ar(g[0], g[1], pos: LFTri.kr(0.01, 2pi).range(-1,1))
            ];

    sig = Splay.ar(parallelchains); // Mix down 

    sig = LPF.ar(sig, freq: 20 + (8000 * [1-MouseX.kr, MouseX.kr])); 

    // Make sure things don't get stuck because of DC
    sig = LeakDC.ar(sig); 

    // Limiter to keep things under (relative) control
    sig = Limiter.ar(sig, 0.90); 

    // Output
    Out.ar(feedbackBus, sig);
    Out.ar(out, sig * 0.1)
}).add;
)
Synth('fbsynthttt');


s.stopRecording


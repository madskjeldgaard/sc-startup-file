// BUSSES
(
~feedbackbus = Bus.audio(s, 2); 
~reverb = Bus.audio(s,2);
~concatA = Bus.audio(s,2);
~concatB = Bus.audio(s,2);
~reverbfinal = Bus.audio(s,2);
)
(
// FEEDBACK SYNTH
SynthDef('feedback_synth', {
    arg out=0, feedbackBus=~feedbackbus, allocationtime = 10.0,
    delaytime=0.2, decaytime=2.0, pan=0, freq=444;

    var feedbackIn, sig, src, parallelchains;
    
    // Excite the feedback loop to make sound
    src = Clip.ar(WhiteNoise.ar(10.00) * Lag.kr(Impulse.kr(0.01).range(0.0, 1.0), 0.5));

    // Get feedback input from audio bus
    // InFeedback is necessarry to prevent the audio data from the previous
    // cycle  on the bus being overwritten
    feedbackIn = InFeedback.ar(feedbackBus, 2);
    
    // Add delay
    sig = Mix.ar(Array.fill(8, {|i| 
        Pan2.ar(
                CombC.ar(feedbackIn+src, allocationtime,
                    delaytime*(1+i)*MouseX.kr.range(0.01,1), decaytime)/8, 
            1 - 2.rand)})); // Random panning 

    // PROCESS THE FEEDBACK

    // Set up parallel effects chain
    parallelchains = [sig, FreqShift.ar(sig, MouseX.kr.range(0.01,3) * freq * (1..3), 2pi.rand)];

    sig = Splay.ar(parallelchains); // Mix down 

    // Make sure things don't get stuck because of DC
    sig = LeakDC.ar(sig); 

    // Limiter to keep things under (relative) control
    sig = Limiter.ar(sig, 0.95); 

    // Output
    Out.ar(feedbackBus, sig);
    Out.ar(out, sig)
}).add;

/* --- SYNTH: concat_synth --- */
SynthDef(\concat_synth, {
    arg out=0, amp=0.1, control = ~concatA, source=~concatB, send=0,
    atk=1, sus=1, rel=1, pan=0;
    var env, sig;

    // Signal
    sig = Concat2.ar(
        In.ar(control, 2), In.ar(source, 2), storesize: 1, seektime: 1, 
        seekdur: 1, matchlength: MouseY.kr, freezestore: 0, 
        zcr: 1, lms: 1, sc: 1, st: 1, randscore: 1, 
        threshold: MouseX.kr);

    sig = PitchShift.ar(in: sig, windowSize: 0.2, pitchRatio: 0.1,
        pitchDispersion: 0, timeDispersion: 0);
    sig = Limiter.ar(sig, 0.5) * 0.1;
    sig = Pan2.ar(sig, pan);

    sig = sig * amp;
    Out.ar(out, sig )
}).add;

/* --- SYNTH: reverbsynth --- */
SynthDef(\reverbsynth, {
    arg out=0, amp=1.0, freq, inBus, send=0,
    time=1, size=1, mod=0.1, damp=0, pan=0;
    var sig;

    // Signal
    sig = JPverb.ar(In.ar(inBus,2), t60: time, damp: damp, size: size, 
        earlyDiff: 0.707, modDepth: MouseY.kr*mod, modFreq: 2, 
        lowcut: 500, highcut: 2000);

    Out.ar(out, sig )
}).add;
)

(
// MAKE SYNTHS AND GROUPS
~sources = Group.new;
~effects = Group.new(~sources, \addAfter);
~concatter = Group.new(~effects, \addAfter);

r = Synth(\reverbsynth, [\inBus, ~reverbfinal, \size, 1, \time, 3, \mod, 1, \out, 0], ~concatter);
c = Synth(\concat_synth,[\out, ~reverbfinal], ~concatter);
x = Synth(\reverbsynth, [\inBus, ~reverb, \size, 5, \mod, 1, \out, ~concatB], ~effects);
y = Synth('feedback_synth', [\delaytime, 0.25, \freq, 222, \out, ~reverb], ~sources );
z = Synth('feedback_synth', [\delaytime, 0.15, \freq, 421, \out, ~concatA], ~sources );

)
s.stopRecording



// FEEDBACK BUS
~feedbackbus1 = Bus.audio(s, 2); 

(
// FEEDBACK SYNTH
SynthDef('feedback_synth', {
    arg out=0, feedbackBus=~feedbackbus1, allocationtime = 60.0, freq=440,
    delaytime=0.1, decaytime=4.0, pan=0;

    var feedbackIn, sig, src, verb, parallelchains, apc = ~apcmidicc.kr(128);
    
    // Excite the feedback loop to make sound
    src = Clip.ar(WhiteNoise.ar(10.00) * Lag.kr(Impulse.kr(0.01).range(0.0, 1.0), 0.5));

    // Get feedback input from audio bus
    // InFeedback is necessarry to prevent the audio data from the previous
    // cycle  on the bus being overwritten
    feedbackIn = LeakDC.ar(InFeedback.ar(feedbackBus, 2));
    
    // Add delay
    sig = Array.fill(5, {|i| 
                CombC.ar(feedbackIn+src, allocationtime, delaytime*(1+i) *
                apc[48].lag(0.1), decaytime*apc[49].lag(0.2))/5}); 

    // PROCESS THE FEEDBACK
    sig = Splay.ar(sig);

    // Set up parallel effects chain
    verb = Greyhole.ar(sig, 
        delayTime: delaytime, // approximate reverberation time in seconds (T60 - the time for the reverb to decay 60db) 
        size: (apc[48]-1)*2, 
        diff: apc[49],
        modDepth: apc[51], 
        feedback: apc[46],
        modFreq: ((freq/100)*apc[52])+0.1 );

    parallelchains = [sig, 
        verb,
        FreqShift.ar(sig, 20+([freq*0.5, freq*2, freq*3]*apc[50..52]), 2pi.rand), 
        PitchShift.ar(sig, pitchRatio: apc[55]*3, pitchDispersion: 1),
        Squiz.ar(sig, pitchratio: 0.1+([0.5,2,4] * apc[48..50]))
        ];

    sig = Splay.ar(parallelchains,spread:apc[56]); // Mix down 

    // Make sure things don't get stuck because of DC
    sig = LeakDC.ar(sig); 

    // Limiter to keep things under (relative) control
    sig = Limiter.ar(sig, 0.90); 

    // Output
    Out.ar(feedbackBus, sig);
    Out.ar(out, sig * 0.1)
}).add;
x = Synth('feedback_synth');
y = Synth('feedback_synth', [\freq, 344, \delaytime, 0.25]);

)

(
var datetime = Date.getDate.format("%d%m%Y_%H:%M:%S"), 
path = "/Users/madskjeldgaard/Desktop/ableton/User\ Library/Sounds/SUPERCOLLIDER_RECORDINGS";

s.record(path ++ "/" ++ "sc_" ++ datetime ++ "." ++ s.recHeaderFormat); 
//s.stopRecording
)
s.stopRecording


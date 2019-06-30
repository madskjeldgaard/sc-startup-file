(

~feedbackbus = Bus.audio(s, 2); 
~fromMainSynth = Bus.audio(s,2);
)
/* --- SYNTH: reverbsynth1 --- */
SynthDef(\reverb1, {
    arg in, out=0, amp=1.0, freq, effectBus, send=0,
    atk=1, sus=1, rel=1, pan=0;
    var sig;

    // Signal
    sig = 
    In.ar(in, 2) + 
    JPverb.ar(In.ar(in, 2), t60: MouseY.kr(3,1), damp: 0.1, size: 0.5, 
        earlyDiff: 0.707, modDepth: MouseX.kr(1,0), modFreq: 2, 
        lowcut: 500, highcut: 5000);

    Out.ar(out, amp * (sig/2))
}).add;

(
// Patch 
~sources = Group.new;
~effects = Group.new(~sources, \addToTail);

Synth('reverb1', [\in, ~fromMainSynth, \amp, 0.50, \delaytime, 0.01], ~effects);
Synth('mousefb2', [\out, 0, \delaytime, 0.05,  \amp, 0.0], ~sources);
Synth('mousefb2', [\out, 0, \amp, 0.0], ~sources);
)

s.stopRecording

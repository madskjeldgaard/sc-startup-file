(
// 0. Choose an outputfile name and path
var outputfile = "~/Desktop/ctktest.wav";

// 1. Write Note proto types / Synths
~notes = CtkProtoNotes(
    SynthDef(\testsynth, {
        arg out=0, amp=0.2, freq, atk=1, sus=1, rel=1, pan=0;
        var env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);
        var sig = Pan2.ar(SinOsc.ar([freq, freq*1.01]), pan);

        Out.ar(out, sig * env * amp)
    });
);

// 2. Create score 
~score = CtkScore.new; // Create a score obj to keep track of notes

10.do{|i| var starttime=0, freqs = [80, 123, 435, 999]; 
    // Generate 10 notes playing the \testsynth, 
    // randomly choosing between 4 frequencies, 
    // and then add it to the score
    ~notes[\testsynth]
    .note(starttime+i)
    .atk_(i)
    .freq_(freqs.choose)
    .addTo(~score);}; 

// 3. Render / play
// ~score.play(s) // uncomment to play

~score.write(path: outputfile.standardizePath, duration: 20, // defaults to 'nil' which is the length of the score 
    sampleRate: 96000, headerFormat: "WAV", 
    sampleFormat: "int32");
)


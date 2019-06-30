(
var cond = Condition.new;

Routine.run({

// 0. Choose an outputfile name and path
var outputfile = "~/Desktop/ctktest.wav";

// 1. Write Note proto types / Synths
~notes = CtkProtoNotes(
    SynthDef(\testsynth, {
        arg out=0, amp=0.2, freq, atk=1, sus=1, rel=1, pan=0;
        var env = EnvGen.kr(Env([0, 1.0, 0.75], [atk, sus]), doneAction:0);
        var sig = Pan2.ar(SinOsc.ar([freq, freq*1.01]), pan);

        Out.ar(out, sig * env * amp)
    }),
    SynthDef(\testsynth2, {
        arg out=0, amp=0.2, atk=1, sus=1, dur=1, pan=0;
        var env = EnvGen.kr(Env([0, 1.0, 0.75], [atk, dur]), doneAction:0);
        var sig = Pan2.ar(SinOsc.ar((1..20001), pan)) / 20001;

        Out.ar(out, sig * env * amp)
    });
);

// 2. Create score 
~score = CtkScore.new; // Create a score obj to keep track of notes
10.do{|i| var starttime=0, freq = i+1; 
    // Generate 10 notes playing the \testsynth, 
    // randomly choosing between 4 frequencies, 
    // and then add it to the score
    ~notes[\testsynth]
    .note(starttime)
    .amp_(1/20001)
    .atk_(4)
    .freq_(freq)
    .addTo(~score);

    starttime = starttime + 0.1;

}; 

// 3. Render / play
//~score.play(s) // uncomment to play

~score.write(path: outputfile.standardizePath, duration: 2000, // defaults to 'nil' which is the length of the score 
    sampleRate: 44100, headerFormat: "WAV", sampleFormat: "int16"); 
}).play;
)

CtkAudio

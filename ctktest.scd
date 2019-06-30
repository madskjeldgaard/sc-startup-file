(
var scpn, score, grainfun, gliss;
scpn = CtkProtoNotes(
    SynthDef(\control, {arg outbus, rate, low, hi;
        Out.kr(outbus, LFNoise2.kr(rate).range(low, hi))
    }),
    SynthDef(\test, {arg freq, amp, dur;
        var env, envgen, src;
        env = Env([0, 1, 0], [0.5, 0.5], \sin);
        envgen = EnvGen.kr(env, timeScale: dur);
        src = BPF.ar(WhiteNoise.ar(amp), freq, 0.01, amp * envgen);
        Out.ar(0, Pan2.ar(src, Rand(-1.0, 1.0)));
    })
);

score = CtkScore.new;

//creates a granular gesture of duration. Each grain is 0.1 seconds long, new grain every 0.02 seconds
grainfun = {arg starttime, duration, ampenv, lowfreq, hifreq;
    var now, note, thisgroup;
    now = 0;
    ampenv.times = ampenv.times.normalizeSum * duration; // scale the Env's time to the gestures
    thisgroup = CtkGroup.new(starttime, duration + 2).addTo(score);
    while({
        // create a note... add it to the CtkScore
        note = scpn[\test].note(starttime + now, 1, target: thisgroup)
        .freq_(lowfreq.rrand(hifreq))
        .amp_(ampenv[now])
        .dur_(0.1).addTo(score);
        now = now + 0.02;
        now < duration;
    });
};


// uncomment to play the CtkScore you have created
score.play(s);

// uncomment to write (render) the score to a soundfile
//score.write("~/Desktop/test.aiff".standardizePath, 22, options: ServerOptions.new.numOutputBusChannels_(2).blockSize_(1));

// uncomment to save the CtkScore as a file
// score.saveToFile("~/Desktop/test.sc".standardizePath);
)

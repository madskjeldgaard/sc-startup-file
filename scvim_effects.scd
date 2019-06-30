// This is the main output bus. All audio passes through here to go to main fx
~mainOutput = Bus.audio(s, 2);

(
// Reverb
r ={ |in=~mainOutput, dw=1, time=1, size=3, modDepth=0.1, modFreq=2|

    i + (dw*JPverb.ar(in, time, 0, size, 0.707, modDepth, modFreq);

};


)

//~p5.play(out: ~output.index, fadeTime:8);

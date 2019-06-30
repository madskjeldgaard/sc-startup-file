(
// STEREO SAMPLE PLAYER
SynthDef(\sampleStereo, { 
    arg buffer, out = 0, amp = 1.0, 
    rate = 1.0, start = 0.0, channels = 2, loop = 0,
    sort =100, warpfreq=4;    

    var sig, trig = 1;

    // Set up buffer to be played
    sig = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * rate, trig, start, loop, doneAction:2);

    Out.ar(out, sig * amp);
}).add;
)

(
// MONO SAMPLE PLAYER
SynthDef(\sampleMono, { 
    arg buffer, out = 0, amp = 1.0, 
    rate = 1.0, start = 0.0, channels = 2, loop = 0,
    sort =100, warpfreq=4;    

    var sig, trig = 1;

    // Set up buffer to be played
    sig = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * rate, trig, start, loop, doneAction:2);

    Out.ar(out, sig * amp);
}).add;
)
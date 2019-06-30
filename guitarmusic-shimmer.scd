(
/*** Pattern pattern1 for shim synth ***/
~pattern1 = Pbind(
    \instrument, \shimmeringWarpPlayer2_vox3, 
    \buffer, Pxrand(o["guitarobj"], inf), 
    \rate, Pseq([0.75, 0.5, 0.25, 0.75, 0.125], inf),
    \grainsize, Pwhite(0.3, 0.75),
    \detune, Pbrown(0.25, 0.5, 0.05, inf),
    \amp, 0.2,
    \dur, Pseq([18, 22, 36], inf),
    \rel, Pkey(\dur)/2,
    \atk, Pkey(\rel),
    \out, 0
);

~pattern1.play;

)

s.stopRecording


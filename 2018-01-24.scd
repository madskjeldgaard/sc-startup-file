/*** Pattern pattern1 for samplePlayer2 synth ***/
(
~pattern1 = Pbind(
    \instrument, Pxrand([\shimmeringSamplePlayer2_vox5, \unisonSamplePlayer2_vox5, \phaseSyncSamplePlayer2_vox5],inf), 
    \buffer, Pxrand(o["8klange"], 16), 
    \rate, Pseq([0.125,0.25, 0.5, 1.0],inf), 
    \detune, Pwhite(0.3,1.0, inf),
    \pitchenv, 0.2,
    \amp, 0.5,
    \dur, Pseq([32,32], inf),
    \atk, Pkey(\dur),
    \rel, Pkey(\dur),
    \out, 0
);

~pattern1.play;
)

1+1.0.rand

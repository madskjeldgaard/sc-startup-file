(
/*** Pattern pattern1 for membrane synth ***/
~pattern1 = Pbind(
    \instrument, \pmClassic, 
    \amp, 0.7,
    \scale, Scale.harmonicMajor,
    \root, 2,
    \degree, Pseq([0,1,5,3,4,2],inf),
    \tension, Pwhite(0.031,0.033,inf),
    \dur, Pbjorklund2(8,3,inf)/8,
    \pan, 0.33,
    \atk, 0,
    \rel, Pkey(\dur)*4,
    \pfunc, Pfunc({"%: pattern1 is playing membrane synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \out, 0
);

~pattern2 = Pbind(\instrument, \fmbell, \dur, Pbjorklund2(13,4,inf)/4, \pan, -0.33) <> ~pattern1;

Ppar([~pattern1, ~pattern2], inf).play;
)

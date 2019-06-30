
all {: x, x <- (1..10), x.odd }
~detune1 = 1.04;
~rates1 = all {:[x,x*~detune1], x <- (0.1,0.2..3)};

~detune2 = 1.02;
~rates2 = all {:[x,x*~detune2], x <- (0.1,0.2..3)};


/*** Pattern fb1 for samplePlayer2 synth ***/
~stigningen = Pbind(
    \instrument, \samplePlayer2, 
    \amp, 0.1,
    \rate, Pseq(~rates1,inf), 
    \buffer, o["fb"][0],
    \loop, 1,
    \atk, 4,
    \rel,4,
    \dur, Pseq([2], ~rates1.size),
    \out, 0
);

~stigningen2 = Pbindf(~stigningen, \rate, 0.5*Pseq(~rates2,inf), \dur, Pseq([3], ~rates1.size));

~stigningen2.play;

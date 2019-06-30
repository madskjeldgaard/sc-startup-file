~pb1 = Pbind(
    \instrument, \samplePlayer1, 
    \amp, 1.0,
    \rate, Pwhite(0.1,3.0,inf),
    \buffer, Pxrand(o["modfb"], inf),
    \atk, Prand([0.1,0.25,1],inf),
    \rel, Prand([0.1,0.25,1],inf),
    \pan, Pwhite((-1), 1,inf),
    \dur, Pseq([4,2,3,1], inf),
    \out, 0
);

~pb1.play;

~pb2 = Pbind(
    \instrument, \warp1, 
    \amp, 0.2,
    \rate, 4.25*[0.1, 0.2, 0.3],
    \pointRate, Pkey(\rate)/8,
    \buffer, Pxrand(o["modfb"], inf),
    \atk, 4*Prand([0.1,0.25,1],inf),
    \rel, 4*Prand([0.1,0.25,1],inf),
    \pan, Pwhite((-1), 1,inf),
    \dur, 3*Pseq([4,2,3,1], inf),
    \out, (0..2)
);

~pb2.play;

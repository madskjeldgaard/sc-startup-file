~p2[0] = Pbind(
        \instrument, \unisonSamplePlayer2_vox3, 
        \buffer, o["fbatmos"][0], 
        \amp, 0.3,
        \rate, Pstutter(3, Pseq((1..3),inf)) * 2*Pseq([1,1,1,-1.0],inf), 
        \start, 0.8,
        \dur, Pseq([0.5, 1/3, 1/4, 7], inf),
        \loop, 1,
        \atk, 0 * Pkey(\dur), 
        \rel, 0.5 , 
        \envcurve, \exp,
        \out, 0
    );

~p3[0] = Pbind(
        \instrument, \oneShotSamplePlayer2, 
        \buffer, Pseq(o["zeng"],inf), 
        \amp, 0.3,
        \rate, 1.0, 
        \dur, Pseq([0.5, 1/3, 1/4, 7], inf),
        \loop, 0,
        \atk, 0 * Pkey(\dur), 
        \rel, 1.0 , 
        \envcurve, \exp,
        \out, 0
    );

    ~p3.play(fadeTime:8);

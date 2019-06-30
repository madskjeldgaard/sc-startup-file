(

var fb = o["fbguitar"];

~lambda1 = 
    Plambda(Ptpar([
        0, ~pat1,
        0, ~pat2, 
        0, ~pat3, 
        0, ~pat4 
        ] , inf) 
    );

~pat1 = Pbind(
    \instrument, \overlappingSamplePlayer2, 
    \buffer, fb[8+n],
    \rate, Plet(\mainrate, Pseq([0.5, 0.25, 0.75],inf)),
    \dur, Plet(\maindur, Pseq([6,12,8], inf)),
    \atk, Pkey(\dur)/2,
    \rel, Pkey(\dur),
    \out, 0
);

~pat2 = Pbindf(
    ~pat1,
    \buffer, fb[1+n], 
    \rate, Pget(\mainrate, 0.5, inf) * 0.75,
    \ratescale, 2.5,
    \dur, Pget(\maindur, 8, inf) * 1.5,
    \loop, 1,
    \out, 2
);

~pat3 = Pbindf(
    ~pat2,
    \buffer, fb[2+n], 
    \ratescale, 1.5,
    \dur, Pget(\maindur, 8, inf) * 1.25,
    \out, 4
);

~pat4 = Pbindf(
    ~pat3, 
    \buffer, fb[1+n], 
    \ratescale, 0.5,
    \dur, Pget(\maindur, 8, inf) * 2,
    \out, 6
);

~lambda1.play;

)


( 
~lambda2 = Plambda(Ptpar([
    0.0, ~pat5,
    1.0, ~pat6
    ]));

~pat5 = Pbind(
    \instrument, \overlappingSamplePlayer2, 
    \buffer, o["fbguitar"][0],
    \dur, Pseq([8,12], inf),
    \rate, 0.5,
    \atk, 8,
    \rel, 8,
    \out, 0
);

~pat6 = Pbindf(~pat5,
    \buffer, o["fbguitar"][1],
    \out, 2
);
~lambda2.play;

)

8.reciprocal

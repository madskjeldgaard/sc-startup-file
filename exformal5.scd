(

TempoClock.default.tempo = 0.25; // cirka 40 bpm 
//TempoClock.default.tempo = 0.99; // cirka 40 bpm 

~p = Pstutter(8, Pseq([0.25, 0.33, 0.105, 0.27, 0.165],inf));

~b1 = Pbind(
    \instrument, \warp2, 
    \buffer, Pseq([o["bil"][1], o["emf"][0..21]], inf), 
    \rate, ~p*Pseq([1,5,3,2],inf)*[1.1, 2.2, 3.3],
    \interp, 4,
    \overlaps, Pseq([8,16,32,8,2],inf),
    \gdur, [3,2,1] * Pseq([0.05, 0.1, 0.03],inf),
    \pointRate, [0.21, 0.01],
    \amp, 0.03,
    \dur, Pseq([8,4,16], inf),
    \atk, Pkey(\dur)*2,
    \rel, Pkey(\dur)*2,
    \out, 0
);

~b2 = Pbindf(~b1, \buffer, Pseq(o["bil"][4..10] ++ o["paris"][0..3] ,inf), \out, 2);
~b3 = Pbindf(~b1, \buffer, Pseq(o["paris"][0..3] ++ o["bil"][15..23],inf), \dur, Pseq([8, 4, 12],inf), \out, 4);
~hiss = Pbindf(~b1, \instrument, \warp1, \buffer, Pxrand(o["hydro"][0..9], inf), \out, 6);
~b4 = Pbindf(~b1,  \buffer, o["bilibrand"][1..5], \pointRate, 0.001, \rate, ~p*[1.1,2.2,3.3]*0.1, \dur, Pseq([16, 32, 12],inf), \out, 8);
~hiss2 = Pbindf(~b4,\instrument, \warp1, \buffer, o["hydro"][0..13], \rel, Pkey(\dur)*2, \out, 10);

~b5 = Pbindf(~b4, \rate, ~p*[1.1,2.2,3.3]*0.2, \dur, 2*Pseq([16, 32, 12],inf), \out, 12);
~b6 = Pbindf(~b4, \pointRate, [0.21, 0.01]*1.1, \rate, 2*~p*[1.1,2.2,3.3]*0.5, \dur, 1.25*Pseq([16, 32, 12],inf), \out, 14);

~hiss3 = Pbindf(~hiss2, \pointRate, Pseq([0.1, 0.01, 0.25, 0.125],inf),\rate, 4*~p*Pseq([1,5,3,2],inf)*[1.1, 2.2, 3.3], \dur, 4*Pseq([16,32,12],inf));

Ppar([~b1, ~b2, ~hiss, ~b3, ~b4, ~hiss2, ~hiss3, ~b5, ~b6],inf).play;
~hiss3.play;
)
(

TempoClock.default.tempo = 0.99; 

~p = 8*Pstutter(8, Pseq([0.15, 0.23, 0.525, 0.33, 0.165],inf));

~b1 = Pbind(
    \instrument, \warp2, 
    \buffer, Pseq([o["bilibrand"][1], o["emf"][0..5]], inf), 
    \rate, ~p*Pseq([1,5,3,2],inf)*[1.1, 1.7, 4.3],
    \interp, 1,
    \overlaps, Pseq([8,16,32,8,2],inf),
    \gdur, [3,2] * Pseq([0.05, 0.1, 0.03],inf),
    \pointRate, [0.01, 0.012],
    \amp, 0.03,
    // \pan, Pwhite(-1.0,1.0),
    \dur, Pseq([8,5,16], inf),
    \atk, Pkey(\dur)*2,
    \rel, Pkey(\dur)*2,
    \out, 0
);

~b2 = Pbindf(~b1, \buffer, Pseq(o["bil"][4..10] ++ o["paris"][0..3] ,inf));
~b3 = Pbindf(~b1, \buffer, Pseq(o["paris"][0..3] ++ o["bil"][15..23],inf), \dur, Pseq([8, 4, 12],inf), \out, 4);
~hiss = Pbindf(~b1, \instrument, \warp1, \buffer, Pxrand(o["hydro"][0..9], inf), \out, 6);
~b4 = Pbindf(~b1,  \buffer, o["bil"][10..20], \pointRate, 0.001, \rate, ~p*[1.1,2.2,3.3]*0.1, \dur, Pseq([16, 32, 12],inf), \out, 8);
~hiss2 = Pbindf(~b4,\instrument, \warp1, \buffer, o["hydro"][4], \rel, Pkey(\dur)*2, \out, 10);

~b5 = Pbindf(~b4, \rate, ~p*[1.1,2.2,3.3]*0.72, \dur, 4*Pseq([16, 32, 12],inf), \out, 12);
~b6 = Pbindf(~b4, \rate, ~p*[1.1,2.2,3.3]*0.5, \dur, 3*Pseq([16, 32, 12],inf), \out, 14);


~hiss3 = Pbindf(~hiss2, \pointRate, Pseq([0.1, 0.01, 0.25, 0.125],inf),\rate, 4*~p*Pseq([1,5,3,2],inf)*[1.1, 2.2, 3.3], \dur, 4*Pseq([16,32,12],inf));

Ppar([~b1, ~b2],inf).play;
)


(

TempoClock.default.tempo = 0.5; // 30 bpm 

~p = Pstutter(8, Pseq([0.25, 0.33, 0.125, 0.33, 0.165],inf));

~b1 = Pbind(
    \instrument, \warp1, 
    \buffer, o["benjolin"][25], 
    \rate, ~p*Pseq([1,5,3,2],inf)*[1.1, 2.2, 3.3],
    \interp, 4,
    \overlaps, Pseq([8,16,32,8,2],inf),
    \gdur, [3,2,1] * Pseq([0.05, 0.1, 0.03],inf),
    \pointRate, [0.21, 0.01],
    \amp, 0.03,
    \pan, Pwhite(-1.0,1.0),
    \dur, Pseq([8,5,16], inf),
    \atk, Pkey(\dur),
    \rel, Pkey(\dur),
    \out, [0,2,4]
);

~b2 = Pbindf(~b1, \buffer, Pseq(o["benjolin"][49..54],inf), \out, [6,8,10]);
~b3 = Pbindf(~b1, \buffer, Pseq(o["benjolin"][55..65],inf), \dur, Pseq([8, 4, 12],inf), \out, [12,14,16]);
~hiss = Pbindf(~b1, \buffer, o["tapehiss"][0], \out, [18,20,22]);
~b4 = Pbindf(~b1, \buffer, o["benjolin"][50], \pointRate, 0.001, \rate, ~p*[1.1,2.2,3.3]*0.1, \dur, Pseq([16, 32, 12],inf), \out, [24,26,28]);
~hiss2 = Pbindf(~b4, \buffer, o["tapehiss"][0], \rel, Pkey(\dur)*2, \out, [30,32,34]);

~b5 = Pbindf(~b4, \rate, ~p*[1.1,2.2,3.3]*0.2, \dur, 4*Pseq([16, 32, 12],inf), \out, [40,42,44]);
~b6 = Pbindf(~b4, \rate, ~p*[1.1,2.2,3.3]*0.5, \dur, 3*Pseq([16, 32, 12],inf), \out, [46,48,50]);


~hiss3 = Pbindf(~hiss2, \pointRate, Pseq([0.1, 0.01, 0.25, 0.125],inf),\rate, 4*~p*Pseq([1,5,3,2],inf)*[1.1, 2.2, 3.3], \dur, 4*Pseq([16,32,12],inf));

/*** Pattern grain1 for tgrains1 synth ***/
~grain1 = Pbindf(~b1,
    \instrument, \tgrains1, 
    \buffer, o["benjolin"][5..10],
    \gdur, Pwhite(0.01,0.1,inf), 
    \rate,~p*Pseq([1,5,3,2],inf)*[1.1, 3.3]*10,
    \trigrate, 8*Pseq([16, 32, 64],inf),
    \atk, Pkey(\dur)/2,
    \rel, Pkey(\dur)/2,
    \out, [36,38] 
);

Ppar([~b1, ~b2, ~hiss, ~b3, ~b4, ~hiss2, ~grain1],inf).play;
~hiss3.play;
)
~hiss3.play;

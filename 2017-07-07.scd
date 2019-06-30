(
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

Ppar([~b1, ~b2, ~hiss, ~b3, ~b4],inf).play;
)

o["benjolin"][50].play;

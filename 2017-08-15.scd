(

~r = 0.005;
~mids = [3,4]; 

~mid = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, o["fb"][0],
    \rate, [~r, ~r*1.01] * Pseq(~mids, inf) + Pseries(0, 0.01, inf),
    \dur, Pseq([32, 16, 64], inf),
    \atk, Pkey(\dur)/2,
    \rel, Pkey(\atk),
    \out, 0
);

~mid.play;
)


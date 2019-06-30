(
var fb = o["fbguitar"];    
~pat1 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, o["fbguitar"][8],
    \rate, Pseq([0.5, 0.25, 0.75],inf),
    \dur, Pseq([6,12,8], inf),
    \atk, Pkey(\dur)/2,
    \rel, Pkey(\dur),
    \out, 0
);

~pat1.play;

~pat2 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, fb[1], 
    \rate, Pseq([0.5, 0.25, 0.75],inf) * 2.5,
    \dur, Pseq([6,12,8], inf) * 1.25,
    \loop, 1,
    \atk, Pkey(\dur)/2,
    \rel, Pkey(\dur),
    \out, 2
);

~pat2.play;

~pat3 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, fb[2], 
    \rate, Pseq([0.5, 0.25, 0.75],inf) * 2.5,
    \dur, Pseq([6,12,8], inf) * 1.25,
    \loop, 1,
    \atk, Pkey(\dur)/2,
    \rel, Pkey(\dur),
    \out, 4
);

~pat3.play;

)


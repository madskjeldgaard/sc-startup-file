
(

~pattern1 = Pbind(
    \instrument, \tartConvolve1, 
    \buffer, Pxrand(o["fbtape"] , inf),
    \loop, 1, \amp, 0.01,
    \rate, Pwhite(0.25, 2.5) * 0.5,
    \dur, Pseq([4, 5, 6], inf) ,
    \atk, Pkey(\dur), \rel, Pkey(\atk),
    \out, Pseq([0,2,4],inf) 
);


~pattern2 = Pbind(
    \instrument, \tartConvolve2, 
    \buffer, Pxrand(o["fb201"] , inf),
    \loop, 1, \amp, 0.01,
    \rate, Pwhite(0.25, 2.5) * [0.25, 0.66, 0.86] * 2,
    \dur, Pseq([4, 5, 6], inf) / Pseq([3,5],inf),
    \atk, Pkey(\dur) / Pseq([1,0.25,3,1],inf), \rel, Pkey(\atk),
    \out, Pseq([6,8,10],inf) 
);

// ~pattern1.play;
~pattern2.play;

)

s.meter;
(
~pattern3 = Pbind(
    \instrument, \sawConvolve1, 
    \buffer, Pxrand(o["ms20"] ++ o["serge"], inf),
    \loop, 1, \amp, 0.05,
    \rate, Pwhite(0.025, 2.25) ,
    \autopan, Pkey(\rate)/10,
    \dur, Pseq([4, 5, 6], inf), 
    \atk, Pkey(\dur), \rel, Pkey(\atk),
    \out, Pseq([6,8,10],inf) 
);
~pattern3.play;
)


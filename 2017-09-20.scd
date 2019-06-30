(
~pattern1 = Pbind(
    \instrument, \samplePlayer2, 
    \amp, 0.3, \buffer, Pseq(o["sling"], inf),
    \rate, Pseq((1..10)/10, inf),
    \dur, Pseq([18], inf),
    \pan, Pwhite(-1.0, 1.0,inf),
    \panfreq, Pkey(\rate),
    \rel, Pkey(\dur),
    \out, 0
);

~pattern2 = Pbind(
    \instrument, \samplePlayer1, 
    \amp, 0.3, \buffer, Pseq(o["fbtape"], inf),
    \rate, Pseq((1..10)/10, inf) / 10,
    \dur, Pseq([17], inf),
    \autopan, Pkey(\rate),
    \panfreq, Pkey(\rate),
    \rel, Pkey(\dur),
    \out, 2
);

~pattern3 = Pbind(
    \instrument, \samplePlayer1, 
    \amp, 0.3, \buffer, Pseq(o["fb201"], inf),
    \rate, Pseq((1..10)/10, inf) / Pseq((1..5), inf),
    \dur, Pseq([15], inf),
    \autopan, Pkey(\rate),
    \panfreq, Pkey(\rate),
    \atk, Pkey(\dur),
    \rel, Pkey(\dur),
    \out, 4
);

~pattern4 = Pbind(
    \instrument, \warp1, 
    \amp, 0.3, \buffer, Pseq(o["fb201"], inf),
    \rate, Pseq((1..10)/10, inf) / Pxrand((10..50), inf),
    \dur, Pseq([15], inf),
    \gdur, Pkey(\dur) / Pseq((10..15), inf) * [1,2,3],
    \autopan, Pkey(\rate),
    \panfreq, Pkey(\rate),
    \atk, Pkey(\dur),
    \rel, Pkey(\dur),
    \out, 6
);

~pattern1.play;
~pattern2.play;
~pattern3.play;
~pattern4.play;
)

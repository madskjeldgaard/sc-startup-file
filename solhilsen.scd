(
p = ProxySpace.push(s);
p.fadeTime = 4;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1.1;
// Activate limiter
//StageLimiter.activate;
)
Scale.directory;Scale.directory;

//z = Scale.bhairav;
z = Scale.harmonicMinor;
z = Scale.harmonicMajor;
z = Scale.bhairav;
r = -3; 
n = 256*3;
(
~hurdy.play;
~hurdy = Pfindur(n, Plambda(Ptpar([
    // Hurdy
    n/10,
    Pbind(\instrument, \hurdy, 
            \scale, z,
            \root, r,
            \mtranspose, [0, -14], 
            \detunepercent, Pseq([0.1, 0.25, 0.5],inf),
            \degree, Pget(\hdeg, 0, inf),
            \amp, Plet(\hamp, 0.09),
            \modlvl, 0.33,
            \gain, 1,
            \width, 0.875,
            \cutoff, Plet(\cut1, 200 + Pseries(100, 10, 300)),
            \res, Plet(\res1, 0.75),
            \autopan, 0,
            \atk, 4,
            \rel, 3,
            \dur, Pseq([4, 4, 4],inf), 
            \out, 0
            ),
    n/3,
    // Hurdy bass
    Pbind(\instrument, \hurdy, 
            \scale, z,
            \root, r,
            \mtranspose, -26, 
            \detunepercent, Pseq([0.1, 0.25, 0.5],inf),
            \degree, 0,
            \amp, Pget(\hamp, 0.02, inf),
            \gain, 4,
            \width, 0.175,
            \cutoff, 50,
            \res, 0.75,
            \autopan, 0,
            \atk, 2,
            \rel, 1,
            \dur, Pseq([4, 4, 4],inf), 
            \out, 0
            ),
    n/2 + 3, 
    // Hurdy2
    Pbind(\instrument, \hurdy, 
            \scale, z,
            \root, r,
            \mtranspose, 0, 
            \detunepercent, Pseq([0.1, 0.25, 0.5],inf) + 0.2,
            \degree, Plet(\hdeg, Pseq([3,3,4],inf)),
            \amp, Pget(\hamp, 0.02, inf)*0.5,
            \gain, 1,
            \width, 0.775,
            \cutoff, Pget(\cut1, 1000, inf),
            \res, Pget(\res, 0.25, inf),
            \autopan, 0,
            \pan, Pseq([-0.75, 0.25, 0.75],inf),
            \atk, 2,
            \rel, 2.5,
            \dur, Pseq([4, 4, 4],inf), 
            \out, 0
            ).collect({|ev| t = ev}),
    0,
    Pbind(
        \instrument, \pmClassic, 
            \scale, z,
            \root, r,
            \mtranspose, Plet(\pmtrans, [0, 7]) + 7, 
            \degree, Pseq([4,Rest, 5, Rest, 1, Rest,],inf),
            \modfreq, Pkey(\degree)*5,
            \amp, Plet(\pmamp, 0.05),
            \mod, Plet(\pmmod, 0.65),
            \pmi, Plet(\pmi, 0.45),
            \gain, 1,
            \rel, 0.25,
            \cutoff, 20000,
            \pan, 0.6,
            \autopan, 0.5,
            \panfreq, 1,
            \atk, 0,
            \res, 0.21,
            \dur, Pseq([0.125, Rest(0.125)],inf), 
            \out, 0
            ),
    n/8,
    Pbind(
        \instrument, \pmClassic, 
            \scale, z,
            \root, r,
            \mtranspose, Pget(\pmtrans, 7, inf) + 7, 
            \degree, Plet(\pmdeg, Pseq([4,Rest, 7, Rest, 1, Rest,],inf)),
            \modfreq, Pkey(\degree)/2,
            \amp, Pget(\pmamp, 0.08, inf)*0.6,
            \mod, Pget(\pmmod, 0.9, inf) * 0.9,
            \pmi, Pget(\pmi, 0.9, inf)*0.75,
            \gain, 1,
            \cutoff, 8000,
            \autopan, 0.25,
            \pan, -0.3,
            \panfreq, 0.25,
            \atk, 0,
            \res, 0.21,
            \dur, Pseq([0.125, Rest(0.125)],inf), 
            \rel, 0.05,
            \out, 0
            ),
    n/2,
    Pbind(
        \instrument, \pmPerc, 
            \scale, z,
            \root, r,
            \mtranspose, Pget(\pmtrans, 7), 
            \degree, Pget(\pmdeg, 0, inf)*2,
            \modfreq, Pkey(\degree)/2,
            \pan, -0.25,
            \autopan, 0.25,
            \amp, Pget(\pmamp, 0.06, inf),
            \mod, Pget(\pmmod, 0.9) * 0.9,
            \pmi, Pget(\pmi, 0.9, inf)*0.5,
            \pan, 0.7,
            \gain, 1,
            \cutoff, 8000,
            \autopan, 0.25,
            \panfreq, 0.25,
            \atk, 0,
            \res, 0.21,
            \dur, Plet(\pmdur, Pseq([0.125, 1/8, 1/8, Rest],inf)), 
            \out, 0
        ),
    0,
    Pbind(
        \instrument, \klanker, 
            \scale, z,
            \root, r,
            \mtranspose, [7, 14] - 7, 
            \degree, Plet(\kldeg1, Pseq([[0,3], [0,2]],inf)),
            \pan, -0.25,
            \autopan, 0.25,
            \amp, 0.19 + Pn(Pseries(0, 0.001, 100), inf),
            \mod, 1.0,
            \gain, 1,
            \cutoff, 12000,
            \panfreq, 0.1,
            \autopan, 0.25,
            \atk, 0,
            \res, 0.21,
            \dur, Plet(\kdur, Pbjorklund2(5,3,inf)/4), 
            \out, 0
        ),
    (n/10 + 4).round(1),
    Pbind(
        \instrument, \klanker, 
            \scale, z,
            \root, r,
            \mtranspose, [7, 14], 
            \degree, Pget(\hdeg, 0,inf),
            \pan, -0.25,
            \autopan, 0.25,
            \amp, 0.19 + Pn(Pseries(0, 0.001, 100), inf),
            \mod, 1.0,
            \rel, Pn(Pseries(0, 0.0001, 100), inf),
            \gain, 1,
            \cutoff, 12000,
            \panfreq, 0.1,
            \pan, 0.55,
            \autopan, 0.25,
            \atk, 0,
            \res, 0.21,
            \phase, Pseries(0,0.000000005, inf),
            \dur, Pbjorklund2(5,3,inf)/4,
            /*\dur, Pif(Pfunc({Ptime.new.trace > (3/4*n) }), 
                    Pbjorklund2(5,3,inf, Pseries(0,0.00001, inf))/4, 
                    Pbjorklund2(5,3,inf)/4),*/ 
            \out, 0
        ),
    (n/2 - 3).round(1),
    Pbind(
        \instrument, \klanker, 
            \scale, z,
            \root, r,
            \mtranspose, [7, 14] -7, 
            \degree, Pget(\hdeg, 4,inf),
            \detune, [9, 0],
            \pan, -0.25,
            \autopan, 0.25,
            \amp, 0.19 + Pn(Pseries(0, 0.001, 100), inf),
            \rel, 0.1 + Pn(Pseries(0, 0.0001, 100), inf),
            \gain, 1,
            \cutoff, 12000,
            \panfreq, 0.1,
            \pan, 0.25,
            \autopan, 1.00,
            \atk, 0,
            \res, 0.21,
            \phase, Pseries(0,0.00000005, inf),
            \dur, Pswitch([Rest(1), Pbjorklund2(5,3,1)/8], Pseq([0,1],inf)),
            /*\dur, Pif(Pfunc({Ptime.new.trace > (3/4*n) }), 
                    Pbjorklund2(5,3,inf, Pseries(0,0.00001, inf))/4, 
                    Pbjorklund2(5,3,inf)/4),*/ 
            \out, 0
        ),
    (n/3 + 2).round(1),
    Pbind(
        \instrument, \klanker, 
            \scale, z,
            \root, r,
            \mtranspose, [7, 14], 
            \degree, Pget(\hdeg, 5,inf),
            \detune, [3, 0],
            \pan, -0.25,
            \autopan, 0.25,
            \amp, 0.035,
            \gain, 1,
            \cutoff, 12000,
            \panfreq, 0.1,
            \pan, -0.25,
            \autopan, 1.00,
            \atk, 0,
            \res, 0.21,
            \phase, Pseries(0,0.00000005, inf),
            \dur, Pswitch([Rest(3), Pbjorklund2(2,3,1)/2], Pseq([0,1],inf)),
            /*\dur, Pif(Pfunc({Ptime.new.trace > (3/4*n) }), 
                    Pbjorklund2(5,3,inf, Pseries(0,0.00001, inf))/4, 
                    Pbjorklund2(5,3,inf)/4),*/ 
            \rel, -1 * (Pkey(\dur)/4),
            \out, 0
        ),
    n/4 - 13,
    Pbind(
        \instrument, \rawsquare, 
            \scale, z,
            \root, r,
            \mtranspose, [0,7], 
            \degree, Pget(\kldeg1, 0,inf),
            \pan, -0.25,
            \amp, [0.05, 0.04] * Pseries(1.25, -0.001, 1250),
            \rel, 0.25,
            \gain, 1,
            \cutoff, 200+Pget(\cut1, 200, inf),
            \panfreq, 2.1,
            \pan, 0.05,
            \autopan, 0.25,
            \atk, 0.5,
            \res, 0.51,
            \dur, Pseq([Pget(\pmdur, 1, 1)*4],inf), 
            \out, 0
        )
    ]
    )
)))
~hurdy.free;

(
// Panning stuff
y = (-1 * (0,0.1..1).reverse) ++ (0.0,0.1..1.0);
y = y ++ y.reverse;

// Chords
c = all {: [x, x+2, x+4], x <- (0..z.degrees.size)};

~chords.play;
~chords.free;
~chords = Plambda(Ptpar([
    0,
    Pbind(
        \instrument, \rawsquare, 
        \amp, 1.00*Plet(\a, 0.08 ),
        \degree, Plet(\deg, Pif(t[\degree] != 1, Pseq([c[0] + t[\degree]], inf),
        Pseq([c[0]],inf))),
        \octave, 5,
        \scale, z,
        \root, r,
        \cutoff, Plet(\c, 1000),
        \res, 0.8,
        //\dur, Pswitch([Rest(0.25), Pbjorklund2(15,16,inf)/8], Pseq([0,1],inf)),
        \dur, Plet(\d, Pbjorklund2(7,8,64)/8),
        \pan, Pseq(y, inf),
        \atk, 0, //Pkey(\dur)/4,
        \sus, Pkey(\dur)/2,
        \rel, Pkey(\dur)/2,
        \out, 0),
    0,
    Pbind(
        \instrument, \rawsquare, 
        \amp, 1.00 * Pget(\a, 0.10, inf) * Pwhite(0.9, 1, inf),
        \degree,Pseq([c[0], Rest, c[0], Rest],inf),
        \octave, 4,
        \width, [0.75, 0.5, 0.25],
        \scale, z,
        \root, r,
        \cutoff, Pget(\c, 700, inf)*3,
        \res, 0.2,
        \dur, Plet(\d, Pseq([8, Rest(8)],inf)),
        \pan, Pseq([-0.5, Rest, 0.5, Rest], inf),
        \atk, Pkey(\dur)/2,
        \sus, Pkey(\dur)/2,
        \rel, Pkey(\dur),
        \out, 0)
    ]));
)

//****** MEMBRANES *********//
~mem1.play;
~mem2.play;
~mem1.free;
~mem2.free;

/*** Pattern mem1 for membraneCircle synth ***/
~mem1 = Pbind(
    \instrument, \membraneCircle,
    \scale, z,
    \root, r,
    \degree, Pif(Pfunc({t[\degree] != 1}), Pseq([t[\degree]], inf), Pseq([c[0], c[3]],inf)),
    \mtranspose, 0,
    \pan, Pseq([0.25, 0.20, 0.15, 0, -0.15, -0.20, -0.25]*2,inf),
    \amp, 0.040,
    \rel, Pwhite(0.02,0.20,inf),
    \tension, Pseq([0.01, 0.03, 0.02]*2.25,inf),
    \dur, Pbjorklund2(3,8,inf)/8,
    \out, 0
).collect({|ev| m = ev});

~mem2 = Pbind(
    \instrument, \membraneCircle,
    \scale, z,
    \root, r,
    //\degree, Pif(Pfunc({t[\degree] != 1}), Pseq([t[\degree]], inf), Pseq([c[0], c[3], c[6]],inf)),
    \degree, 6,
    \mtranspose, 0,
    \pan, Pseq([0.25, 0.20, 0.15, 0, -0.15, -0.20, -0.25]*2,inf),
    \amp, 0.019,
    \tension, 0.025, //Pseq([0.01, 0.02, 0.03, 0.04, 0.05]*2,inf),
    \dur, Pbjorklund2(17,32,inf)/16 * Pseg(Pseries(1,0.25,inf), 1/2, 'wel', inf),
    \rel, Pkey(\dur)/2,
    \out, 0
);
~mem3.play;
~mem3.free;
~mem3 = Pbind(
    \instrument, \membraneCircle,
    \scale, z,
    \root, r,
    \degree, Pif(Pfunc({t[\degree] != 1}), Pseq([t[\degree]], inf), Pseq([c[0], c[3], c[6]],inf)),
    \degree, 5,
    \mtranspose, 0,
    \pan, Pseq([0.25, 0.20, 0.15, 0, -0.15, -0.20, -0.25]*2,inf),
    \amp, 0.029,
    \tension, 0.05, //Pseq([0.01, 0.02, 0.03, 0.04, 0.05]*2,inf),
    \dur, Pbjorklund2(17,32,inf)/8,
    \rel, Pkey(\dur)/2,
    \out, 0
);


/***** SQUARE AND SAW ADDITIONS *****/
~saw1.play;
~saw1.free;
~saw1 = Pbind(
    \instrument, \rawsaw, 
    \mtranspose, -14,
    \amp, 0.15,
    \scale, z,
    \root, r,
    \pan, 0, //Pseq([-1, 1],inf),
    \cutoff, 500,
    \res, 0.5,
    \degree, 3,
    \dur, Pseq([8, Rest(8)], inf) ,
    \rel, Pkey(\dur),
    \atk, Pkey(\dur)/2,
    \out, 0
);

~sqr1.play;
~sqr1.free;
~sqr1 = Pbind(
    \instrument, \rawsquare, 
    \amp, 0.15,
    \cutoff, 1000,
    \scale, z,
    \mtranspose, 7,
    \root, r,
    \pan, Pwhite(-1,1,inf),
    \degree, Pseq([1,5,3,0,2,5,6],inf),
    \dur, Pbjorklund2(7,8,inf)/8,
    \rel, Pkey(\dur)/4,
    \atk, 0, //Pkey(\dur)/2,
    \out, 0
);

~s.play;



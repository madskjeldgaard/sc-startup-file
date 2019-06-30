(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
)

~rev = Bus.audio(s, 2); // 2 channel audio bus 
(
300.do{"((( solhilsen ))) ~ ~ ~ ".post;};

/*** Parallel lambda pattern pattern1 for rawsaw and rawsaw synths***/
~pattern1 = Plambda(
    Ppar([ 
        Pbind(\instrument, \rawsaw, 
            \scale, Plet(\s, Scale.melodicMinor),
            \amp, 0.03,
            \mtranspose, 0,
            \degree, Plet(\y, Pswitch([
                        Pseq([0,3,1,2], 1),
                        Pseq([5,0], 2),
                        Pseq([1,3,5,4],13)
                        ],Pseq([0,1,2],inf))),
            \root, -3,
            \atk, 0.25,
            //\cutoff, 1050,
            \cutoff, Plet(\cut, Pn(pattern: Pseries(200,50,75), repeats: inf, key: nil)),
            \rel, 2,
            \send, 0.95,
            \sus, 1,
            \res, 0.75,
            \pan, Pn(Pseries(-1, 0.1, 20), inf),
            \dur, Plet(\x, Pswitch([
                        Pseq([1,2/3,1/3,1/2, Rest(1)],3),
                        Pseq([1,2/3,Rest(2), 1/3,1/2, Rest(1)],1),
                        Pseq([1,Rest(1), 2/3,1/3,1/2, Rest(3)],1)
                    ], Pseq([0,1,2],inf))),
            \effectBus, Plet(\re, ~rev, inf),
            \out, 0
            ),
        Pbind(\instrument, \rawsquare, 
            \mtranspose, 7,
            \amp, 0.08,
            \gain, 2,
            \scale, Pget(\s, nil, inf),
            \degree, Pget(\y, 7, inf),
            \pan, -1,
            \cutoff, 100 + Pget(\cut, 1500, inf)/2,
            \res, 0.90,
            \root, -3,
            \sus, 0,
            \rel, 1,
            \width, 0.8,
            \autopan, 0.25,
            \pan, Pn(Pseries(1, -0.1, 20), inf),
            \atk, 0,
            \send, 0.25,
            \effectBus, Pget(\re, 0, inf),
            \dur, Pget(\x, 1, inf)/6, 
            \out, 0
            ),
        Pbind(\instrument, \rawsaw, 
            \scale, Pget(\s, nil, inf),
            \mtranspose, -7,
            \degree, Pget(\y, 0, inf), 
            \amp, 0.10,
            \root, -3,
            \gain, 3,
            \atk, 0,
            \cutoff, Pget(\cut, 200, inf)/8,
            \rel, 1,
            \sus, 1,
            \res, 0.75,
            \send, 0.75,
            \effectBus, Pget(\re, 0, inf),
            \pan, 0,
            \dur, 1,
            \out, 0
            ),
    Pbind(\instrument, \rawsaw, 
            \scale, Pget(\s, nil, inf),
            \mtranspose, -14,
            \degree, Pget(\y, 0, inf), 
            \amp, 0.10,
            \root, -3,
            \gain, 3,
            \atk, 0,
            \cutoff, 100 + Pget(\cut, 0, inf)/100,
            \rel, 1,
            \sus, 1,
            \res, 0.35,
            \send, 0.75,
            \effectBus, Pget(\re, 0, inf),
            \pan, Pwhite(-0.15, 0.15, inf),
            \dur, Pget(\x, 1, inf)*3, 
            \out, 0
            ),
    Pbind(\instrument, \rawsaw, 
            \scale, Pget(\s, nil, inf),
            \mtranspose, -7,
            \degree, Pget(\y, 0, inf), 
            \amp, 0.12,
            \root, -3,
            \gain, 4,
            \atk, 0.5,
            \cutoff, 150,
            \rel, 1,
            \sus, 1,
            \res, 0.01,
            \send, 0.75,
            \effectBus, Pget(\re, 0, inf),
            \pan, Pwhite(-0.15, 0.15, inf),
            \autopan, 0.1,
            \dur, Pget(\x, 1, inf)*5, 
            \out, 0
            )
    ], inf)
);
)
~pattern1.play;

(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
h = ProxyMixer(s, 32);
//StageLimiter.activate;
)
(
~emfbird1 = Plambda(Ptpar([
    0.00,
        Pbind(
        \instrument, \samplePlayerEnvRate2, 
        \buffer, o["emf"][2],
        \amp, 0.6,
        \rate, Plet(\r, 0.08), 
        \cut, 5000 ,
        \res, 0.9,
        \hiOrLo, Pxrand([0,1],inf),
        \pan, 0,
        \dur, 0.5*Plet(\d1, Pseq([2, Rest(2), 2, Rest(2)], 8) / Pseries(1,1,8)),
        \atk, Pkey(\dur)/2,
        \autopan, 0.15,
        \out, 2
        ),
    0.5,
        Pbind(
        \instrument, \samplePlayerEnvRate2, 
        \buffer, o["emf"][2],
        \amp, 0.6,
        \rate, Pget(\r, 0.25, inf)*2, 
        \cut, 500,
        \hiOrLo, Pxrand([0,1],inf),
        \pan, 0,
        \dur, Pget(\d1, 1, 4),
        \autopan, 0.5,
        \pan, 0.25,
        \out, 2
        )

    ])
    );

~emfbird2 = Plambda(Ptpar([
    0.00,
        Pbind(
        \instrument, \samplePlayerEnvRate2, 
        \buffer, o["emf"][0],
        \amp, 0.8,
        \rate, Pseries(0,0.05,inf) + ([0.125, 0.2]/2), 
        \cut, Pseq([400,500,700, 1000], inf),
        \res, 0.95,
        \hiOrLo, 0,
        \start, 1,
        \pan, 0,
        \dur, Plet(\d1, Pseq([64, 64, 64, 64], 1)),
        \atk, Pkey(\dur),
        \rel, Pkey(\dur)/2,
        \autopan, Pseries(0.25,0.1,inf),
        \panfreq, 0.11,
        \out, [2, 4]
        ),
    108,
    ~emfbird1,
    144,
    Pbind(
        \instrument, \samplePlayer2, 
        \buffer, o["emf"][2],
        \amp, 0.3,
        \rate, Pseq([0.1, 0.15, 0.075],inf), 
        \res, 0.3,
        \loOrHi, 1,
        \cut, 2900,
        \pan, 0,
        \dur, Plet(\d1, Pseq([8], 6)),
        \rel, 0,
        \atk, 0,
        \autopan, 0.40,
        \panfreq, 0.21,
        \out, 8
        )
    ])
    );

~emfbird3 = Plambda(Ptpar([
    0.00,
        Pbind(
        \instrument, \samplePlayer2, 
        \buffer, o["emf"][7],
        \amp, 0.3,
        \rate, [0.125, 0.2], 
        \cut, Pseq([1000, 2000], inf),
        \res, 0.95,
        \hiOrLo, 1,
        \pan, 0,
        \dur, Plet(\d1, Pseq([8, 8], 1)),
        \rel, 0,
        \atk, Pkey(\dur),
        \autopan, 0.10,
        \panfreq, 0.01,
        \out, 10
        )    
    ])
    );
    
~emfbird4 = Plambda(Ptpar([
    0.00,
        Pbind(
        \instrument, \samplePlayer2, 
        \buffer, o["emf"][2],
        \amp, 0.3,
        \rate, Pseq([0.1, 0.15, 0.075],inf), 
        \res, 0.3,
        \loOrHi, 1,
        \cut, 2900,
        \pan, 0,
        \dur, Plet(\d1, Pseq([8], 3)),
        \rel, 0,
        \atk, 0,
        \autopan, 0.40,
        \panfreq, 0.21,
        \out, 0
        )    
    ])
    );

e = \samplePlayerEnvRate2;
z = \samplePlayer2;

~emfbird5 = Plambda(Ptpar([
    0.00,
        Pbind(
        \instrument, Pseq([e,z,z,z],inf), 
        \buffer, o["emf"][3],
        \amp, 0.3,
        \rate, 0.1, 
        \res, 0.8,
        \loOrHi, 1,
        \cut, 1900 + Pseries(0, 100, inf),
        \pan, 0,
        \dur, Pseries(0.125, 0.1, 20),
        \rel, 1,
        \atk, Pseq([1,0,0,0],inf),
        \autopan, 0.80,
        \panfreq, 0.31,
        \out, 12 
        )    
    ])
    );

)

(
~emfbird6 = Plambda(Ptpar([
    0.00,
        Pbind(
        \instrument, \samplePlayer2, 
        \buffer, o["emf"][6],
        \amp, 0.3,
        \rate, Pseq([0.25, Rest, 0.125, 0.2],inf) * [2.5, 0.75], 
        \res, 0.3,
        \loOrHi, 0,
        \cut, 8900,
        \pan, 0,
        \dur, Plet(\d1, Pseq([1, Rest(2), 3, 4], 1)),
        \rel, 0,
        \atk, Pseq([1,0,0,0],inf),
        \autopan, 0.40,
        \panfreq, 0.21,
        \out, 14 
        )    
    ])
    );

~emfbird7 = Plambda(Ptpar([
    0.00,
        Pbind(
        \instrument, \samplePlayer2, 
        \buffer, o["emf"][1],
        \amp, 0.7,
        \rate, [0.2, 0.3], 
        \res, 0.0,
        \start, 0.5,
        \loOrHi, 0,
        \cut, 75,
        \gain, 5,
        \pan, 0,
        \dur, Pseq([1, 2], 3)/8,
        \rel, 1,
        \atk, 0,
        \autopan, 0.40,
        \panfreq, 0.21,
        \out, 0
        )    
    ])
    );
)
(
~mov2 = Pseq([~emfbird2, Ppar([~emfbird5, ~emfbird6, ~emfbird3], 4)],1); 
~mov2.play;
)



Ppar([~emfbird5, ~emfbird6], 4).play
~emfbird1.play;

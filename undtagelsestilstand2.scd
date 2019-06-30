p.pop;
(
p = ProxySpace.push(s);
p.fadeTime = 8;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
)

~harsh2 = Pbind(
    \instrument, \tgrains2, 
    \amp, 2.5,
    \buffer, o["emf1"][1],
    \rate, Pxrand([-1,1],inf) * [0.05, 0.10] * 5,
    \gdur, Pwhite(0.1, 0.5,inf),
    \pos, 1,
    \posmod, Pwhite(0,1,inf),
    \cut, 5000,
    \random, 1,
    \trigrate, 5,
    \autopan, 0.25,
    \dur, Pseq([2, Rest(2)], inf),
    \atk, Pkey(\dur)/2,
    \out, 0
);

~harsh4 = Pbind(
    \instrument, \tgrains2, 
    \amp, 3.0,
    \buffer, o["emf1"][6],
    \rate, Pxrand([-1,1],inf) * [0.05, 0.10] * 5,
    \gdur, Pwhite(0.1, 0.5,inf),
    \pos, 1,
    \posmod, Pwhite(0,1,inf),
    \cut, 2000,
    \loOrHi, 1,
    \random, 1,
    \trigrate, 5,
    \autopan, 0.25,
    \dur, Pseq([2, Rest(2)], inf),
    \atk, Pkey(\dur)/2,
    \out, 0
);

~harsh4.play;

~harsh3 = Pbind(
    \instrument, \samplePlayer2, 
    \amp, 1.0,
    \buffer, o["emf"][7],
    \start, 0,
    \rate, Pxrand([-1,1],inf) * [0.05, 0.10] * 25,
    \cut, 3000,
    \loOrHi,0,
    \gain, 4,
    \autopan, 0.25,
    \dur, Pseq([2, Rest(2)], inf),
    \atk, Pkey(\dur)/2,
    \out, 0
);
~harsh2.play;
~harsh3.stop;


( 
~harshmov1 = Plambda(Ptpar([
    0, 
        Pbind(
        \instrument, \tgrains2, 
        \amp, 2.0,
        \buffer, o["emf1"][1],
        \rate, Pxrand([-1,1],inf) * [0.05, 0.10] * 3,
        \gdur, Pwhite(0.1, 0.75,inf)*2,
        \pos, 1,
        \posmod, Pwhite(0.5,1,inf),
        \cut, 1.5*10000,
        \random, 1,
        \trigrate, Pseq([5,6,7,8],inf)*0.125,
        \autopan, Pwhite(0.25, 0.75,inf),
        \panfreq, Pwhite(1,5,inf),
        \dur, Pseq([2, Rest(2)], inf),
        \rel, Pkey(\dur),
        \atk, Pkey(\dur)/4,
        \out, 0)
            ]));
~harshmov1.play;
)
(
~harshmov2 = Pbind(
        \instrument, \warp2, 
        \amp, 0.1,
        \buffer, o["emf"][1],
        \rateSeries, Pseq([30,10,20,15], inf),
        \rate, Pkey(\rateSeries)*[0.53, 0.10, 0.153, 0.22, 0.25, 0.3],
        \pointRate, 20.1,
        \rand, 0.5,
        \gdur, 0.5,
        \pan, [-1, -0.75, -0.25, 0.25, 0.75, 1],
        \cut, 100 * Pkey(\rateSeries),
        \loOrHi,0,
        \gain, 4,
        \autopan, 0.125,
        \panfreq, Pkey(\rate),
        \dur, Pseq([16, Rest(48)], inf),
        \atk, Pkey(\dur)*2.0,
        \out, 2);
~harshmov2.play;

)

o["emfB"][0];

(

~harshsine1.play(0,2);
~harshsine1 = Pbind(
        \instrument, \warp2, 
        \amp, 0.1,
        \buffer, o["emf"][1],
        \rateSeries, Pseq([30,10,20,15], inf),
        \rate, 5*[0.53, 0.10, 0.153, 0.22, 0.25, 0.3],
        \pointRate, 1.1,
        \rand, 0.8,
        \gdur, 0.01,
        \pan, 0,
        \cut, 500,
        \loOrHi,1,
        \gain, 1,
        \autopan, 0.125,
        \panfreq, Pkey(\rate),
        \dur, Pseq([128], inf),
        \atk, 0,  
        \out, 2);
//~harshsine1.play;
)
~harshsine1.play(0,2);
(
~harshsine2 = Pbind(
        \instrument, \samplePlayer2, 
        \amp, 0.05,
        \buffer, o["emfB"][0],
        \rate, 4*[1.05, 1.09] * [0.21, 0.35, 0.53],
        \cut, 3000 * Pseries(0.25, 0.1, 50),
        \loOrHi,0,
        \loop,1,
        \gain, 4,
        \autopan, 0.125,
        \panfreq, Pkey(\rate),
        \dur, Pseq([1/6], inf),
        \rel, 0.03,
        \atk, 0.03,  
        \out, 2);

)
o["emfB"][0]

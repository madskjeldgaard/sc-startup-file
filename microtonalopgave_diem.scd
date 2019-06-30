(
var steps = 19;
var degs = all {: x, x <- (0..steps-1)};

var pat1 = Pbind(
    \instrument, \pmPerc, 
    \degree, Pseq([
                    Pseq(degs.reverse, 3, 0),
                    Pseq(degs, 5, 0), 
                    Pseq(degs.scramble, 1, 0) 
                ], inf),
    \stepsPerOctave, steps,
    \octave, Pstutter(29, Pseq([4, 3, 4, 2, 4, 5], inf)) ,
    \amp, 0.05,
    \modfreq, Pkey(\freq) * Pseq([0.5, 0.25, 1.25, 1.72, 2.0], inf),
    \pmi, Pn(Pseries(1,-0.01, 100), inf),
    \mod, Pn(Pseries(0,0.01, 100), inf),
    \stretch, Pstutter(157, Pseq((1..4), inf)) * Pstutter(12, Pseq([0.125, 0.25, 0.025],inf)),
    \dur, Pstutter(79, Pseq([0.75, 0.25, 0.125, 0.66], inf)) * Pseq([1, 2, 3], inf),
    \pan, Pn(Pseries(-1,0.1, 20), inf), 
    \atk, Pwrand([0.01, Pkey(\dur)/2, Pkey(\dur)/3], [0.75, 0.125, 0.125], inf),  
    \rel, Pwrand([0.01, Pkey(\dur)/2, Pkey(\dur)/3], [0.6, 0.15, 0.25], inf)/2,  
    \out, 0
);
var pat2 = Padd(\octave, -1, pat1.scaleDur(2.75)); 
pat2 = Pmul(\atk, 3, pat2);

~p1 = Pfindur(589, Ptpar([0.0, pat1, 7.00, pat2], inf));

~p1.play;
)


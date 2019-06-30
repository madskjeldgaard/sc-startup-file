k = ();
~spectralBus1 = Bus.audio(s, 2); // 2 channel audio bus 
(
/**************************** 
        Feedback works 3 
        Spectral
*****************************/
var g = 0.025, // Base rate
    f = 0.25,
    mc = {|y| y = y/1000; y = y+1}, // Step 1: convert integer to micro tonal percentage
    z = {|x| [g, g*(x)]}, // Step 2: create frequency pair (pair of rates in this case) 
    maks = 25, // Maximum promille of deviation
    channels1 = (2,4..14),
    channels2 = (16,18..28),
    channels3 = (30,32..42);

// Now put all patterns into the dictionary k
k.putPairs([  
    \odds, p {: z.(mc.(x)), x <- (1..maks), x.odd }, // odds     
    \rodds, p {: z.(mc.(x)), x <- (maks..1), x.odd }, // reverse odds     
    \evens, p {: z.(mc.(x)), x <- (1..maks), x.even}, // evens 
    \revens, p {: z.(mc.(x)), x <- (maks..1), x.even}, // reverse evens 
    \thirds, p {: z.(mc.(x)), x <- (1..maks), x%3==0}, // thirds
    \rthirds, p {: z.(mc.(x)), x <- (maks..1), x%3==0}, // reverse thirds
    \primes,  p {: z.(mc.(x)), x <- (1..maks), x.isprime}, // primes 
    \rprimes, p {: z.(mc.(x)), x <- (maks..1), x.isprime}; // reverse primes 
]);
    
~feedbackpattern1 = Pbind(\instrument, \samplePlayer2,
        \buffer, o["fb"][0],
        \rate, Pseq([1,2.25,2,1.33],inf) * Pn(k[\odds], inf)/Pseq([1,2,3,4,3,2],inf),
        \loop, 1,
        \dur, Plet(\maindur, Pseq((8..16) ++ (15..4),inf)),
        \atk, Plet(\mainatk, Pseq([16,12,8],inf)),
        \rel, Plet(\mainrel, Pkey(\atk)),
        \cut, Pwhite(1,4,inf)*2500,
        \res, 0.9, \amp, 0.5, \out,~spectralBus1
        );

~spectralpattern1= Pbind(\instrument, \spectralVoid,
    \inBus, ~spectralBus1 ,
    \dur, Pget(\maindur, 16, inf)*2,
    \rel, Pget(\mainrel, 8, inf)*2.0,
    \stretch, Pkey(\dur)/ Pseq([64, 32, 28, 256, 128, 64, 16],inf),
    \teeth, Pkey(\stretch)*Pseq([32, 64, 32, 56, 128, 256], inf),    
    \width, Pseq([0.25, 0.5, 0.1, 0.01, 0.33],inf),
    \res, Pkey(\width),
    \cutoff, 80 * Pseq((1..33),inf),
    \panfreq, Pkey(\stretch)*3,
    \autopan, Pkey(\width),
    \amp, 1.0,
    \out, Pseq(channels1,inf)
    );

~spectralpattern2= Pbind(\stretch, Pkey(\dur)/ (2*Pseq([64, 32, 28, 128],inf)), 
    \dur, Pget(\maindur, 16, inf)*4,
    \autopan, Pkey(\width)/2,
    \cutoff, 200 * Pseq((1..33),inf),
    \out, Pseq(channels2,inf)
    );

~spectralpattern2 = ~spectralpattern2 <> ~spectralpattern1;

~spectralpattern3 = Pbind(\stretch, Pkey(\dur) / (Pseq([64, 32, 28, 128],inf)), 
    \dur, Pget(\maindur, 16, inf),
    \autopan, Pkey(\width)/100,
    \cutoff, 400 * Pseq((1..33),inf),
    \res, 0.90,
    \out, Pseq(channels3,inf)
    );

~spectralpattern3 = ~spectralpattern3 <> ~spectralpattern1;

~mainPattern = Plambda(Ptpar([0.0, ~spectralpattern1, 0.0, ~spectralpattern2, 0.0, ~spectralpattern3, 0.0, ~feedbackpattern1]));

~mainPattern.play;
)
fork{loop{"CPU: % ".format(s.avgCPU).postln ; 1.wait}};

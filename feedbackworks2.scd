k=();
(
/**************************** 
    Feedbackworks 2
    titel: Slettetid
*****************************/

var g = 0.025, // Base rate
    f = 0.25,
    mc = {|y| y = y/1000; y = y+1}, // Step 1: convert integer to micro tonal percentage
    z = {|x| [g, g*(x)]}, // Step 2: create frequency pair (pair of rates in this case) 
    maks = 25; // Maximum promille of deviation

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

/**************************** 
        BUSSES  
*****************************/
~panner = Bus.audio(s, 2); // 2 channel audio bus 
~spectralBus1 = Bus.audio(s, 2); // 2 channel audio bus 
)
(
/**************************** 
        PATTERNS  
*****************************/
~fb2pat = {| i, length, eBus|

var high = Pbind(\instrument, \samplePlayer2,
        \buffer, o["fb"][0],
        \rate, k[\revens]*(10+i),
        \loop, 1,
        \dur, Pseq([8],inf),
        \rel, 0.1,
        \amp, 0.02,
        \out, 2
        );

var emfchord = Pbind(\instrument, \samplePlayer2,
        \amp, 0.90,
        \buffer, o["emf"][4],
        \rate, (i+3)*Pn(k[\odds], inf)*0.54,
        \start, 1.3,
        \dur, Pn(Pbjorklund2(i+13,5)/8, inf),
        \atk, 0.01,
        \rel, Pkey(\dur)/8,
        \loop, 1,
        \effectBus, eBus,
        \send, 1.0,
        \out, 4
        );

var emfbas1 = Pbind(\instrument, \samplePlayer2,
        \amp, 0.50,
        \buffer, o["emf"][3],
        \rate, Plet(\basrate, 1.08*Pn(k[\evens], inf)*10),
        \start, 1.3,
        \dur, Plet(\basdur, Pn(Pbjorklund2(10+i,5)/8, inf)),
        \atk, 0.01,
        \rel, Pkey(\dur)/10,
        \loop, 1,
        \out, 6
        );

var x =  length*i*3;
var emfbas2 = Pbind(
        \instrument, \samplePlayer2,
        \amp, i%2 * 0.08 * Pn(Pseries(1,-1*(1/x),x),inf),
        \buffer, o["emf"][3],
        \loop,1,
        \start, 1.3,
        \atk, 0,
        \rel, Pkey(\dur)/10,
        \rate, Pget(\basrate, 0, inf)*10*i,
        \dur, Pget(\basdur, 1/4, inf), 
        \out,12  
        );

var panemf1 = Pbind(\instrument, \samplePlayer2,
        \amp, 0.07,
        \buffer, o["emf"][12],
        \rate, i*Pn(k[\rodds], inf)*90 + Pn(k[\evens], inf),
        \start, 1.3,
        \dur, i*Pn(Pbjorklund2(i+10,5)/8, inf),
        \atk, 0.01,
        \rel, Pkey(\dur)/8,
        \loop, 1,
        \effectBus, eBus,
        \send, 1.0,
        \out, 8
        );

var spectralvoid =  Pbind(\instrument, \spectralVoid,
    \inBus, eBus,
    \dur, Pn(Pbjorklund2(i+9,5)/8, inf),
    \stretch, Pseq([1,2,3,4,5],inf) + Pseries(i, 0.001,inf),
    \atk, Pn(Pseries(Pkey(\dur)/5, Pkey(\dur)/10, 10), inf),
    \teeth, i*Pkey(\stretch)*4, 
    \amp, 4.0,
    \out, 10
    );

var sats = Plambda(Ptpar([
    0.0, spectralvoid,
    0.0, emfbas1,
    0.1, high,
    0.2, emfchord,
    0.0, emfbas2,
    0.1, panemf1
    ]));

Pfindur(length, sats);
};

~fb2sats1 = Pseq([
    ~fb2pat.(1,8, ~spectralBus1), 
    Rest(0.75),
    ~fb2pat.(2,12, ~spectralBus1), 
    Rest(0.75),
    ~fb2pat.(1,8, ~spectralBus1),
    Rest(1.5),
    ~fb2pat.(3,12, ~spectralBus1), 
    Rest(0.75),
    ~fb2pat.(1,8, ~spectralBus1), 
    Rest(1.5),
    ~fb2pat.(4,16, ~spectralBus1) 
], 1)
)

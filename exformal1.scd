k = ();

(
/**************************** 

       Exformal 1

*****************************/
var g = 0.025, // Base rate
    f = 0.25,
    mc = {|y| y = y/1000; y = y+1}, // Step 1: convert integer to micro tonal percentage
    //z = {|x| [g, g*(x)]}, // Step 2: create frequency pair (pair of rates in this case) 
    z = {|x| g*x},
    maks = 25, // Maximum promille of deviation
    channels0 = (2,4..6), 
    c0 = channels0.maxItem+2,
    channels1 = (c0,c0+2 .. c0+4),
    c1 = channels1.maxItem+2,
    channels2 = (c1,c1+2..c1+4),
    c2 = channels2.maxItem+2,
    channels3 = (c2,c2+2..c2+4),
    c3 = channels3.maxItem+2,
    channels4 = (c3, c3+2..c3+4),
    c4 = channels4.maxItem+2,
    channels5 = (c4, c4+2..c4+4);

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
~spectralBus1 = Bus.audio(s, 2); // 2 channel audio bus 
~amp2trig = Bus.audio(s, 2); // 2 channel audio bus 
~amptrigger = Bus.audio(s, 2); // 2 channel audio bus 
~sendtofreezer = Bus.audio(s, 2); // 2 channel audio bus 
~grainbus = Bus.audio(s, 2); // 2 channel audio bus 

/**************************** 
    First group of patterns  
*****************************/
~patGen1 = { |i=1, length=64|

    var samples = [o["emf"][13], o["emf"][10], o["emf"][4]];

    var feedbackpattern1 = Pbind(\instrument, \samplePlayer2,
        \buffer, Pseq(samples, inf),
        \rate, Plet(\mainrate, i* 10 * Pseq([1,2.25,2,1.33],inf) * Pn(k[\odds], inf)/Pseq([1,2,3,4,3,2],inf)),
        \loop, 1,
        \start, 1.5,
        \dur, Plet(\maindur, Pseq((8..12) ++ (11..4),inf)),
        \atk, Plet(\mainatk, Pkey(\dur)*2), 
        \rel, Plet(\mainrel, Pkey(\atk)),
        \send, 1.0,
        \effectBus, ~spectralBus1,
        \amp, 0.4, \out, Pseq(channels0, inf)
        );

    var spectralpattern1= Pbind(\instrument, \spectralVoid,
        \inBus, ~spectralBus1,
        \dur, Pget(\maindur, 16, inf)*2,
        \rel, Pget(\mainrel, 8, inf)*2,
        \stretch, Pkey(\dur) / Pseq([64, 32, 28, 256, 128, 64, 16],inf),
        \teeth, Pseq([32, 64, 32, 56, 128, 256], inf),    
        \freq, channels1 * Plet(\mainfreq, Pkey(\teeth)/(i*16)),
        \width, Pseq([0.25, 0.5, 0.1, 0.01, 0.33],inf),
        \res, Pkey(\width),
        \panfreq, Pkey(\freq)/10,
        \autopan, 0.0,
        \send, 1.0,
        \effectBus, ~grainbus,
        \amp, 0.7,
        \out, channels1
        );

    var spectralpattern2= Pbind(\stretch, Pkey(\dur)/ (Pseq([64, 32, 28, 128],inf)), 
        \dur, Pget(\maindur, 16, inf)*3,
        \stretch, Pkey(\dur) / Pseq([64, 32, 28, 256, 128, 64, 16],inf),
        \freq, channels2 * Pget(\mainfreq, inf) * 2, 
        \teeth, channels2 * 8, 
        \width, channels2 * 0.02,
        \shift, 0.1,
        \amp, 1.0,
        \send, 1.0,
        \effectBus, ~grainbus,
        \autopan, Pkey(\width)/2,
        \out, channels2
        );

    var spectralpattern3 = Pbind(\instrument, \spectralVoid,
        \inBus, ~spectralBus1,
        \dur, Pget(\maindur, 16, inf)*2.3,
        \rel, Pget(\mainrel, 8, inf)*1.1,
        \freq, (channels3 / 100) * Pget(\mainrate, inf) * Pseq([1,4,3,2], inf),
        \stretch, i*Pkey(\dur) / Pseq(channels3,inf),
        \shift, Pseq([0.25, 1, 2], inf),
        \teeth, i*Pseq(channels3, inf),     
        \phase, Pwhite(0,1,inf),
        \width, 0.01*channels3,
        \panfreq, Pkey(\freq)*100,
        \autopan, 1.00,
        \amp, 1.0,
        \send, 1.0,
        \effectBus, ~grainbus,
        \out, channels3 
        );

    var grain1 = Pbind(\instrument, \ingrain,
        \inBus, ~grainbus,
        \dur, Pget(\maindur, 16, inf),
        \atk, Pget(\mainatk, 16, inf),
        \rel, Pget(\mainrel, 8, inf)*1.1,
        \freq, channels4 * Pseq((1..10)/50,inf) , 
        \gdur, Pseq([1,3,5,3],inf) / 3,
        \panfreq, Pkey(\freq)/10,
        \autopan, 1.00,
        \durmod, 0.5,
        \amp, 0.10,
        \out, channels4 
        );

    spectralpattern2 = spectralpattern2 <> spectralpattern1;
    Pfindur(length, Plambda(Ptpar([0.0, grain1, 
        0.0, spectralpattern1, 0.0, spectralpattern2,
        0.0, spectralpattern3, 0.0, feedbackpattern1
        ])));

    };

// Pseq([~patGen1.(5, 64), ~patGen1.(4, 32), ~patGen1.(5, 32), ~patGen1.(2, 128)], 1).play; 

// Lengths
l = 3*[4,8,4, 16,4, 2];
t = [1,2,5,4,3,10];

// Gather to patterns
p = all {: ~patGen1.(t[x], l[x]), x <- (0..l.size-1)};
e = all {: ~patGen1.(3*t[x], l[x]), x <- (0..l.size-3)};
y = Pseq([~patGen1.(0.01, 16), ~patGen1.(0.02, 16), ~patGen1.(0.015, 16)], 2);

// Play
~spectralPart= Pseq([y, Pseq(p++e, 1), y], 1);

/**************************** 
    Second group of patterns 
*****************************/

~deep1 = Pbind(\instrument, \warp2,
        \buffer, o["emf"][12], 
        \rate, Plet(\mainrate, 10 * Pseq([1,2.25,2,1.33],inf) * Pn(k[\odds], inf)/Pseq([1,2,3,4,3,2],inf)),
        \freq, Plet(\mainfreq, 1), 
        \pointRate, 0.1,
        \loop, 1,
        \start, 1.5,
        \dur, Plet(\maindur, Pseq((8..12) ++ (11..4),inf)),
        \atk, Plet(\mainatk, Pkey(\dur)*2), 
        \rel, Plet(\mainrel, Pkey(\atk)),
        \send, 1.0,
        \effectBus, ~spectralBus1,
        \amp, 0.1, \out, channels5[0] 
        );

~bubble1 = Pbind(\buffer, o["emf"][20], \out, channels5[1]);
~bubble1 = ~bubble1 <> ~deep1;

~bubble2 = Pbind(\buffer, o["emf"][7], \out, channels5[2], \gdur, 0.025, \freq, 0.01, \pointRate, Pseq([0.1,0.03,0.01,0.2],inf));
~bubble2 = ~bubble2 <> ~deep1;

// Final part
~spacePart = Plambda(Ptpar([0.0, ~deep1, 0.0, ~bubble2, 0.0, ~bubble1]));

~main = Ptpar([0.0, ~spacePart, 64, ~spectralPart], 1);
//~main.play;
~spectralPart.play;
fork{loop{"CPU usage: % ".format(s.avgCPU).postln ; 1.wait}};
)


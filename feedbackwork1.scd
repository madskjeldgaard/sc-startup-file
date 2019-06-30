k = (); // Initialise dictionary to hold patterns 
(
~bin = Bus.audio(s, 2); // 2 channel audio bus 
~frz = Bus.audio(s, 2); // 2 channel audio bus 
~m1 = Bus.audio(s, 2); // 2 channel audio bus 
~m2 = Bus.audio(s, 2); // 2 channel audio bus 
~m3 = Bus.audio(s, 2); // 2 channel audio bus 
~m4 = Bus.audio(s, 2); // 2 channel audio bus 
~m5 = Bus.audio(s, 2); // 2 channel audio bus 
~m6 = Bus.audio(s, 2); // 2 channel audio bus 
~m7 = Bus.audio(s, 2); // 2 channel audio bus 
~m8 = Bus.audio(s, 2); // 2 channel audio bus 
~m9 = Bus.audio(s, 2); // 2 channel audio bus 
~m10 = Bus.audio(s, 2); // 2 channel audio bus 
~comb= Bus.audio(s, 2); // 2 channel audio bus 
)
(

/**************************** 
    UNDTAGELSESTILSTAND 1  
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



// DEFINE PROCESSING NETWORK

~eout = 12; // First output channel of network

~s19 = Synth.new(\ingrain, [\inBus, ~m10, \gdur, 0.025, \freq, f*3500.00, \autopan, 1, \panfreq, 0.005, \amp, 0.6, \out, ~eout+22]); 

~s18 = Synth.new(\harmoniccomb, [\inBus, [~frz, ~frz], \autopan, 1,\freq, 0.0196, \amp, 4.0, \out, [~m10, ~eout+20] ]); 
~s17 = Synth.new(\freezer, [\inBus, ~comb, \freq, 1, \panfreq, 0.035, \amp, 4.0, \out, ~eout+18]); 
~s16 = Synth.new(\harmoniccomb, [\inBus, ~frz, \autopan, 1,\freq, 0.0096, \panfreq, 0.035, \amp, 4.0, \out, ~m9]); 

~s15 = Synth.new(\randcomb, [\inBus, ~m7, \autopan, 1,\freq, 0.0066, \panfreq, 0.035, \amp, 0.125, \out, ~eout+16]); 
~s14 = Synth.new(\randwipe, [\inBus1, ~m3, \inBus2, ~m7, \freq, 0.05, \autopan, 1, \panfreq, 0.055, \amp, 0.125, \out, ~eout+14]); 

// Grain
~s13 = Synth.new(\ingrain, [\inBus, ~m3, \gdur, 0.125, \freq, f*2500.00, \autopan, 1, \panfreq, 0.125, \amp, 0.01, \out, ~eout+12]); 
~s12 = Synth.new(\ingrain, [\inBus, ~m5, \gdur, 0.33, \freq, f*500.00, \autopan, 1,\panfreq, 0.25, \amp, 0.01, \out, ~eout+10]); 
~s11 = Synth.new(\ingrain, [\inBus, ~m8, \gdur, 0.25, \freq, f*1500.00, \autopan, 1, \panfreq, 0.33,  \amp, 0.01, \out, ~eout+8]); 
~s10 = Synth.new(\rectcomb, [\inBus, ~m3, \amp, 0.75, \freq, f*0.5, \teeth, 32, \width, 0.33, \out, ~m8]); 

// Rect Comb -> freezer
~s9 = Synth.new(\freezer, [\inBus, ~m7, \freq, f*7.00, \amp, 0.5, \out, ~eout+6]); 
~s8 = Synth.new(\rectcomb, [\inBus, ~bin, \amp, 0.75, \freq, f*0.1, \teeth, 8, \width, 0.33, \out, ~m7]); 

// Freezer + magsmear -> freezer -> morph 
~s7 = Synth.new(\morph, [\inBus1, ~m3, \inBus2, ~m4, \amp, 0.75, \freq, f*0.033, \ratio, 16, \out, ~eout]); 
~s6 = Synth.new(\freezer, [\inBus, ~m5, \freq, f*1.25, \out, ~m3]); 
~s5 = Synth.new(\magsmear, [\inBus, ~m1, \freq, f*0.01, \out, ~m5]); 
~s4 = Synth.new(\freezer, [\inBus, ~bin, \freq, f*0.225, \out, ~m4]); 

~s3 = Synth.new(\rectcomb, [\inBus, ~bin, \amp, 0.75, \freq, f*0.01, \teeth, 8, \width, 0.1, \out, ~eout+2]); 
~s2 = Synth.new(\binscrambler, [\inBus, ~m1, \freq, f*0.02, \out, ~bin]); 
~s1 = Synth.new(\rectcomb, [\inBus, ~frz, \freq, f*0.1, \teeth, 32, \width, 0.5, \out, ~m1]); 

~s0_1 = Synth.new(\phaseshift, [\inBus, ~m6, \freq, f*0.25, \amp, 0.5, \shift, 8, \out, ~eout+4]); 
~s0 = Synth.new(\binshifter, [\inBus, ~frz, \freq, f*0.10, \shift, 8, \out, ~m6]); 


// First movement: Comprising low, middle and high freq fb
~satsA = { |i, patSymbol=\evens | 

    var mellem, lav, hoj, q=1;

    // Sats 1
    mellem = Pbind(
        \instrument, \samplePlayer2, 
        \amp, 0.2,
        \buffer, o["fb"][0],
        \rate, k[patSymbol]*i,
        \loop, 1,
        \atk, 32,
        \rel, 32,
        \send, 1.0,
        \effectBus, ~frz,
        \dur, Pseq([8], 8/i),
        \out, 4
    );

    if (i==1) {q = 0;}{q = 1}; // This is used to silence hoj if i is 1

    hoj = Pbindf(mellem, 
        \rate, i * k[patSymbol] * Pseq([8, 8.5], inf), 
        \amp, q*0.03, 
        \atk, 16, \rel, 48/i, 
        \autopan, (1-k[patSymbol])/i,  
        \dur, Pseq([16], i),
        \out, 6
    );

    lav = Pbindf(mellem, 
        \rate, k[patSymbol] / (i*2), 
        \amp, 0.3, 
        \dur, Pseq([12/i], 8*i),
        \out, 2, 
    );

    // Return
    Ppar([lav, mellem, hoj], 1);
};

~sats1 = Pseq([
    ~satsA.(1, \evens), 
    ~satsA.(2, \odds), 
    ~satsA.(3, \revens)
    ],1); 

// Second movement: EMF + low freq feedback
~satsB = { |i, patSymbol=\evens | 

    var emf, mellem, mellem2, lav, hoj, q=1, lav2, violence;

    if (i!=1) {q = 0;}{q = 1}; // This is used to silence hoj if i is 1

    emf = Pbind(
        \instrument, \samplePlayer2, 
        \amp, 0.1/i,
        \buffer, [o["emf"][2], o["emf"][7]],
        \rate, [2.1, 2] * k[patSymbol]*i,
        \loop, 1,
        \atk, i,
        \autopan, k[patSymbol] * (0.5-k[patSymbol])/i,  
        \start, Pwhite(0,1,inf),
        \effectBus, ~comb,
        \send, 1.0,
        \dur, Pseq([8], 3/i),
        \rel, Pkey(\dur),
        \out, [8,10]
    );

    lav = Pbindf(emf, 
        \buffer, o["fb"][0],
        \rate, k[patSymbol] / (i*10), 
        \amp, 0.5, 
        \atk, 0.25,
        \start, 0,
        \dur, Pseq([12], 1*i),
        \rel, Pkey(\dur)/2,
        \autopan, i/10,
        \out, 2, 
    );

    lav2 = Pbindf(lav, \rate, k[patSymbol] / (i*3), \autopan, i/12); 

    mellem = Pbindf(lav, 
        \rate, i * k[patSymbol] * Pseq([8, 8.5], inf), 
        \amp, 0.03, 
        \atk, 2, 
        \rel, 48/i, 
        \autopan, (0.5-k[patSymbol])/i,  
        \dur, Pseq([4], i),
        \out, 6
    );

    mellem2 = Pbindf(mellem, \rate, k[patSymbol] / (i*2));

    // Return
    Ppar([mellem, mellem2, emf], 1);
};

~sats2 = Pseq([
    ~satsB.(3, \rthirds), 
    // ~satsB.(1, \thirds), 
    ~satsB.(2, \thirds),
    ~satsB.(1, \rodds), 
    ],1); 


// Mellemspil
~mellemspil= { |i, patSymbol=\evens, atk=16 | 

    var mellem, mellemhoj, lavlav, lav, hoj, emf, q=1;

    emf = Pbind(
        \instrument, \samplePlayer2, 
        \amp, 0.25*Pseries(1, 0.1, inf),
        \buffer, Pseq([o["emf"][9], o["emf"][3*i]], inf),
        \rate, [2.1, 2] * k[patSymbol],
        \loop, 1,
        \atk, atk,
        \autopan, 1,  
        \panfreq, 1/32,
        \dur, Pseq([4], i*3),
        \rel, Pkey(\dur),
        \atk, Pkey(\rel),
        \send, 0.5,
        \effectBus, ~frz,
        \out, [8, 10] 
    );

    emf;
};


// Third movement: Drastic FB + crunchy emf
//
~satsC = { |i, patSymbol=\evens, atk=16 | 

    var mellem, mellemhoj, lavlav, lav, hoj, emf, q=1;

    mellem = Pbind(
        \instrument, \samplePlayer2, 
        \amp, 0.2,
        \buffer, o["fb"][0],
        \rate, k[patSymbol]*i,
        \loop, 1,
        \atk, atk,
        \rel, 32,
        \dur, Pseq([2], 32/i),
        \out, 4
    );

    emf = Pbind(
        \instrument, \samplePlayer2, 
        \amp, 0.25*Pseries(1, 0.1, inf),
        \buffer, Pseq([o["emf"][8], o["emf"][9]], inf),
        \rate, [2.1, 2] * k[patSymbol],
        \loop, 1,
        \atk, i,
        \autopan, 1,  
        \panfreq, 1/32,
        \dur, Pseq([8], 32/i),
        \rel, Pkey(\dur),
        \atk, Pkey(\rel),
        \send, 0.5,
        \effectBus, ~frz,
        \out, [8,10]
    );

    mellemhoj = Pbindf(mellem, 
        \rate, i * k[patSymbol] , 
        \amp, 0.03, 
        \atk, atk, \rel, 12/i, 
        \autopan, (1-k[patSymbol])*i,  
        \dur, Pseq([8], i),
        \out, 6
    );

    if (i==1) {q = 0;}{q = 1}; // This is used to silence hoj if i is 1

    hoj = Pbindf(mellem, 
        \rate, i * k[patSymbol] * [8,12,11], 
        \amp, 0.02, 
        \atk, atk, 
        \rel, 48/i, 
        \autopan, (k[patSymbol])/[i,i+1,i+2],  
        \dur, Pseq([12/i], 16/i),
        \out, 6
    );
    

    lav = Pbindf(mellem, 
        \rate, k[patSymbol] / (i*2), 
        \amp, 0.3, 
        \atk, atk,
        \dur, Pseq([12/i], 16),
        \out, 2, 
    );

    lavlav = Pbindf(lav, 
        \rate, k[patSymbol] / (i*4), 
        \amp, 0.3, 
        \dur, Pseq([12/i], 16),
        \out, 2, 
    );

    // Return
    Ppar([emf, lav, lavlav, mellemhoj, mellem, hoj], 1);
};

~sats3 = Pseq([
    ~satsC.(1, \evens, 32), 
    ~satsC.(2, \odds, 8), 
    ~satsC.(3, \revens, 4)
    ],1); 

~undtagelsestilstand1 = Pseq([~sats1, ~mellemspil.(2), ~sats2, ~sats3], 1);

)
o["emf"][3].play;

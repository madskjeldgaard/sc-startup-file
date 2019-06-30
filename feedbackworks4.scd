(
/* --- SYNTH: samplePlayer2 --- */
SynthDef(\samplePlayer2, {
    arg out=0, buffer, amp=1.0, rate=1, trig=1, start=0, loop=0, effectBus=10, send=0,
    loOrHi=0, gain=1, cut=25000, res=0, autopan=0, panfreq=1,
    channels=2, atk=1, dur=1, rel=1, pan=0;
    var env, sig, panner;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

    panner = SinOsc.kr(panfreq,0,autopan).range(-1,1);
    panner = Select.kr(autopan > 0, [0, panner]);
    // Signal
    sig = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * rate, trig,
        start, loop, doneAction:2);
    //sig = Pan2.ar(sig, pan*panner);
    sig = Balance2.ar(sig[0], sig[1], panner);
    sig = Balance2.ar(sig[0], sig[1], pan);

    sig = DFM1.ar(sig, freq: cut , res: res, 
        inputgain: gain, type:loOrHi, noiselevel: 0.005); 
    sig = sig * env * amp;

    Out.ar(out, sig );
    Out.ar(effectBus, sig*send);
}).store;

/* --- Pattern functions --- */
~fbfunction = {
    arg baserate=0.004, harmonic, beatfactor=10, out=0, buffer = o["fb"][0]; 
    var panamount=0,
    // Reduce the beat factor to a number that actually works
    bf = (beatfactor / 1000) + 1,

    // Create two layers of samples played at two slightly different rates and do some algebra on them.  
    computedrate = [bf * baserate, baserate] * harmonic + Pseries(0, 1-bf, inf),     
    
    // Now calculate the durations of the notes
    durations = Pseq([512, Rest(256), 512, 128], harmonic) / (3*harmonic); 

    // Logic: If harmonic is high enough, pan it... slowly
    if (harmonic <= 5) {
        panamount = bf-1; 
    };

    // Return pattern
    Pbind(\instrument, \samplePlayer2, 
        \buffer, buffer, \loop, 1, 
        \rate, computedrate,\autopan, panamount,
        \dur, durations, \atk, Pkey(\dur), \rel, Pkey(\atk), 
        \out, out);
};

~pattern = {
    arg rate=0.004, i=1, size=3;

    var whichHarmonics=[1,3,5,7,9], 

    // Make a list of patterns using list comprehension and the above function
    patlist =  all {: ~fbfunction.value(rate, x, (i*5)+(x*2), x*2) , x <- whichHarmonics}; 
    
    // Return the patterns as a "layered" pattern 
    Ppar(patlist[0..size],1);
};

~composition = // About 36 minutes in total: 
    Pseq([
        ~pattern.value(rate: 0.005, i: 2, size: 1), 
        ~pattern.value(0.003, 1, 1), 
        ~pattern.value(0.004, 3, 2), 
        ~pattern.value(0.003, 1, 0)
    ], 1);

~composition.play;
)

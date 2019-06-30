s = Server.local;
g = ServerOptionsGui(s);
s.boot;

(
SynthDef.new(\microtonal4, {
    arg out=0, amp = 1.0, risetime = 16, falltime = 16, freq1=70, freq2=70.5, freqdeviation = 2.5, 
    modphase = 0.25, pmi = 0.25, lforate = 0.25, lfolvl = 0.10, panrate = 0.01,
    lpf = 50, res = 0.10;

    var env = EnvGen.kr( 
            envelope: Env([0, 1.0, 0 ], [risetime,falltime] ), 
            doneAction: 2 ); 
 
    var lfo = PMOsc.kr(lforate, freq2 * lforate, lfolvl);   
    //var lfo = Lag.kr(Saw.kr(lforate, lfolvl));
    var ran = Lag.kr(WhiteNoise.kr(0.10));

    var sound1 = SawDPW.ar(freq1, ran) ;
    var sound2 = SawDPW.ar(freq2+freqdeviation+ran, lfo);

    var sound = Splay.ar([sound1, sound2], spread: Lag.kr(SawDPW.kr(panrate)).range(0.2,0.9)); 
    sound = DFM1.ar(sound, lpf, res, noiselevel:0.0002);

    Out.ar(out, sound * amp * env);

}).add;

SynthDef.new(\microtonal5, {
    arg out=0, amp = 1.0, risetime = 16, falltime = 16, freq1=70, freq2=70.5, freqdeviation = 2.5, 
    modphase = 0.25, pmi = 0.25, lforate = 0.25, lfolvl = 0.10, panrate = 0.01,
    lpf = 50, res = 0.10;

    var env = EnvGen.kr( 
            envelope: Env([0, 1.0, 0 ], [risetime,falltime] ), 
            doneAction: 2 ); 
 
    var lfo = PMOsc.kr(lforate, freq2 * lforate, lfolvl);   
    //var lfo = Lag.kr(Saw.kr(lforate, lfolvl));
    var ran = Lag.kr(WhiteNoise.kr(0.10));

    var sound1 = SinOscFB.ar(freq1, lfo * ran) ;
    var sound2 = SinOscFB.ar(freq2+freqdeviation+ran, lfo);

    var sound = Splay.ar([sound1, sound2], spread: Lag.kr(SawDPW.kr(panrate)).range(0.2,0.9)); 
    sound = DFM1.ar(sound, lpf, res, noiselevel:0.0004);

    Out.ar(out, sound * amp * env);

}).add;

)


(
// PATTERN GENERATOR
// A function that takes an instrument (as string), a base frequency, a detune
// percentage and a number of harmonic layers (as int)

~microtonalHarmonicPatGen = {
    // Instrument name as string
    arg instrument, 
    // Base frequency
    freq = 70.0, 
    // Detune percentage
    detunePercentage = 2.5,
    // Base duration
    dur = 32,
    // Layers
    layers = 16,
    // Harmonics. 0 = all, 1 = odd, 2 = even, 3 = prime, 4 = squared, 
    // 5 = fibonacci
    harmonics = 0; 

    var allHarmonics, evenHarmonics, oddHarmonics, primeHarmonics,
    squaredHarmonics, fibHarmonics, lucasHarmonics, listOfPatterns;

    // Generate list of Pbinds from above arguments 
    // Represents a sort of harmonic series
    listOfPatterns = Array.fill(layers, {arg z;
        Pbind( 
            \instrument, "%".format(instrument).asSymbol, // This converts the instrument name string in the i arg to a symbol
            \out, 2*(z+2),
            \amp,4/(z+1),
            \freq1,freq * (1+z),  //freq + (freq*z/4), 
            \freq2, Pseries(freq * (1+z) * (1 + (detunePercentage/100)), 0.25), // the p variable is divided by 100 to represent detune in percent 
            \panrate, (z+1 ) * 0.01,
            \lforate, 0.01,
            \lpf, 25 * (z+2),
            \res, 0.1*z,
            \risetime, Pseq([Pn(dur/1.5, 8), Pn(dur,48)], layers),
            \falltime, Pseq([Pn(dur/2, 16), Pn(dur,16)]),
            \dur, dur ,
            \freqdeviation, Pmeanrand(detunePercentage/10, detunePercentage) 
        )});

    // Calculate harmonics using list comprehensions
    allHarmonics = listOfPatterns;

    evenHarmonics = all {:listOfPatterns[n], n <- (0..layers), n.even};
    oddHarmonics = all {:listOfPatterns[n], n <- (0..layers), n.odd};

    primeHarmonics = all {:listOfPatterns[n], n <- (0..layers), n.isPrime};

    squaredHarmonics = all {:listOfPatterns[n.squared], n <- (0..layers)};

    fibHarmonics = all {:listOfPatterns[n], n <- (layers*3).fib(0,1)};
    
    // Return one list of harmonic patterns based on number set in "harmonic" arg by
    // user
    b = "-----------------";
    s = b + "\nInstrument:" + instrument + "\nList of patterns with: ";

    case
        {harmonics < 0} {"Harmonic not available. Try bigger number".postln}
        {harmonics == 0} {(s + "ALL harmonics (%) \n").format(harmonics).postln; allHarmonics}
        {harmonics == 1} {(s + "ODD harmonics (%) \n").format(harmonics).postln; oddHarmonics}
        {harmonics == 2} {(s + "EVEN harmonics (%) \n").format(harmonics).postln;  evenHarmonics}
        {harmonics == 3} {(s + "PRIME harmonics (%) \n").format(harmonics).postln; primeHarmonics}
        {harmonics == 4} {(s + "SQUARED harmonics (%) \n").format(harmonics).postln; squaredHarmonics}
        {harmonics == 5} {(s + "FIBONACCI harmonics (%) \n").format(harmonics).postln; fibHarmonics}
        {harmonics > 5} {"Harmonic not available. Try smaller number".postln};
    };
)
i[1].play;
(

p = ~microtonalHarmonicPatGen.value(instrument: "microtonal4", freq: 70.8,
    harmonics:0, detunePercentage: 0.5, dur: 16, layers: 64);
i = ~microtonalHarmonicPatGen.value(instrument: "microtonal5", freq: 70.8,
    harmonics:0, detunePercentage: 1.5, dur: 8);
g = ~microtonalHarmonicPatGen.value(instrument: "microtonal4", freq: 70.7,
    harmonics:0, detunePercentage: 3.0, dur: 7);

w = 256; // Wait time between steps in routine
t = 1; // Counter for routine steps

// Function that retrieves the current status in the routine
s = {arg w; 
            w.wait; 
            "Sequence step % at %".format(t,  
            Date.getDate.format("%H:%M, %d/%m/%Y ")
        ).postln; 
        t = t+1; };

// Routine that plays patterns 
r =  Routine{
    s.value(0); p[0].play; 
    s.value(w); p[1].play;
    s.value(w); i[2].play;
    s.value(w); g[3].play;
    s.value(w); g[4].play;
    s.value(w); i[2].play;
}.play;
)

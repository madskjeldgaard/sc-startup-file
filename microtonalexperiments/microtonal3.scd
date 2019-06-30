s.reboot;
g = ServerOptionsGui(s);


(
SynthDef.new(\microtonal3, {
    arg out=0, amp = 1.0, risetime = 16, falltime = 16, freq1=70, freq2=70.5, freqdeviation = 2.5, 
    modphase = 0.25, pmi = 0.25, lforate = 0.25, lfoFB = 0.5;

    var env = EnvGen.kr( 
            envelope: Env([0, 1.0, 0 ], [risetime,falltime] ), 
            doneAction: 2 ); 
 
    //var lfo = PMOsc.kr(lforate, freq2 * lforate);   
    var lfo = SinOscFB.kr(lforate, lfoFB, 0.99);

    var sound1 = PMOsc.ar(freq1, freq1*2, pmi * lfo, modphase * lfo);
    var sound2 = PMOsc.ar(freq2 + freqdeviation, freq2 + freqdeviation *2, pmi * lfo, modphase * lfo);

    var sound = Splay.ar([sound1, sound2]); 

    Out.ar(out, sound * amp);

}).add;
)

x = Synth.new(\microtonal3);

x.free;

x.set(\freqdeviation, 0.5, \lforate, 0.10);

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
    layers = 20,
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
            \out, z+1,
            \amp, 1/(z+2),
            \panfreq, Pseq([z/10, z/5, z/2.5, z], layers),
            \freq1, z + freq, 
            \freq2, z + freq * (1 + (detunePercentage/100)), // the p variable is divided by 100 to represent detune in percent 
            \lforate, z * 0.01,
            \pmi, z * 0.1, 
            \modphase,z * 0.1, 
            \risetime, dur,
            \falltime, dur,
            \dur, dur/(z+1),
            \freqdeviation, Pseries (detunePercentage, detunePercentage/dur) 
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

p = ~microtonalHarmonicPatGen.value(freq: 70.5, detunePercentage:1.0, instrument: "microtonal3", harmonics: 2, dur: 16)


p[0].play;
Ppar(p[1..5]).play;

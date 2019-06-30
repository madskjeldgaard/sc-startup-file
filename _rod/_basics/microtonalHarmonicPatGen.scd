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
            \amp, 1.10,
            \panfreq, Pseq([z/10, z/5, z/2.5, z], layers),
            \freq1, z * freq, 
            \freq2, z * freq * (1 + (detunePercentage/100)), // the p variable is divided by 100 to represent detune in percent 
            \lforate, z * 0.2,
            \risetime, (dur),
            \falltime, (dur),
            \dur, dur/z,
            \freqdeviation, Pseries(z/1000, z/100) 
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

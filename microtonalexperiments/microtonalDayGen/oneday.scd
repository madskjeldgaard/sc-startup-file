
// Microtonal Day Generator (2017)
// by Mads Kjeldgaard

// A minimalistic, microtonal compositional study
// of two sine waves of the same initial frequency diverging
// in the microtonal space between c3 (130.81 hz) and c#3 (138.57 hz)
// over the course of 24 hours. 

// Listen to the waves beat against eachother as one of them stays at the
// initial frequency and the other travels to the end of that space between
// equal tempered notes.

// The piece is rendered at a low samplerate to allow file lengths of extreme
// longevity and keep it under 4gb at 16bit. This is factored into the code: The
// longer you make the composition, the lower the samplerate will be. You only
// need to adjust the 'days' variable.
//
// (Ps. This code only works on OSX and Linux systems, AFAIK)

(
// STEP 1: MAKE SYNTHDEF FILE

SynthDef("synthForOneDay", {
        arg f, a, amp = 1.00, dur=1, fb=0; 
        var sound = SinOsc.ar([f, f+a], fb); 

        sound = DFM1.ar(sound, f, fb*0.75);

        Out.ar(0, Splay.ar(sound) * amp ) 
    }).writeDefFile;
    
    // Recompile to make the SynthDef-file work in NRT
    thisProcess.platform.recompile;

// STEP 2: Create function 
~dayGen = { 
    arg fromFreq = 130.82, 
    toFreq =  138.58, 
    days = 1,
    outputDir = File.getcwd ++ "/",
    prefix = "TheUprising", 
    format=1,
    upDownProbability = 0.5; // Probability that the frequency will travel up or down during the composition

    var fileFormat, freqDiff = toFreq - fromFreq, 
    day = 86401, // There are 86400 seconds in a day. The extra second is because the iterators further down count from 0 
    iterations = day * days, // This is the number of seconds to be used in the array creation further down 
    samplerate = ((11025)/days).asInt, // Wav files need to stay under 4gb...
    // For stereo, 16 bit files this means a file of ~24 hours in length has to stay around 11025hz in samplerate. 
    // Then, divide that samplerate for each additional day. 
    oscFName, outputFName, suffix, iters, listOfOsc; 

    // File format and encoding
    // Set by input argument
    // SC uses LibSndFile to make files, see here for more info:
    // http://www.mega-nerd.com/libsndfile/
    case 
        // 8 bit FLAC
        {format==1} {fileFormat = "FLAC int8"; samplerate = samplerate*12; suffix = ".flac"}
        // 8 bit WAVE 
        {format==2} {fileFormat = "WAV uint8"; samplerate = samplerate*2; suffix = ".wav"}
        // 8 bit AIFF 
        {format==3} {fileFormat = "AIFF int8"; samplerate = samplerate*2; suffix = ".aiff"}
        // 16 bit FLAC
        {format==4} {fileFormat = "FLAC int16"; samplerate = samplerate*2; suffix = ".flac"}
        // 16 bit WAVE 
        {format==5} {fileFormat = "WAV int16"; samplerate = samplerate; suffix = ".wav"}
        // 16 bit AIFF 
        {format==6} {fileFormat = "AIFF int16"; samplerate = samplerate; suffix = ".aiff" }
        // 24 bit FLAC 
        {format==7} {fileFormat = "FLAC int24"; samplerate = samplerate * 2 * (2/3); suffix = ".flac"}
        // 24 bit WAVE 
        {format==8} {fileFormat = "WAV int24"; samplerate = samplerate * (2/3); suffix = ".wav"}
        // 24 bit AIFF 
        {format==9} {fileFormat = "AIFF int24"; samplerate = samplerate * (2/3); suffix = ".aiff"};

    // Construct audio output file name from function arguments and
    // variables
    outputFName =
    "%%-from-%hz-to-%hz-in-%-days-samplerate-%%".format(outputDir, prefix, fromFreq, toFreq, days, samplerate.asInt, suffix);

    // The same for the OSC file
    oscFName =
    "%%-from-%hz-to-%hz-in-%-days-samplerate-%.osc".format(outputDir, prefix, fromFreq, toFreq, days, samplerate);

    // Post welcome messages
    "Creating composition that travels % hz in % days ... \n".format(freqDiff, days, iterations).postln;
    "From % hz to % hz \n".format(fromFreq, toFreq).postln;
    "The resulting wavefile will be named '%' and have a samplerate of %".format(outputFName, samplerate).postln;
    
    // Here we use the probability defined in the upDownProbability variable
    // to decide whether the list should go up or down
    // iterated over in the listOfOsc array
    iters = all {:x, x <- if (upDownProbability.coin, (iterations..0), (0..iterations))};

    // This is a weird solution, but: create an array of OSC messages, one for every
    // second (iteration) that'll be written to an osc file later 
    listOfOsc = Array.fill(iterations, 
        {arg i; 
            
            // This is a fraction representing how far the iterator has gotten
            // Used to increase frequency, etc. 
            var iterFrac = (1/iterations)*i, freqAdd = (freqDiff / iterations) * iters[i]; 

            case 
                // Setup synth
                {i == 0 } { [i, [ \s_new, \synthForOneDay, 1000, 0, 0,  \f, fromFreq, \a, freqAdd, \amp, 0.0]] }
                // Fadein for the first hour:
                {i < (iterations/24) } { [i, [ \n_set, 1000, \f, fromFreq, \a, freqAdd, \fb, iterFrac, \amp, 0.75 * iterFrac * 24]] }
                // After fadein, keep increasing frequency 
                {i < iterations } { [i, [ \n_set, 1000, \f, fromFreq, \a, freqAdd, \fb, iterFrac, \amp, 1.0]] }
                // End with some silence 
                {i == (iterations-1) } {[i, [\c_set, 0, 0]]};

     } );

    // Open file for OSC writing
    f = File(oscFName,"w");

    // Iterate overa all osc messages and write them to the osc file
    iterations.do{arg i; f.write(listOfOsc[i].asRawOSC.size); f.write(listOfOsc[i].asRawOSC)};
    // Close file for writing
    f.close;
    "Done writing osc file: %".format(oscFName).postln;
    // Run scsynth in command line to render as 
    // Wav file
    c = "/Applications/SuperCollider.app/Contents/Resources/scsynth";     

    // The scsynth command
    // It is being called and produces the output files
    "% -N % _ % % % -o 2&& echo 'Done. You can find the file at: \n%'".format(c, oscFName, outputFName, samplerate.asInt, fileFormat, outputFName).unixCmd;
};

// STEP 3: Generate files

// This will generate the .wav files. WARNING: They are approximately 4gb each.
// Be careful!

// Frequency steps to travel 
t = [130.81,  138.59,  146.83,  155.56,  164.81,  174.61,  185.00,  196.00, 207.65,  220.00,  233.08,  246.94, 261.63];

// Do it
//~allTwelve = Array.fill(t.size, {arg i; ~dayGen.value(fromFreq: f[i]+0.01, toFreq: f[i+1]-00.1, days: 1, format:rrand(1,9) ); });


~dayGen.value(fromFreq: 131, toFreq: 140, days: 1, format:1); 
)

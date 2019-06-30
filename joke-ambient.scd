s.boot;
s.plotTree;
s.options.outDevice = "Soundflower (64ch)";

(
// An ambient classic: A subtractive sawtooth synth

SynthDef(\cli_ambient_synth, {
    arg out = 0, freq = 100, cutoff = 250, resonance = 0.15, amp = 0.5, pan = 0,
    atk = 0.01, dur = 1, rel = 1, detune = 0.001, noise = 0.01, filterEnv = 1,
    filterTime = 0.9, filterBias = 0;
    
    // Envelope stuff
    var e = Env.linen(atk, dur, rel);
    var env = EnvGen.kr(e, doneAction: 2);

    var filterenv = EnvGen.kr(
        e, 
        levelScale:cutoff, 
        levelBias: filterBias, 
        timeScale: filterTime, 
        doneAction: 0);

    // Our sound source is a sawtooth wave 
    // To make it stand out even more, we're adding a detuned saw as well
    var sig = DPW4Saw.ar(
        freq: [ freq, freq * detune.linlin(0.0, 1.0, 1.0, 2.0) ]
    ).sum;

    // The DFM1 ugen is a nice, juicy filter well suited for this purpose
    sig = RLPF.ar(
        in: sig, 
        freq: filterenv+20, 
        rq: resonance / 2
    );

    Out.ar(out, Pan2.ar(sig, pan) * env * amp * 0.1)
}).add;
)

(
/* var stretch = rrand(1.5,3); */
var stretch = 6;
var openNess = 3; //rrand(1,3);
var darkness = rrand(1,3);
var disintegration = rrand(1,4);

var pyramidtype = rrand(1,10);
var stretchArray = (1..disintegration).pyramid(pyramidtype);

var rootnote = rrand(0,11);

// This is the basic pattern.
// All the other patterns inherit their values from this
var basePat = 
    Pbind(\instrument, \cli_ambient_synth,
        \scale, Scale.minor,
        \degree, Pseq([0,2,3,6],inf),
        \octave, 5,
        \root, rootnote,
        \dur, 0.125,
        \stretch, Pstutter(12, Pseq(stretchArray, inf) * stretch),
        \atk, 0, 
        \rel, Pkey(\dur)/2, 
        \detune, Pwhite(0.0, 0.01 * darkness, inf),
        \pan, 0,
        \cutoff, openNess * Pseq((1..25),inf) * 100,
        \filterBias, Pseq([500, 1000],inf),
        \amp, 0.005,
        \filterTime, Pseq([0.5, 0.75, 1.0],inf),
        \resonance, 0.01
    );

var melodyNotes = 
    Pbindf(basePat,
        \octave, 4,
        \pan, Pwhite(-1,1,inf),
        \amp, 0.08
    );

var sustainedNotes = 
    Pbindf(basePat, 
        \dur, Pkey(\dur) * 4, 
        \atk, Pkey(\dur),
        \degree, Pkey(\degree),
        \cutoff, Pkey(\cutoff) * 0.25,
        \filterBias, Pkey(\filterBias) / 4,
        \octave, Pkey(\octave) - 1
    );

var ornamentationNotes = 
    Pbindf(basePat,
        \octave, Pkey(\octave) + 1,
        \dur, Pstutter(3, Pseq([0.125, Rest(1)],inf)),
        \amp, 0.18 * Pkey(\amp)
    );

var bassNotes = 
    Pbindf(sustainedNotes,
        \degree, Pseq([0, 6],inf),
        \dur, Pseq([4, Rest(4)],inf),
        \octave, Pkey(\octave) - Pstutter(4, Pseq([2,1],inf)),
        \amp, 0.10 * Pkey(\amp)
    );

var chords = 
    Pbindf(basePat,
        \degree, Pstutter(2, Pkey(\degree)) + [0, 2, 4],
        \octave, Pkey(\octave) - 1,
        \dur, Pkey(\dur) * 64,
        \cutoff, Pkey(\cutoff) * 0.25,
        \filterBias, Pseq([1500, 250, 500, 1000],inf),
        \filterTime, Pwhite(0.25, 1.0, inf), 
        \pan, Pwhite(-1.0,1.0,inf),
        \atk, Pkey(\dur),
        \amp, 4*Pkey(\amp) * Pn(Pseries(0.1, 0.01, 100),inf)
    );
        
var section = {
    |slice=7, plusDegree=0| 

    var pats = [
        Pbindf(chords, \stretch, 1.5, \octave, Pkey(\octave) - 1),
        Pbindf(chords, \stretch, 0.5, \octave, Pkey(\octave) + 1),
        Pbindf(chords, \stretch, 0.25, \octave, Pkey(\octave) + 1),
        Pbindf(chords, \stretch, 0.125, \octave, Pkey(\octave) + 2),
        Pbindf(sustainedNotes, \degree, Pkey(\degree) % 2, \stretch, 16),
        Pbindf(ornamentationNotes, \degree, 0, \stretch, 10),
        bassNotes,
        Pbindf(melodyNotes, \stretch, 0.25, \pan, Pwhite(-1.0,1.0,inf), \amp, Pn(Pseries(0.0, 0.01, 100), inf) * Pkey(\amp) * 0.05), 
    ];

        Pbindf( Ppar(pats[0..slice], inf), \degree, Pkey(\degree) + plusDegree)
    };

var main = Pseq([
    Pfindur(128, section.value()),
    Pfindur(64, Pbindf(section.value(5, -7), \scale, Scale.major)),
    Pfindur(64, Pbindf(section.value(3, -14), \scale, Scale.minor)),
    Pfindur(32, Pbindf(section.value(7, -21), \scale, Scale.major))
    ], inf);

var gr = Group.new;

main.play(TempoClock.default, quant: 1);

/* // Add the reverb effect to the tail of the saw tooth */ 
/* Synth.head(gr, */
/*     \cli_waveloss, */ 
/*     [ */ 
/*         \pitch, 3.0, */
/*         \rate, 0.001, */
/*         \drywet, 0.25 */
/*     ] */
/* ); */ 

/* Synth.tail(gr, */
/*     \cli_ambient_reverb, */ 
/*     [ */ 
/*         \drywet, 0.5, */ 
/*         \modDepth, 0.1, */ 
/*         \size, 3, */ 
/*         \time, 3 */ 
/*     ] */
/* ); */ 

)

s.avgCPU

(
/*

MODULAR DESIGN PATTERN INSPIRED BY SUPERDIRT

Note: 
- They all share the same audio bus (reading from it and then replacing its content)
- Using ReplaceOut for the effects is necessary
- The envelope frees the group

*/

// Synths
SynthDef(\soundgen, {|bus, freq=444| 
    ReplaceOut.ar(bus, SinOsc.ar(freq).dup )
}).add;

SynthDef(\fold, {|bus, lo=0.01, hi=0.6| 
    ReplaceOut.ar(bus, In.ar(bus, 2).fold(lo,hi))
}).add;

SynthDef(\silence, {|bus, silencebus| 
    Out.kr(silencebus, DetectSilence.ar(In.ar(bus, 2)))
}).add;

SynthDef(\ar_env, {|bus, atk=1, rel=1, dur| 
    ReplaceOut.ar(bus, In.ar(bus, 2)
    * EnvGen.kr(Env.perc(atk,rel), timeScale:dur, doneAction: 14) 
    )
}).add;

SynthDef(\out, {|bus| 
    Out.ar(0, In.ar(bus,2)) 
}).add;

/*

Events, groups and patterns

*/

// Create a new eventtype, this is called every time a pattern plays a "note"
// The "environment variables" with the tildes as prefix become arguments in the
// Event (see Pbind below)

Event.addEventType(\testEvent, {|server|

    server.makeBundle(nil, {
        // Organise the synths in group with the sound generator 
        // first and then the effects at the tail

        var gr = Group.new;

        Synth.head(gr, \soundgen, [\freq, ~freq]);
        Synth.tail(gr, \fold, [\lo, ~lo, \hi, ~hi]);
        Synth.tail(gr, \ar_env, [\dur, ~dur, \atk, ~atk, \rel, ~rel]);
        Synth.tail(gr, \out);

    });
});

// Play a pattern
Pbind(\type, \testEvent, 
    \degree, Pwhite(-14,7,inf),
    \octave, 4,
    \scale, Scale.minor,
    \lo, 0.1,
    \hi, Pwhite(0.15,0.8,inf),
    \atk, Pseq([0.05, 0.15, 0.75],inf),
    \rel, 1 - Pkey(\atk),
    \dur, 0.25+Pstutter(20, Pseq([1, 0.25, 0.125],inf)), 
).play;

// Playing this as well will fuck up the sound
Pbind(\type, \testEvent, 
    \degree, Pwhite(-14,7,inf),
    \octave, 5,
    \scale, Scale.minor,
    \lo, 0.1,
    \hi, Pwhite(0.15,0.8,inf),
    \atk, Pseq([0.05, 0.15, 0.75],inf),
    \rel, 1 - Pkey(\atk),
    \stretch, 0.125,
    \dur, 0.25 + Pstutter(20, Pseq([1, 0.25, 0.125],inf)), 
)).trace(prefix: 'pat2').play;


s.plotTree;

MIDIClient.init;    // if not already done

(
/*

 STUT !STUT !STUT !STUT !STUT !STUT !STUT !STUT !STUT !STUT !STUT !!!!!!

*/ 
var mOut = MIDIOut.newByName("intmidi", "supercollider").latency_(Server.default.latency);
var melody = [0,2,3,4,5,3,4,2];
u = 10;
l = LinkClock(1);

~mainChord = Pbind(
    \type, \midi,
        // this line is optional b/c noteOn is the default
        // just making it explicit here
    \midicmd, \noteOn,
    \midiout, mOut,    // must provide the MIDI target here
    \chan, 0,
    \degree, Pstutter(u, Pseq([0,3,4],inf)) + PChordStut(melody.pyramid, u, inf), 
        /*Pslide(mel, repeats: inf, len: 5, step: 1, start: 0,
            wrapAtEnd: true),*/
    \scale, Scale.minor,
	\root, -7,
    \stretch, 0.1,
    \octave,5,
    \dur, Pbjorklund2(5, 23, inf)
).collect({ |event|
    ~eventsOfP1 = event; // Accessible all over via Pfunc({~eventsOfP1[\key]})
    }).trace(\degree);

~harmonic1 = Pbindf(~mainChord.source,
    \degree, Pseq(melody.pyramid(1), inf) + 2, 
    \chan, 1,
    \octave, 5, //Pseq([5,4],inf),
    \dur, Pbjorklund2(5, 23, inf)
);

~harmonic2 = Pbindf(~harmonic1.source, 
    \degree, Pseq(melody.pyramid(2),inf) + 4,
    \chan, 2,
    \dur, Pbjorklund2(5, 23, inf)
);

~melody1 = Pbindf(~harmonic1.source,
    \degree, Pseq(melody.pyramid(3),inf),  
    \chan, 3,
    \octave, 4, //Pseq([5,4],inf),
    \stretch, Pkey(\stretch) * 2
);

~melody2 = Pbindf(~melody2.source,
    \degree, Pseq(melody.pyramid(4),inf),  
    \chan, 4,
    \stretch, Pkey(\stretch) * 2,
    \octave, 5 //Pseq([5,4],inf),
);

~melody3 = Pbindf(~melody1.source,
    \degree, Pseq(melody.pyramid(5),inf),  
    \chan, 5,
    \stretch, Pkey(\stretch) * 2,
    \octave, 6 //Pseq([5,4],inf),
);

/*
~p1.play;
~p2.play;
~p3.play;
~p4.play;
~p5.play;
*/

/*** Parallel lambda pattern pattern1 for synthDefName and synthDefName synths***/
~pattern1 = Plambda(
    Ptpar([ 
        0.0, ~mainChord,
        0.0, ~heldChords,
        0.0, ~harmonic1,
        u*4, ~harmonic2,
        8*u, ~melody1,
        12*u, ~melody2,
        16*u, ~melody2
    ], inf)
);

~pattern1.play(l, quant: 4);
/////
// PT PAR + PBINDF ABSTRACTIONS TO MAKE THINGS EVOLVE
)




(
var mOut = MIDIOut.newByName("intmidi", "supercollider").latency_(Server.default.latency);

// I'm not aware of a Pattern which pads another to a fixed length so that it adds rests
// to the end in case it's shorter, so here's such a thing
~pad = {|dur,pattern|Pfindur(dur,Pseq([pattern,Pbind(\note,Rest(),\dur,dur)],1))};

// Let's say you have a complexity level -> pattern function, here it's just the
// increasing number of notes, padded to 1
~fpatt = {|i|~pad.value(dur:1,pattern:Pbind(\dur,1/8,\degree,Pseq([2,4,3,7].lace(i),1)))};

// Complexity to pattern dictionary
~dict = Dictionary.newFrom((1..4).collect{|i|[i,~fpatt.value(i)]}.flatten);

~reich = EventPatternProxy();
~reich.source = Pdict(~dict,Pstutter(4,Pseq((1..4),inf)));
//~reich.play;

~p1 = Pbind(
    \type, \midi,
        // this line is optional b/c noteOn is the default
        // just making it explicit here
    \midicmd, \noteOn,
    \midiout, mOut,    // must provide the MIDI target here
    \chan, 0,
    \degree, ~reich
);
~p1.play;
)

~dict.postln





)

(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
//Record
//s.record;
)


~p1[0] = Pbind(
    \instrument, \unisonSamplePlayer2_vox3, 
    \buffer, o["ms20"][0], 
    \amp, 0.3,
    \rate, 1.0, 
    \dur, Pseq([8, 12, 16], inf),
    \loop, 1,
    \atk, 0 * Pkey(\dur), 
    \pan, -1,
    \rel, Pkey(\dur), 
    \out, 0
);

~p1.play(fadeTime:8);

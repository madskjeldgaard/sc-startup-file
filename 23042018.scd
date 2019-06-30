MIDIClient.init;    // if not already done
(

    // substitute your own device here
var    mOut = MIDIOut.newByName("intmidi", "supercollider").latency_(Server.default.latency);

~p1 = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, mOut,    // must provide the MIDI target here
    \chan, 0,
    \stut, 32,
    \degree, Plet(\chords, Pstutter(32, Pseq([
        [0,4,9],
        [0,4,8],
        [0,4,7]
        ],inf))),
    \stretch, 1.0,
    \scale, Scale.major,
    \dur, Pbjorklund2(5, 7)/8,
    //\vel, 127,
    \legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
    \amp, Pexprand(0.5, 1.0, inf)
);

~p2 = Pbindf(~p1.source,
        //\degree, Pstutter(Pkey(\stut)/4, Pseq([4,0,6,0,7,0,8,9].pyramid,inf)),
        \degree, Pget(\chords, 7, inf) + 4,
        \octave, 4,
        \chan, 1,
        \legato, 0.1,
        \dur, Pbjorklund2(5,8)/8
    );

~pattern1 = Plambda(
    Ppar([ 
        ~p1,
        ~p2
    ], inf)
);

~pattern1.play;
)

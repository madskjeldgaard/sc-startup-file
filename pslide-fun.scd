MIDIClient.init;    // if not already done
(
var mel = [0,2,0,1,3,5,3,2,6,7,10,5,7];
var mel2 = [0,1,2,1,0,0,2,3,4,3,4,3,2,1,0,2];

var mOut = MIDIOut.newByName("intmidi", "supercollider").latency_(Server.default.latency);

~p1 = Pbind(
    \type, \midi,
        // this line is optional b/c noteOn is the default
        // just making it explicit here
    \midicmd, \noteOn,
    \midiout, mOut,    // must provide the MIDI target here
    \chan, 0,
    \degree, Pseq([0,3,2,4,5].pyramid, inf),  
        /*Pslide(mel, repeats: inf, len: 5, step: 1, start: 0,
            wrapAtEnd: true),*/
    \scale, Scale.major,
    \stretch, 0.1,
    \octave,4,
    \dur, Pbjorklund2(11, 5, inf)
).collect({ |event|
    ~eventsOfP1 = event; // Accessible all over via Pfunc({~eventsOfP1[\key]})
    });


~p2 = Pbindf(~p1.source,
    \degree, Pfunc({~eventsOfP1[\degree] }) + 2,
    \chan, 1,
    \octave, 1+Pstutter(100, Pseq([4,5,4,6],inf)),
    \dur, Pbjorklund2(Pkey(\octave), 3, inf)
);

~p3 = Pbindf(~p1.source,
    \degree, Pstutter(2, Pfunc({~eventsOfP1[\degree] })) + 4,
    \chan, 2,
    \octave, Pstutter(100, Pseq([3,4,3,5],inf)),
    \dur, Pbjorklund2(9, 5, inf)
);

~p4 = Pbindf(~p3.source,
    \degree, 0, //Pfunc({~eventsOfP1[\degree] }) ,
    \chan, 3,
    \octave, 2,
    \dur,  Pbjorklund2(1, 5, inf)
);

~p1.play; ~p2.play;~p3.play;~p4.play;


/*
~p3 = Pbindf(~p1.source,
    \degree, Pstutter(2, Pseq([5, Pstutter(4, Pseq([0,3,4],inf))],inf)),
    \octave,5,
    \chan, 2,
    \dur,  Pbjorklund2(3, 1, inf)/8
).trace(\dur);
*/
)


MIDIClient.init;    // if not already done

(
var    mOut = MIDIOut.newByName("intmidi", "supercollider").latency_(Server.default.latency);
//var    mOut = MIDIOut.newByName("Fireface UC Mac (23741446)", "Port 1").latency_(Server.default.latency);

var melody = [0,3,4,3,2,3,6,6,5];

~p1 = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, mOut,    // must provide the MIDI target here
    \chan, 0,
    \degree, Pseq([0,3,4].pyramid,inf),
    \scale, Scale.major,
    \octave, Pstutter(32, Pseq([4, [4,5]],inf)),
    \stretch, 1,
    \dur, Pbjorklund2(4, 7)/8,
    /*
    
    \dur, Pseq([
        Pbjorklund2(5,9,1)/8,
        Pbjorklund2(5,18,1)/8
    ],inf), */
    \vel, 127,
    //\legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3)
);

~p1.play;

~p2 = Pbindf(~p1.source, 
    \degree, Pseq([0,3,4],inf) + [0,2,4], \dur, Pbjorklund2(5, 11)/8, 
    \chan, 2, \octave, [4,4,3],
    \legato, 0.61);

~p2.play;
)



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
MIDIClient.init;    // if not already done
(

    // substitute your own device here
var    mOut = MIDIOut.newByName("intmidi", "supercollider").latency_(Server.default.latency);

~p1[0] = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, mOut,    
    \chan, 0,
    \degree, Pn(PChordStut([0,7,14],10), inf, \doneChord), 
    \scale, Scale.major,
    \stretch, 1,
    \octave, Pgate(Pseq([5,4,5,6,4,3],inf), repeats: inf, key: \doneChord),
    \dur, Pbjorklund2(5,9)/8,
    \vel, 127,
    //\legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
    \amp, Pexprand(0.5, 1.0, inf)
);

~p2 = Pbindf(~p1.source, 
    \dur, Pbjorklund2(5,Pseq([6,3],inf),inf)/8, 
    \octave, 5,
    \degree, Pstutter(18, Pseq([7,6,5],inf))
);

~p3 = Pbindf(~p2.source, 
    \degree, 0,
    \octave, 6,
    \dur, Pbjorklund2(5,Pseq([9,6,3],inf),inf)/8 
);

)

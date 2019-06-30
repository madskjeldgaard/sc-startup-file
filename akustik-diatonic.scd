MIDIClient.init;    // if not already done

(
var    mOut = MIDIOut.newByName( "intmidi", "tidal").latency_(Server.default.latency);

~l = LinkClock(1);

~p1 = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, mOut,    
    \chan, 0,
    \degree, Pseq([0,2,4,6].pyramid,inf),
    \octave, 4, 
    \scale, Scale.whole,
    \dur,  Pbjorklund2(5, Pseq([12,13,15],inf), inf)/10,
    \vel, 127,
    \legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
    \amp, Pexprand(0.75, 1.0, inf)
);

~p2 = Pbindf(~p1.source,
    \degree, Pseq([1,3,5,6].pyramid(2),inf),
    \octave, 5, 
    \stretch, Pstutter(20, Pseq([1,3],1)), 
    \dur,  Pbjorklund2(5, 20, inf)/10
);

~par1 = Pfindur(20, Ppar([~p1, ~p2],inf));

~par2 = Pbindf(~par1.source, \root, 6);

~par3 = Pfindur(10, Pbindf(~par2.source, \degree, [0,3,6]));

Pseq([~par1, ~par3, ~par2], 1).play(clock:~l, quant:1);

)

[1,4,2].normalizeSum

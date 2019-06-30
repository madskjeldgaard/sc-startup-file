MIDIClient.init;    // if not already done

(
// substitute your own device here
~mOut = MIDIOut.newByName("intmidi", "supercollider").latency_(Server.default.latency);

~p = Pbind(
    \type, \midi,
    \midiCmd, \noteOn,
    \dur, Pseq([128, 64], inf),
    \degree, 5,
    \midiout, ~mOut,
    \chan, 0);

)
~p.play;

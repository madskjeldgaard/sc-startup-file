/***********
MIDI SETUP for: 

"The dome-like shape of the opposite side"

***********/
// Set tempo
(
var bpm = 100;
TempoClock.default.tempo = bpm/60;
)


// List connected out ports with names:
(
MIDIClient.init;
MIDIClient.destinations;


m = MIDIOut(0).latency_(Server.default.latency);
/**********

If you want to synchronize events played by a MIDI device 
and events played by the SuperCollider server, 
the MIDIOut object's latency must match the server latency. 
You can set the latency any time to affect all future events.

***********/

m.midiClock; // Sync with Midi clock
)
   
(
Scale.directory; // To see all possible scales
Tuning.directory;  // To see all posible tunings
)
(
    ~cantorDurs = Array.fill(60, {arg i; [x = (3/(i+1))*2, Rest(x)]});
    ~cantorDurs = ~cantorDurs.stutter(2);
    ~cantorDurs.removeAt(0);
    ~cantorDurs.sum;
    ~cantorDurs;
)


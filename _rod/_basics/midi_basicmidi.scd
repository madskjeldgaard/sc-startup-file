Server.local.boot;
Server.local.reboot;
// Set tempo
(
var bpm = 110;
TempoClock.default.tempo = bpm/60;
)


// List connected out ports with names:
(
MIDIClient.init;
MIDIClient.destinations;

m = MIDIOut(0);

a = Pbind(\degree, Prand([1, 2, 3, 5], inf, \dur, 1/8));
)

// chain a midi event into the pattern and play it (see Pchain)

(a <> (type: \midi, midiout: m)).play;
a.stop;
m.allNotesOff(16);

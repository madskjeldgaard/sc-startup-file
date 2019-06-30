// Raspberry pi address
p = NetAddr("192.168.0.34", 57110);

s = Server('madspi2', p);

// Send a synth def to the server
(
SynthDef("sine", {|dur=1, freq=440|
	var env = EnvGen.kr(Env.perc, timeScale: dur, doneAction: 2);
	Out.ar(0, env * SinOsc.ar(freq, 0, 0.2))
}).send(s, "done sending");
)

// Play a note
s.sendMsg("s_new", "sine", n = s.nextNodeID); // Put the node id in the n variable so we can use it to free the synth

// Stop said note
s.sendMsg("/n_free", n);

// Play a pattern on the server
Pbind(\instrument, \sine, \server, s, \dur, 0.25, \freq, Pwhite(100, 200)).play;
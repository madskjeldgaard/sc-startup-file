s.record;
k = KModules.new;
b = 10.collect{Buffer.alloc(s, s.sampleRate * 4)};

Ndef(\soundin, {SoundIn.ar(0)}).mold(1);

Synth.tail(1, \bufrecorder1, [\in, Ndef(\soundin).bus, \buffer, b[0]]);

(
	Pdef(\b1, Pbind(
		\buffer, b[0],
		\rate, Pwhite(0.15,2.0),
		\loop, 1,
		\dur, Pwhite(0.5, 10.0),
		\atk, Pwhite(),
		\rel, 1-Pkey(\atk)
	));

	Ndef(\b1prime).fadeTime=0.1;
	Ndef(\b1prime).source = Pdef(\b1);
	Ndef(\b1prime)[5] = \filter -> {|in| FreeVerb.ar(in[0], LFSaw.kr(0.1, mul:0.5, add:0.5), 5,  damp: 0.01,  mul: 1.0,  add: 0.0)};
	Ndef(\b1prime)[3] = \filter -> {|in| PitchShift.ar(in, 2.5, LFSaw.kr(LFNoise0.kr,add:0.5, mul: 3), LFNoise2.kr,  timeDispersion: 0.5,  mul: 1.0,  add: 0.0)};
	Ndef(\b1prime)[2] = \filter -> {|in| LeakDC.ar(in)};
	Ndef(\b1prime)[4] = \filter -> {|in| FreeVerb.ar(in, 0.95, 0.25, 0.01,  mul: 1.0,  add: 0.0)};
	Ndef(\b1prime)[5] = \filter -> k['fx']['spectral']['spectraldelay'];
	Ndef(\b1prime)[1] = \filter -> {|in| ( 2*in ).tanh};
	Ndef(\b1prime)[6] = \filter -> {|in| PitchShift.ar(in, 0.5, 4*Ndef(\pr)* 1.672, 1-Ndef(\pr), 0.5,  mul: 1.0,  add: 0.0)};
	Ndef(\b1prime)[7] = \filter -> {|in| FreeVerb.ar(in, Ndef(\pr).lag, 3, 0.1,  mul: 1.0,  add: 0.0)};
	Ndef(\b1prime)[8] = \filter -> {|in| FreqShift.ar(in, 0.1,  phase: 0.0,  mul: 1.0,  add: 0.0)};
	Ndef(\b1prime)[9] = \filter -> {|in| PitchShift.ar(in, 0.75, 3*Ndef(\pr)* 3.672, 0.3, 1-Ndef(\pr),  mul: 1.0,  add: 0.0)};
	Ndef(\b1prime)[10] = \filter -> k['fx']['spectral']['smear'];

	Ndef(\b1prime).play;
)

Ndef(\b1prime).gui;
Synth.tail(1, \bufrecorder1, [\in, Ndef(\b1prime).bus, \buffer, b[0], \prelvl, 0.5, \reclvl, 0.5]);

b[0] = b[0].normalize;

Ndef(\pr).fadeTime=0.1;
Ndef(\pr, {|g=1, dur=1, curve=10|EnvGen.kr(Env.perc(0.99, 0.01, 1, curve), g, timeScale: dur, doneAction:0)});
Ndef(\pr)[1] = \xset -> Pbind(\dur, Pwhite(0.5, 30), \g, 1);

KModules.postModuleList


(
Pdef(\hej,
	Pbind(\dur, 4))
)

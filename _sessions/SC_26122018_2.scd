b = BufFiles(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_real/PERCUSSIVE");
e = BufFiles(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_emf/converted");
(
SynthDef(\grain, {|amp=1, filterFreq=400, spectralwidth=0.05, sustain=0.01, out=0, buffer, rate=1.0, start=0.5, detune=2|
	/*var e = Env.pairs([
	[0, 0.0000001],
	[0.1, 0.9],
	[0.5, 0.5],
	[0.1, 0.6],
	[1.0, 0.0001]
	], \exp);
	*/
	var e = Env.sine(sustain);

	var env = EnvGen.kr(e, timeScale: sustain, doneAction: 2);

	var sig = PlayBuf.ar(1, buffer, rate * BufRateScale.kr(buffer), 1.0, start);
	sig = BPF.ar(sig, filterFreq, spectralwidth * 0.005); // BPF.ar(in, filterFreq, 0.005)

	Out.ar(out, LeakDC.ar(env * sig * amp).tanh)}
).add;
)

(
var size = 8;

Ndef(\saw, {|f=0.1|
	LinExp.kr(
		LFSaw.kr(f).clip(0.0,1.0),
	)
}).scope;

// 8 children playing
size.do{|i|
	var filterFreq = i.linexp(0, size, 100, 10000);

	Pdef(\g ++ i.asSymbol).clear;
	Pdef(\g ++ i.asSymbol,
		Pbind(
			\instrument, \grain,
			\filterFreq, filterFreq,
			\stretch, 10,
			\spectralwidth, Pkr(Ndef(\saw))*10,
			\amp, 1,
			\start, Pwhite(0.0, 0.75),
			\buffer, e[0],
			// \buffer, Pxrand(e, inf),
			\rate, Pkr(Ndef(\saw))*0.5*((i+1)/size),
			\dur, Pwhite(0.0001, 0.15),
			\start, Pwhite(),
			\sustain, Pkey(\dur) * Pkey(\stretch),
			\out, i+1
		)
	).play;
};

)

(
Pdef(\pattern,
	Pbind(\instrument, \default,
		\dur, Pexprand(0.1,3.0),
		\degree, Pxrand((1..10),inf)
	)
);

// Set the pattern as the source of our sound process
Ndef(\sound).source = Pdef(\p);

// Monitor the sound. Right now it's just the default synth's sound
Ndef(\sound).play;

// Add a pitch shift effect controlled by the mouse to the sound of the pattern
Ndef(\sound)[1] = \filter -> {|in| PitchShift.ar(in, MouseY.kr(0.1,1.0), MouseX.kr(0.1, 5.0))};

// Set the dry/wet ratio of the effect
Ndef(\sound).set(\wet1, 0.75)
)

(
Ndef(\sound)[1] = \filter -> {|in|
	var control = LFSaw.kr(Ndef(\i).kr.varlag(LFSaw.kr(10)) + 0.1,0,2,2);
	PitchShift.ar(in, 0.5, control, 0.1)!2}
)
Ndef(\i).set(\wet1, 0.4)
Ndef(\i).gui;


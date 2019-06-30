ServerOptions.outDevices
s.options.sampleRate;

(
s.options.outDevice = "Soundflower (64ch)";
s.reboot;
s.waitForBoot{
	b = BufFiles(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_real/PERCUSSIVE");
	c = BufFiles(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_real/TOOLS");

};
)

(
SynthDef(\grain, {|amp=1, sustain=0.01, out=0, buffer, rate=1.0, start=0.5, detune=2|
	var e = Env.pairs([
		[0, 0.0000001],
		[0.1, 0.9],
		[0.5, 0.5],
		[0.1, 0.6],
		[1.0, 0.0001]
	], \exp);

	// var e = Env.sine(sustain);

	var env = EnvGen.kr(e, timeScale: sustain, doneAction: 2);

	var sig = PlayBuf.ar(1, buffer, rate * BufRateScale.kr(buffer), 1.0, start);

	Out.ar(out, LeakDC.ar(env * sig * amp).tanh)}
).add;

// LFOS
Ndef(\saw, {|f=0.01|
	LinExp.kr(
		LFSaw.kr(f).clip(0.0, 1.0)
	).poll
});
Ndef(\lfo, {|f=0.001| LFCub.kr(SinOsc.kr(rrand(0.1, 3.0)) * f).clip(0.0, 1.0)});
Ndef(\lfo2, {|f=0.1| LFCub.kr(SinOsc.kr(rrand(0.1, 2.0)) * f).clip(0.0, 1.0)});

// Clear master pattern
Pbindef(\grainpat).clear;

// Create a master pattern that will be inherited
Pdef(\grainpat,
	Pbind(
		\instrument, \grain,
		\stretch, 2*(Pkr(Ndef(\lfo2)) * Pkr(Ndef(\lfo))) + Pn(Pstutter(32, Pseq((1.0, 1.5 .. 10.0)))),
		\buffer, Pxrand(c, inf),
		\start, Pwhite(0.0,0.9),
		\rate, Pkrlive(Ndef(\saw),0.1,1.0,1.0,2.0) * Pstutter(32, Pseq([10,13,11,12],inf)),
		\sustain, Pexprand(0.001, 0.1),
		\dur, Pkey(\sustain)
	)
);

Pdef(\grainpat).stop;

// 8 children playing
8.do{|i|

	var rando = rrand(0.125, 2.0);
	var scale = (i+1) / 8;

	Pdef(\grainpat ++ i.asSymbol,
		Pbindf(
			Pdef(\grainpat),
			\rate, scale * rando * Pkey(\rate),
			\stretch, rando * Pkey(\stretch),
			\out, i+1
		),

	).play

};
)

s.record;


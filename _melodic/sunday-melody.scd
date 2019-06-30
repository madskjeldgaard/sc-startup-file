(
	SynthDef.new(\saw, {|out=0, freq=442, atk=0.01, rel=0.99, width=0.3, dur=1, amp=1, pan=0.5|
		var env = EnvGen.kr(Env.perc(atk, rel), gate: 1, timeScale: dur,  doneAction: 2);
		var sig = VarSaw.ar(freq, 0, width: width, mul: env);
		sig = Pan2.ar(sig, pan);
		Out.ar(out, amp * sig);
	}).add;

)

Synth(\saw);


(
	Pdef(\pat1,
		Pbind(
			\instrument, \saw,
			\degree, Pseq([0,4,5],inf),
			\scale, Pstutter(256, Pseq([Scale.major, Scale.minor], inf), inf),
			\dur, 0.125,
			\amp, 0.5
		)

	).play;

	Pdeff.new(
		\pat2, \pat1,
		\dur, 0.125 * Pn(Pbjorklund2.new(11,13, length: 1), inf, \pb1),
		\degree, Pkey(\degree) + Pgate.new(Pseq([3,7,4]), repeats: inf,  key: \pb1),
		\pan, Psine(0.1),
		\sustain, Psine(0.01).abs + 0.1
	).play;

	Pdeff.new(
		\pat3, \pat2,
		\octave, 3,
		\degree, Pkey(\degree) + Pstutter(5, Pseq((0,2..10), inf)),
		\pan, Pexpodec.new(5, inf).explin(0.001,1.0, -1.0,1.0),
		\width, 0.2
	);

	Pdef(\pat4,
		Pbind(
			\instrument, \saw,
			\dur, Pbjorklund2(9, 13) / 4,
			\degree, Pseq((0,4..20),inf),
			\octave, 6,
			\amp, 0.3
		)
	).play;

)

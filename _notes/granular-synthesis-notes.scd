/*

Precision
- Use audio rate envelopes to make sure they work for smaller sounds
- Use OffsetOut for precision because even small imprecisions could effect the perception

Effiency
- Use the \grain event (doesn't keep a NodeID)
- For maximum efficieny directly communicate with the server using s.sendMsg("s_new", \synthname, -1, 0, 0, [args...])

*/

(
SynthDef.new(\gauuus, {|out, amp=1, freq=255, sustain=0.01, sawwidth=0.5, pan=0.5|
	var env = amp * LFGauss.ar(sustain, 0.25, 0, loop:0, doneAction:2);

	var sig = env * VarSaw.ar(freq, 0, sawwidth);

	sig = Pan2.ar(sig, pan.linlin(0.0,1.0,(-1.0),1.0));

	OffsetOut.ar(out, sig);
}).add;

Pdef(\g1,{|stuts=10, woggle=0.1, sustain=1.0|
	Pbind(
		\instrument, \gauuus,
		\pan, Pwhite(),
		\freq, Pwhite(1.0,1.0 + woggle.value) * Pstutter(stuts.value, Pxrand((250..1300))),
		\dur, Pexprand(0.01, 0.75),
		\amp, Pexprand(0.75),
		\sustain, sustain.value * Pkey(\dur),
		\sawwidth, Pexprand(0.1, 1.0)
	)
}
);

Pbindef(\recursive,
	\type, \phrase,
	\sustain, 1.0,
	\woggle, Pseq([0.1, 0.0, 0.25],inf),
	\instrument, \g1,
	\recursionLevel, 25
);

Pdef(\fxd,
	Pfx(Pdef(\recursive), \kdiffuse, \wet,1.0, \diffuse, Pexprand(), \xsdelay, Pexprand())
);

Pdef(\fxd2,
	Pfx(Pdef(\fxd), \kconformer, \wet, Pexprand(), \areal, Pexprand())
).play;

)


/*****

ENVELOPES

******/

(

// This will be the data we iterate over: An event dictionary containing envelopes
// The keys are the names of the envelopes and the values are the envelopes themselves
~envelopes = (
	quasi: Env([0, 1, 1, 0], [0.25, 0.5, 0.25] * 0.1, \sin), // Quasi gaussian
	three: Env([0, 1, 1, 0], [0.25, 0.5, 0.25] * 0.1, \lin), // Three line segment
	welch: Env([0, 1, 1, 0], [0.25, 0.5, 0.25] * 0.1, \welch), // Welch curve
	expodec: Env([1, 0.001], [0.1], \exp), // Exponential decay
	rexpodec: Env([0.001, 1], [0.1], \exp) // Reverse exponential decay
);


// Create an array that holds all the names of the synthdefs we are generating
~synthnames = [];

// This is the function that creates the synth defs. It contains a small granular sine wave synth inspired by Alberto de Campo's microsound chapter in the scbook
~makeSynth = {|envname, envelope|
	var synthname = \singrain_ ++ envname.asSymbol;

	~synthnames = ~synthnames.add(synthname);

	"Adding a synth called %".format(synthname).postln;

	SynthDef(synthname, { |out, amp=0.1, freq=440, sustain=0.01, pan|
		var snd = FSinOsc.ar(freq);
		var env = EnvGen.ar(
			envelope, timeScale: sustain, doneAction: 2);
		OffsetOut.ar(out, Pan2.ar(snd * env, pan));
	}, \ir ! 5).add;
};


~envelopes.keysValuesDo{|name,env|
	~makeSynth.value(name, env);
};

// A simple pbind that randomly plays all the synths we made
Pbind(
	\instrument, Pxrand(~synthnames, inf),
	\dur, Pwhite(0.075, 0.25),
	\degree, Pstutter(~synthnames.size, Pseq((1..10))),
	\sustain, 0.05,
	\namecall, Pfunc({|ev|
		"Playing the synth %".format(ev[\instrument]).postln

})).play

)


b = BufFiles(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_real/metallic objects/");
(
/*

An experiment with different granular envelopes

*/
Pdef.all.clear;

// This will be the data we iterate over: An event dictionary containing envelopes
// The keys are the names of the envelopes and the values are the envelopes themselves
~envelopes = (
	quasi: Env([0, 1, 1, 0], [0.25, 0.5, 0.25] * 0.1, \sin), // Quasi gaussian
	three: Env([0, 1, 1, 0], [0.25, 0.5, 0.25] * 0.1, \lin), // Three line segment
	welch: Env([0, 1, 1, 0], [0.25, 0.5, 0.25] * 0.1, \welch), // Welch curve
	expodec: Env([1, 0.001], [0.1], \exp), // Exponential decay
	rexpodec: Env([0.001, 1], [0.1], \exp) // Reverse exponential decay
);


// Create an array that holds all the names of the synthdefs we are generating
~synthnames = [];

// This is the function that creates the synth defs. It contains a small granular sine wave synth inspired by Alberto de Campo's microsound chapter in the scbook
/*~makeSynth = {|envname, envelope|
var synthname = \singrain_ ++ envname.asSymbol;

~synthnames = ~synthnames.add(synthname);

"Adding a synth called %".format(synthname).postln;

SynthDef(synthname, { |out, amp=0.1, freq=440, sustain=0.01, pan|
var snd = FSinOsc.ar(freq);
var env = EnvGen.ar(
envelope, timeScale: sustain, doneAction: 2);

// Compensate volume according to freq
snd = snd * AmpCompA.kr(freq);

OffsetOut.ar(out, PanAz.ar(4, snd * env, pan));
}, \ir ! 5).add;
};*/

~makeSynth = {|envname, envelope|
	var synthname = \bufgrain_ ++ envname.asSymbol;

	~synthnames = ~synthnames.add(synthname);

	"Adding a synth called %".format(synthname).postln;

	SynthDef(synthname, { |out, buffer, rate=1, start=0, loop=0, amp=0.1, sustain=0.01, pan, panwidth=1.0|
		var snd = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * rate, 1, start, loop).sum;

		var env = EnvGen.ar(envelope, timeScale: sustain, doneAction: 2);

		OffsetOut.ar(out, PanAz.ar(4, snd * env, pan, 10, panwidth));
	}, \ir ! 5).add;
};

~envelopes.keysValuesDo{|name,env|
	~makeSynth.value(name, env);
};

Pdefn(\instruments, Pxrand(~synthnames.scramble,inf));

// Sine based pattern phrase
Pdef(\graincircle, {|octave=3, rate=1, woggle=0.1|
	Pbind(
		\instrument, Pdefn(\instruments),
		\rate, rate.value * {rrand(1.0,1.0 + woggle)},
		\sustain, (octave.value.reciprocal) + Plazy({sin(Ptime())}).linexp(-1.0,1.0, 0.05, 0.5),
		\dur, Plazy({sin(Ptime())}).linexp(-1.0,1.0, 0.05, 1.0),
		\pan, Plazy({sin(Ptime())}).linlin(-1.0,1.0, 0.0, 2.0),
		\amp, 0.02
	).trace
});

// Sine based pattern phrase
Pdef(\chan42, {|octave=3, legato=0.0|
	Pbind(
		\instrument, Pdefn(\instruments),
		\sustain, Plazy({sin(Ptime())}).linexp(-1.0,1.0, 0.05, 0.5),
		\dur, 0.25,
		\pan, Pxrand((0.0, 0.5 .. 2.0), inf),
		\amp, 0.02
	)
});


Pdef(\or0,
	Plazy({
		var pats = 48.collect{|i|

			i = i+1;

			Pbind(
				\type, \phrase,
				\instrument, \graincircle,
				// \legato, Pwhite(0.1, 0.5),
				\buffer, Pxrand(b, inf),
				\lag, {rrand(0.0, 1.0)}.value,
				\rate, i.linexp(0, 47, 0.1, 10.0),
				\start, Pwhite(0.0, 0.5),
				\dur, i
			);
		};

		Ppar(pats,inf)

	})
).play;

)

(
w = Window.new("envelopes", Rect(0,0,400, 400));

~envelopes.envs.keysValuesDo{|k,v|
	v.plot(name:k.asSymbol)
};

)

~envelopes.envs
~envelopes.perc.plot;
~envelopes.makeSinc(6, 1000).plot
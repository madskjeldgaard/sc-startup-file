KModules
(
Ndef(\durlfo, {|f=0.01| LFSaw.kr(f).abs/4});
Ndef(\freqlfo, {|f=3, scale=1000, offset=500| SinOsc.kr(f, 0, scale, offset).abs});
Pdefn(\instruments, Pseq(~envelopes.synthnames, inf));

// Sine based pattern phrase
Pdef(\graincircle, {|octave=3|
	Pbind(
		\instrument, Pdefn(\instruments),
		\sustain, Pwhite(0.001,0.01,inf),
		\freq, Pkr(Ndef(\freqlfo)),
		\dur, Pkr(Ndef(\durlfo)) + 0.025,
		\pan, Pwhite(),
		\amp, 0.02
	)
});

Pdef(\graincircle).copy(\gc2);

Pdef(\gc2).play
Pdef(\gc2).set(\freq, 10000).gui;
Pdef(\graincircle).play;

)
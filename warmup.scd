p = Particular.new;
(

Pdef(\p1,
	Pbind(
		\instrument, Pseq([
			p.def("expodec"),
			p.def("rexpodec")
		], inf),
		\freq, 10001 * Pseq([1, 1.001],inf) ,
		\dur, Psine(0.01).linlin(-1.0,1.0,0.001, 0.1),
		\sustain, 0.1 * Pkey(\dur),
		\out, Pseq([0,1], inf)
	));

Ndef(\f).mold(2).fadeTime=1;
Ndef(\f)[0] = Pdef(\p1);
Ndef(\f)[1] = \filter -> {|in| Pan2.ar(in, 0)};
)

Ndef(\f).play();

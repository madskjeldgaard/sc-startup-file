p = Particular.new;
(

Pdef('p',
	Pbind(
		\instrument, p.def("expodec", "buf1"),
		\buffer, b.keyBufs[0],
		\rate, 3,
		\start, 0.0,
		\amp, 70,
		\dur, 0.1 + Psine(0.01).abs,
		\sustain, Pkey(\dur)
	)
).play;

)
b.keyBufs[0].play

p.plotEnvs;







(

Pdef('pat1',
	Pbind(
		\amp, 0.5,
		\dur, 0.1,
		\degree, Pseq([0,3,5,7,9,10],inf)));
)

(
Pdef('pat2',
	Pbind(
		\amp, 0.5,
		\dur, 0.1 + Psine(0.01).abs,
		\octave, 4,
		\degree, Pseq([0,3,4], inf))
	);

)

Pdef('pat2').play

(
Ptops([Pdef('pat1'), Pdef('pat2')], 0.1, true, \amp).play
)


Ptops.new(pat1, 100000, false, \amp)


$

OSCFunc.trace(true, true)

n = NetAddr.new("100.115.92.1",  7771)
n = NetAddr.new("192.168.0.11", 7777);
(
fork{
	loop{
		1.wait;
		n.sendMsg("/N3", 100)
	}
}
)

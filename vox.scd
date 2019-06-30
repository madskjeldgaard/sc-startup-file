(
s.waitForBoot{
	p = KParticles.new;
	b = ();
	Buffer.freeAll;
	b.rips = BufFiles(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_processed/voicerips");
}
)

(
Pdef(\rips1,
	Pbind(
		\dur, Psine(0.1).linlin(-1.0,1.0,0.01,1.0),
		\instrument, p.def("expodec", "buf2"),
		\buffer, Prand(b.rips, inf),
		\rate, Pexpodec(1000, inf).linlin(0.0001,1.0, 1.0,10.0),
		\out, Pxrand([0,1], inf)
	)
);

Pdeff(\rips2, \rips1, \instrument, p.def("rexpodec", "buf2"));
Pdeff(\rips3, \rips1, \instrument, p.def("perc", "buf2"));

Pwaves([Pdef(\rips1) , Pdef(\rips2), Pdef(\rips3)],  1,  true, \rate, \amp).play;

)
b.rips

Pdef.all.clear;
Pdef(\rips1).play;

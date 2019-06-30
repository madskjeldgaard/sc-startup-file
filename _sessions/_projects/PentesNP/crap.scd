(
g = Group.new;


Ndef(\siner,
	{|f=200| SinOsc.ar(f)}
);


Ndef(\upfuck,
	{|in, grain=0.5|
		Splay.ar(
			PitchShift.ar(in!10, grain, LFNoise2.kr*4)
		)
	}
);



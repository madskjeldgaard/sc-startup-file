f = MKtl('lpd3', "akai-lpd8");

(
f.elAt('pad','0','0').action = {|pad|
	pad.value.postln;
	Pbindf(Pdef(\phrases1),
		\woggle, pad.value,
		\dw, pad.value,
		\stretch, (1-pad.value).clip(0.01, 1.0)
	).play;

};
)

c.elAt('sl','0','0').action = {|sl| sl.value.postln;};

Pdef(\phrases1).play
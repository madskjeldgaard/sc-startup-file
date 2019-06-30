(
	Ndef('hel', {
		var sig = SynthDef.wrap({|freq=220|SinOsc.ar(freq)});
		sig;
	}).play;
)
Ndef(\hel).set(\freq, 521)

~ndefCallback.value('crazylfo', {LFNoise2.kr}, {|value| value.postln});

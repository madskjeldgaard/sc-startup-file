(
	// Measure RMS of sound input
	Ndef(\in, {|in=0|
		RMS.kr(SoundIn.ar(in));
	});

	// Send the analysed data from the server back to the client via OSC 
	Ndef(\osc1,{|rate=10, in|
		SendReply.kr(Impulse.kr(rate), '/osc1', in)
	}).map(\in, Ndef(\in));

	// Callback function
	OSCdef.new(\osc1, {|...args| 
		var val = args[0][3]; 
		Pdefn(\rms, val);
	},  path: '/osc1');

	// Control a pattern using the sound input
	Pdef(\pat1, 
		Pbind(
			\dur, 0.125,
			\degree, Pdefn(\rms) * 36,
		)
	).play;
)

(

// Effects
e = (
	pitchshift: {|in, grain=0.25, pitch=1, pd=0, td=0| PitchShift.ar(in, grain, pitch, pd, td)},
	freqshift: {|in, freq=1, phase=0| FreqShift.ar(in, freq, phase)},
	waveloss: {|in, loss, drop=1| WaveLoss.ar(in, drop * 20, 40, 2)},
	delay: {|in, delay=1| CombC.ar(in, 4, 0.1, delay*3)}
);

)

// Patch
(
m = [ e[\delay], e[\waveloss], e[\pitchshift], e[\freqshift]  ];

n = {|numChans=2, fade=10, moduleList, args|

	var np = NodeProxy.new(s, 'audio', numChans);

	np.source = {|f=110| SinOsc.ar(f)!2};

	// Add the fx
	moduleList.do{|module|
		np.add(\filter -> module)
	};

	// Set crossfade time
	np.fadeTime = fade;

	np.set(args);

	np;
};

h = n.value(2, 10, m, #[\f, 333, \ps, 3, \fs, 2]);

)
h.play;

h.xset(\ps, 2);
h.xset(\delay, 4, \td, 1, \pd, 0.01);
h.xset(\fs, 10);

h.xset(\wet1, 0.5, \wet2, 0.5, \wet3, 0.7)
/*

4-buffer-template.scd
2019-02-17
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/
/*

Strategi:
- 4 buffers
- 4 buffer players
- 4 buffer recorders

Spektromorfologi
Feedback

*/
s.record;
// s. Settings
(
	Ndef(\buf1).fadeTime=10;
	Ndef(\buf1).mold(1, 'audio');

	Ndef(\buf2).fadeTime=10;
	Ndef(\buf2).mold(1, 'audio');

	Ndef(\buf3).fadeTime=10;
	Ndef(\buf3).mold(1, 'audio');

	Ndef(\buf4).fadeTime=10;
	Ndef(\buf4).mold(1, 'audio');
)

// n. Normalize buffers
(
	~keyBufs=~keyBufs.collect{|k| k.normalize};
	~recBufs=~recBufs.collect{|k| k.normalize};
)

// p. Players
Ndef(\buf1, k['src']['bufplayer1']).xset(\buffer, ~keyBufs[0], \rate, 0.07 );
Ndef(\buf2, k['src']['bufplayer1']).xset(\buffer, ~keyBufs[0], \rate, 0.06 );
Ndef(\buf3, k['src']['bufplayer1']).xset(\buffer, ~keyBufs[0], \rate, 0.05 );
Ndef(\buf4, k['src']['bufplayer1']).xset(\buffer, ~keyBufs[0], \rate, 0.043);

// f. FX
// Settings for buf1
Ndef(\buf1).xset(\rate, 0.1, \wet1, 1.0, \room, 2.5, \damp, 0.001);

// Settings for buf2
Ndef(\buf2).xset(\rate, 1.3, \wet1, 0.8, \room, 5);

// Settings for buf3
Ndef(\buf3).xset(\rate, 1.5, \wet1, 0.8, \room, 5);

// Settings for buf4
Ndef(\buf4).xset(\rate, 0.3, \wet1, 0.8, \room, 5);

(
	Ndef(\buf1)[1] = \filter -> {|in, room=5, damp=0.125|
		FreeVerb.ar(in, 1, room, damp)
	};

	Ndef(\buf1)[2] = \filter -> {|in|
		PitchShift.ar(in,
			windowSize: 0.5,
			pitchRatio: 2.0,
			pitchDispersion: LFNoise2.kr(1),
			timeDispersion: 0.1,
			mul: 1.0,
			add: 0.0)
	};
)
(
	Ndef(\buf2)[1] = \filter -> {|in, room=5, damp=0.05|
		FreeVerb.ar(in, 1, room, damp)
	};
)
(
	Ndef(\buf3)[1] = \filter -> {|in, room=5, damp=0.025|
		FreeVerb.ar(in, 1, room, damp)
	};
)
(
	Ndef(\buf4)[1] = \filter -> {|in, room=2, damp=0.25|
		FreeVerb.ar(in, 1, room, damp)
	};
)

// r. Recorders
(
	Ndef(\rec1)[0] = Ndef(\buf1);
	Ndef(\rec1)[1] = \filter -> {|in|
		0*RecordBuf.ar(LeakDC.ar(in).tanh,
			~keyBufs[0],
			offset: 0.0,
			recLevel: 0.5,
			preLevel: 0.5,
			run: 1.0,
			loop: 0.0,
			trigger: 1.0,
			doneAction: 0)

	};
)
(
	Ndef(\rec2)[0] = Ndef(\buf2);
	Ndef(\rec2)[1] = \filter -> k['src']['recordbuf1'];
	Ndef(\rec2).set(\trig, 1, \buffer, ~keyBufs[1]);
)
(
	Ndef(\rec3)[0] = Ndef(\buf3);
	Ndef(\rec3)[1] = \filter -> k['src']['recordbuf1'];
	Ndef(\rec3).set(\trig, 1, \buffer, ~keyBufs[2]);

)
(
	Ndef(\rec4)[0] = Ndef(\buf4);
	Ndef(\rec4)[1] = \filter -> k['src']['recordbuf1'];
	Ndef(\rec4).set(\trig, 1, \buffer, ~keyBufs[3]);
)

// m. Modulation
(
	Ndef(\lfo1, {|f=0.1| LFSaw.kr(f).abs });
	Ndef(\r1, {LFNoise2.kr(500)});
	Ndef(\buf1).xmap(\room, Ndef(\lfo1), \rate, Ndef(\lfo1));
)
(
	Ndef(\lfo2, {|f=0.01281| LFSaw.kr(f).abs });
	Ndef(\r2, {LFNoise2.kr(500).varlag(LFSaw.kr(1))});
	Ndef(\buf2).xmap(\room, Ndef(\lfo2), \rate, Ndef(\r2));
)
// o. Output
(
	Ndef(\out).fadeTime=10;
	Ndef(\out, {
			// Pan2.ar(Ndef(\buf1));
			Splay.ar([
				Ndef(\buf1),
				// Ndef(\buf2),
				// Ndef(\buf3),
				// Ndef(\buf4)
		], spread: 0.5, level: 0.5)
		}).play;
)

~keyBufs[0].plot

~keyBufRout.value(0)


(rate:2, buffer: ~defaultbuf).play

s.meter;

s.plotTree

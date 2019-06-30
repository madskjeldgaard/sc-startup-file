b = Buffer.alloc(s, s.sampleRate * 4);
c = Buffer.alloc(s, s.sampleRate * 4);

b.plot

s.meter;

(
Ndef(\mx, {MouseX.kr});
Ndef(\my, {MouseY.kr});

Ndef(\rec, {|buffer, offset=0, reclvl=1, prelvl=1, run=1, loop=0, trig=1|
	var in = SoundIn.ar(0);
	RecordBuf.ar( in, buffer, offset, reclvl, prelvl, run, loop, trig, doneAction: 0)
});

Ndef(\rec).set(\buffer, b).map(\reclvl, Ndef(\mx), \prelvl, Ndef(\my));
)

(
Ndef(\player).mold(2, 'audio');

Ndef(\player,{|rate=0.25, amp=3|

	amp * PlayBuf.ar(1, b, (-1) * rate * [1.0, 1.01] * LFNoise2.kr(1).range(1.0,1.05), trigger: 1.0,  startPos: 0.0,  loop: 1.0,  doneAction: 0)
}).play;

)
Ndef(\player).mold(2, 'audio');

(
Ndef(\player)[1]=\filter->{|in|
	Pan2.ar(in, 1,  level: 1.0);
	// PitchShift.ar(in,
	//	windowSize: 0.5,
	//	pitchRatio: 0.5,
	//	pitchDispersion: 0.1,
	//	timeDispersion: 0.1
	// )
};

)

(
Ndef(\player)[2]=\filter->{|in|
	FreeVerb2.ar(in, in, 1.0, LFSaw.kr(0.1235).range(0.25,5.0),  damp: 0.5,  mul: 1.0,  add: 0.0)
};

Ndef(\player).xset(\wet1, 0.25, \wet2, 0.25).fadeTime=0.1;

)
(
	Ndef(\player)[3]=\filter->{|in|
		in;

	};

)

(
Ndef(\w).mold(2, 'audio');

	Ndef(\w, {
		LFSaw.kr(1)*Warp1.ar(1, c,  LFSaw.kr([ 0.001 , 0.00125]),  freqScale: 8*[ 0.125, 0.1251],  windowSize: 0.25,  envbufnum: -1,  overlaps: 32,  windowRandRatio: 0.2,  interp: 4,  mul: 1,  add: 0)
	}).play;

)
Ndef(\w)[2]=\filter->{|in|
	FreeVerb2.ar(in, in, 1.0, LFSaw.kr(0.235).range(0.25,5.0),  damp: 0.25,  mul: 1.0,  add: 0.0)
};

(

Ndef(\w)[3]=\filter->{|in|
	RecordBuf.ar(in, b,  offset: 0.0,  recLevel: 1.0,  preLevel: 0.0,  run: 1.0,  loop: 0.0,  trigger: 1.0,  doneAction: 0)

	in;}
)

s.record;
Ndef(\amok).clear;
(
Ndef(\amok).mold(2, 'audio');

Ndef(\amok, {|amp=5, rate=1, ggate=0, dur=4|
		var env = EnvGen.kr(Env.perc(0.9,0.1,1,10), gate:Dust.kr(0.1),  levelScale: 1.0,  levelBias: 0.0, timeScale: dur,  doneAction: 0).poll;
		amp *env * PlayBuf.ar(1, c, rate,  trigger: 1.0,  startPos: 0.0, loop:0,  doneAction: 0)
	});

	Ndef(\amok)[1000] = \set -> Pbind(\ggate, 1, \dur, 0.1 + Psine(0.1), \rate, 10*1.1 * Pexpodec(100));

	Ndef(\amok).play;

)

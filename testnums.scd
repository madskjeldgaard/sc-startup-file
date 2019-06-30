(
Ndef('b1').mold(2, 'audio');
Ndef('b1').fadeTime = 12;
Ndef('b1', {|rate=10|
	var rates = Array.rand(10, 0.5, 10.0);
	Splay.ar(
		PlayBuf.ar(1, [ b.keyBufs[0],b.keyBufs[0]  ],  rate: rate * rates * [ 0.08 , 0.045],  trigger: 1.0,  startPos: [0,0.5],  loop: 1.0,  doneAction: 0)
, levelComp: false)}).play;

)
(
Ndef('b2').mold(2, 'audio');
Ndef('b2').fadeTime = 12;
Ndef('b2', {|rate=10|
	var rates = Array.rand(10, 0.5, 10.0);
	Splay.ar(
		PlayBuf.ar(1, [ b.keyBufs[1],b.keyBufs[1]  ],  rate: rate * rates * [ 0.08 , 0.045],  trigger: 1.0,  startPos: [0,0.5],  loop: 1.0,  doneAction: 0)
, levelComp: false)}).play;
Ndef(\b2)[3] = \filter -> {|in| ( 10 * in ).tanh };

)
Ndef('b1')[1] = \filter -> {|in, room=1, damp=0.75| FreeVerb2.ar(in[0], in[1], 1, 5*room, damp,  mul: 1.0,  add: 0.0)};

Ndef(\l1, {|f=0.001| LFSaw.kr(f).abs})
Ndef(\l2, {|f=0.0015| LFSaw.kr(f, 2pi).abs})

Ndef(\b1).map(\room, Ndef(\l1), \wet1, Ndef(\l2));
Ndef(\b1).xset(\wet2, 0.5);

Ndef(\b1)[2] = \filter -> {|in, shift=0.5|  PitchShift.ar(in,  windowSize: 0.2, pitchRatio: shift,  pitchDispersion: 0.1,  timeDispersion: 0.1,  mul: 1.0,  add: 0.0)};

Ndef(\b1)[3] = \filter -> {|in| ( 10 * in ).tanh };

Ndef(\chaosbuf).mold(2, 'audio');
Ndef(\chaosbuf, {|rate,offset=0.25|5 * PlayBuf.ar(1, b.keyBufs[2], rate: offset+rate*5, loop:1)});
Ndef(\chaosbuf)[1] = \filter -> {|in| Pan2.ar(in.sum, LFNoise2.kr)};

Ndef(\l3, {|atk=0.5, rel=0.5|EnvGen.kr(Env.perc(atk, rel, 1, 10), gate: Dust.kr(1)).lag3})

Ndef(\chaosbuf).xmap(\rate, Ndef('l3'), \room, Ndef(\l1), \offset, Ndef('l2'))

Ndef(\chaosbuf).xset(\wet2, 0.5)
Ndef(\chaosbuf).play


Ndef('chaosbuf')[2] = \filter -> {|in, room=1, damp=0.75| FreeVerb2.ar(in[0], in[1], 1, 5*room, damp,  mul: 1.0,  add: 0.0)};


Ndef(\chaosbuf)[3] = \filter -> {|in| ( 25*in ).tanh};

(
Ndef(\test).mold(2, 'audio');

Ndef(\test, {|buffer, ggate=1, off=0.25, dur=4|
	3* PlayBuf.ar(1, buffer,  rate: off + Ndef(\l3).lag.abs * Ndef(\l2).lag * 2,  trigger: 1,  startPos: 0.3,  loop: 1.0,  doneAction: 0)
}).set(\buffer, b.keyBufs[3]).play;

)

Ndef(\test).set(\dur, 3);

s.meter



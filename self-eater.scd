
(
// s.options.outDevice = "Fireface UC Mac (";
s.options.inDevice = "USB Audio Device";

s.waitForBoot{
	~selfBuf=Buffer.alloc(s, s.sampleRate*4);
	~selfBuf2=Buffer.alloc(s, s.sampleRate*4);

};

)
(
Pdef(\src,
	Pbind(
		\instrument, p.def("perc", "buf1"),
		\buffer, ~selfBuf2,
		\dur, 0.01 + Psine(0.01).abs, //Prand([0.25, Rest(1), 0.125],inf),
		\start, Pwhite(0.0,1.0),
		\sustain, Pkey(\dur),
		// \degree, Pwhite(0,5,inf),
		\rate, Pkey(\dur) + Pseq([1,0.5, 0.25],inf)
	));

Pdef(\src).play;
)
Pdef(\src).stop
Ndef(\bufreccer).stop
(
// Ndef(\bufreccer)[0] = Pdef(\src);
Ndef(\bufreccer)[0] = Ndef(\bufpl);
Ndef(\bufreccer)[1] = \filter -> {|in| 0*RecordBuf.ar(in, ~selfBuf2,  offset: 0.0,  recLevel: 1.0,  preLevel: 0.0,  run: 1.0,  loop: 0.0,  trigger: 1.0,  doneAction: 0)};

)

(

Ndef(\bufpl, k['src']['bufplayer1']);
Ndef(\bufpl)[1] = \filter -> {|in| PitchShift.ar(in, LFNoise1.kr(1),  pitchRatio: 1.0,  pitchDispersion: 0.0,  timeDispersion: 0.0,  mul: 1.0,  add: 0.0)};
Ndef(\bufpl)[2] = \filter -> {|in| FreeVerb.ar(in, 1, 3)};
Ndef(\bufpl).set(\buffer, ~selfBuf2, \rate, 0.1).play;

)
b.keyBufs[0] = b.keyBufs[0].normalize;

Ndef(\bufpl).xmap(\rate, Ndef(\rate));
Ndef(\rate, {|f=0.01| LFSaw.kr(f*LFNoise2.kr(1).lag).abs.lag * 2 })

s.record;

k['src']['warp1'].argNames

p = Particular.new

p.def("rexpodec", "buf2")

~selfBuf = ~selfBuf.normalize

~selfBuf.plot
(
	Ndef(\rec, k['soundinbuf1']).set(\loop, 0, \buffer, ~selfBuf).play;
)
k['src']['soundinbuf1'].argNames

b.keyBufs[0]=b.keyBufs[0].normalize;

(
Ndef(\buf1, k['src']['warp1']).set(\buffer, b.keyBufs[0],\grainsize,
0.25).play;
Ndef(\buf1)[1] = \filter -> {|in, mix1=1| FreeVerb.ar(in, mix1, 0.2,  damp: 0.5,  mul: 1.0,  add: 0.0)};
Ndef(\buf2, k['src']['warp1']).set(\buffer, b.keyBufs[0],\grainsize,
0.5).play;
Ndef(\buf2)[1] = \filter -> {|in,mix2=1| FreeVerb.ar(in, mix2, 0.5,  damp: 0.2,  mul: 1.0,  add: 0.0)};

// Ndef(\buf3, k['src']['warp1']).set(\buffer, b.keyBufs[2]).play;
// Ndef(\buf4, k['src']['warp1']).set(\buffer, b.keyBufs[3]).play;
)
(

)
(
	Ndef(\lfo1, {|f=0.01|1+LFNoise2.kr(100*f).abs});
	Ndef(\buf1).xmap(\freq, Ndef(\lfo1));
Ndef(\lfo2, {|f=0.1| 4+LFNoise1.kr(100*f).abs});
	Ndef(\buf2).xmap(\freq, Ndef(\lfo2));
Ndef(\lfo3, {|f=0.05|1+LFSaw.kr(f)});
	Ndef(\buf1).xmap(\rate, Ndef(\lfo3));
Ndef(\lfo4, {|f=0.004|LFSaw.kr(f).abs });
	Ndef(\buf2).xmap(\rate, Ndef(\lfo4));

)

s.record;

k['src']['warp1'].argNames

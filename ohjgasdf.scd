k = KModules.new;

r = 8.collect{Buffer.alloc(s, 96000 * 4.0, 1)};

(
// Rec from mic
Ndef(\recbuf).mold(1, 'audio');
Ndef(\recbuf,{|buffer, inbus=0, offset=0.0, recLevel=1.0, preLevel=0.0, run=1.0, loop=0.0, trigger=1.0|

	var in = SoundIn.ar(inbus);

	0 * RecordBuf.ar(in, buffer, offset, recLevel, preLevel, run, loop, trigger, doneAction: 2).poll;

}).set(\buffer, r[0]).play
)


Ndef(\lfo, {LFNoise0.kr() * 1.0 + (SinOsc.kr(0.1)*LFSaw.kr(SinOsc.kr(0.812)).lag)});

Ndef(\lfo2, {1*SinOsc.kr(1)*LFSaw.kr(LFNoise1.kr(1)).lag});

Ndef(\lfo3, {0.01 + (1*SinOsc.kr(1).abs*LFSaw.kr(LFNoise1.kr(1)).abs.lag)});

k['fx']['pitch']['pitchshift'].argName
(
Ndef(\bufplay1, k['src']['bufplayer1']).set(\buffer, r[6], \rate, 0.1).map(\rate, Ndef(\lfo)).play;
Ndef(\bufplay1)[1] = \filter -> k['fx']['spectral'].choose;
Ndef(\bufplay1)[2] = \filter -> k['fx']['pitch']['pitchshift'];
Ndef(\bufplay1)[3] = \filter -> {|in| (in*5).tanh};
Ndef(\bufplay1);
Ndef(\bufplay1).set(\wet2, 0.8, \pitch, 2).map(\pitch, Ndef(\lfo), \td, Ndef(\lfo2), \grain, Ndef(\lfo3));
)

(
Ndef(\outrecorder).mold(1, 'audio');
Ndef(\outrecorder,{|buffer, inbus=0, offset=0.0, recLevel=1.0, preLevel=0.0, run=1.0, loop=0.0, trigger=1.0|

	var in = In.ar(inbus);

	0 * RecordBuf.ar(in, buffer, offset, recLevel, preLevel, run, loop, trigger, doneAction: 2).poll;

}).set(\buffer, r[7]).play

)
r[1].plot

(
Ndef(\newbufs).clear;
Ndef(\newbufs, k['src']['bufplayer1']).play;
Ndef(\newbufs)[1] = \kfilter -> k['fx']['spectral'].choose;
Ndef(\newbufs)[2] = \kfilter -> k['fx']['spectral'].choose;
Ndef(\newbufs)[3] = \kfilter -> k['fx']['spectral'].choose;
Ndef(\newbufs)[4] = \kfilter -> {|in| (in*3).tanh};
Ndef(\newbufs)[5] = \kfilter -> k['fx']['pitch']['pitchshift'];


)
Ndef(\newbufs).fadeTime = 0.25;
(
Ndef(\newbufs)[1000] = \xset -> Pbind(
	\start, Pwhite(),
	\dur, Pwhite(0.25, 62.0),
	\teeth1, Pseq([0.25, 0.75, 0.33, 1.0],inf),
	\nPartials2, Pexprand(),
	\wet1, Pexprand(), \wet2, Pexprand(), \wet3, Pexprand(), \wet5, 1-Pseq([0.1, 0.3, 0.75, 0.1, 0.15, 0.2], inf), \td, Pexprand([0.25, 0.1, 0.85], inf), \pitch, Pexprand(0.5)
);
)
Ndef(\newbufs).scope
k['fx']
Platform.openRecord

s.record

Ndef(\newbufs).gui;
b = Buffer.read(s, "/Users/madskjeldgaard/scripts/sc/_sessions/SC_190121_174548.wav");

Ndef(\newbufs).set(\buffer, b.bufnum).play;
Ndef(\newbufs).map(\pitch1, Ndef(\lfo), \td5, Ndef(\lfo3));
Ndef(\newbufs).source = k['src']['bufplayer2'];












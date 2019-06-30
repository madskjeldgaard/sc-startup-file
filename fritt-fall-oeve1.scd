 p = Particular.new;


 Pdef.Event

 Event

 (
	 Pdef(\p1,
		 Pbind(
			 \instrument, Prand([
				 p.def("expodec"),
				 p.def("rexpodec"),
				 p.def("sine")
			 ], inf),
			 \stretch, 1.5,
			 \dur, Pkr(Ndef(\beatslfo)).linlin(0.1,2.0,0.9,1.1) * Psine(0.001).linlin(-1.0,1.0,0.01,0.125) ,
			 \pw, Pwrand.new([1, 0.5], [0.9,0.1], inf),
			 \freq, Pkr(Ndef(\beatslfo)).linlin(0.1,2.0,0.9,1.1) * Psine(0.0125).linlin(-1.0,1.0,0.45, 0.5) * ( Pkey(\pw) * 10000 ) + Psine(0.1).linlin(-1.0,1.0,-100,100),
			 \sustain, Pkey(\dur) * Pkey(\pw),
			 // \amp, 1.0,
			 \out, Pseq([0,1],inf)
		 )
	 ).play;

	 Pdeff.new(\p2, \p1, \freq, Pkey(\freq) * 0.4, \dur, Pkey(\dur) * 2.25).play;

	 Pdeff.new(\p3, \p2, \freq, Pkey(\freq) * 1.4, \dur, Pkey(\dur) * 0.5, \amp, Pkey(\amp) * Pexpodec.new(100, inf)).play

)

Ndef(\deep, {|f=70, beats=1, amp=0.125| SinOsc.ar([ f, f-beats ], 0, amp)}).fadeTime_(10).mold(2).play;

Ndef(\freqlfo, {|f=0.001, loft=80, offset=70| SinOsc.kr(f, add:offset, mul: loft).poll})
Ndef(\beatslfo, {|f=0.001, loft=2, offset=0.1| SinOsc.kr(f, add:offset, mul: loft)})

Ndef(\deep).xmap(\f, Ndef(\freqlfo));
Ndef(\deep).xmap(\beats, Ndef(\beatslfo));

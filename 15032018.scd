(
	p = ProxySpace.push(s); p.fadeTime = 2;
	// p.clear
	// Start tempoclock
	p.makeTempoClock;
	//give proxyspace a tempo
	p.clock.tempo = 1;
	// Activate limiter
	//StageLimiter.activate;
	//Record
	//s.record;
)
~p1[0] = Pbind(\instrument, \singrain, \amp, 0.3, \stretch, Pseq([0.5, 3, 2], inf), \freq, Pstutter(17, Pseq([2, 1, 0.25], inf)) * Pgate(Pseq([1, 2, 0.5, 4], inf), repeats: inf, key: \pang) * 0.5 * Pkey(\stretch) * Pstutter(13, Pseq([440, 880, 110, 220], inf)), \dur, (Pkey(\stretch) / 100) + Proly(steps: 100, curve: 'log', repeats: inf) * 0.1, \atk, 0 * Pkey(\dur),
	\pan, Pn(Pseries(-1, 0.01,100), inf, \pang), 
	\out, 0
).evcollect;

(~p1[1] = \filter -> { | in |
	var i = FreqShift.ar( in .fold([0.2, 0.3, 0.4]), freq: [110, 220, 420], phase: 0).sum;
	i + JPverb.ar(i, t60: 1, damp: 0, size: 1,
		earlyDiff: 0.707, modDepth: 0.1, modFreq: 2,
		lowcut: 500, highcut: 2000)
}) 
~p1.play(fadeTime: 8);

~p2[0] = Pbindf(~p1.source, \stretch, 2, \freq, Pkey(\freq) * 0.5);

(~p2[1] = \filter - > { | in |
	var i = FreqShift.ar( in .fold([0.2, 0.3, 0.4]), freq: 0.5 * [110, 220, 420], phase: 0).sum;
	i + JPverb.ar(i, t60: 3, damp: 0, size: 0.1,
		earlyDiff: 0.707, modDepth: 0.1, modFreq: 2,
		lowcut: 500, highcut: 2000)
}) ~p2.play;

~ = Pbind(
    \instrument, \, 
    \buffer, Pseq(o[""],inf), 
    \amp, 0.3,
    \rate, , 
    \dur, Pseq([amp], inf),
    \loop, ,
    \atk,  Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~.play(fadeTime:);

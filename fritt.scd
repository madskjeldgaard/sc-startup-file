(
    Pdef(\p1, 
            Pbind(
            \instrument, Pseq([ p.def("expodec", "sin") , p.def("rexpodec")], inf),
            \r, Pwrand.new([1.1,0.9,0.5], [0.5, 0.25, 0.25], inf),
            \freqscale, 1,
            \freq, Pkey(\freqscale) * ( Pkey(\r) ) * 14000,
            \amp, Pexpodec.new(100, inf),
            \dur, Pkr(Ndef(\sinesvol)) +  Pexpodec.new(100, inf).expexp(0.0001, 1.0, 0.1, 1.0) * Pseq([1.0, Pwhite(0.25,2.0)], inf),
            \sustain, Pkey(\dur) * 0.01 * Pkey(\r).reciprocal,
            \pan, Pwhite(0.0,1.0)
        )
    );

    Pdef(\p1).play;

    Pdeff(\p2, \p1, \freq, Pkey(\freq) * ( Prexpodec.new(100, inf) + 0.5 ), \pan, 1.0).play;

    Pdeff.new(\p3, \p2, \dur, Pkey(\dur)*0.6).play;

    Pdeff.new(\p4, \p3, \dur, Pkey(\r)+( Pkey(\dur)*1.69 ), \freq, Prand([100, 10, 1],inf) - 10000, \pan, Psine(0.1, 0.1) ).play;

    Pdeff.new(\p5, \p4, \dur, Pkey(\dur)*2.69, \freq, 1000, \pan, Psine(0.1, 0.5)).play;

    Pdeff.new(\p6, \p5, \dur, Pkey(\dur)*2.69, \freq, 2100, \pan, Psine(0.1, 1.0)).play;

    Pwaves.new([Pdef(\p1), Pdef(\p2), Pdef(\p6), Pdef(\p3), Pdef(\p5, Pdef(\p4))],  1,  true,  \amp, \freqscale).play;
)
( 
    Ndef(\sines, {|f=80, amp=0.01, spread=1|
        var sig = SinOsc.ar([f, f*1.1, f*1.762, f*2.981, f*0.981],  phase: 0.0,  mul: 1.0,  add: 0.0);

        Splay.ar(sig,  spread: spread,  level: amp,  center: 0.0,  levelComp: true);
    }).play;
)

Ndef(\sines)[1] = \xset -> Pbind(\f, Pxrand([40, 80, 90, 100, 110, 120],inf), \dur, 48, \spread, Pwhite(0.0,1.0));

Ndef(\sinesvol, {Amplitude.kr(Ndef(\sines))[0]}).mold(1)

Event

-3.dbamp


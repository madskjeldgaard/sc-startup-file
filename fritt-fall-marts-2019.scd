/*

fritt-fall-marts-2019.scd
2019-03-09
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/
// s.record;
(
    Pdef(\p1, 
        Pbind(
            \instrument, 
            Pstutter.new(4, 
                Pseq([ p.def("perc"), p.def("click", "sin"), p.def("expodec", "sin"), p.def("rexpodec", "sin")  ], inf)
            ),
            \r, Pwrand.new([1.1,0.9,0.5], [0.7, 0.15, 0.15], inf),
            \freq, Pkey(\r) * Pwhite(2000, 14000),
            \amp, 1.05 * Psine(0.025).linlin(-1.0,1.0,0.1,1.0),
            \dur, 0.05*Pseq([Rest(2), 0.25, Pwhite(0.25,4.0), 0.5], inf),
            \sustain, Pkey(\dur) * 0.018 * Pkey(\r).reciprocal,
            \pan, Psine(0.03).linlin(-1.0,1.0,0.0,1.0)
        )
    );

    Pdef(\p1).play;

    Pdeff(\p2, \p1, \freq, Pkey(\freq) * 0.75, \dur, Pseq([ 0.95, 0.75, 2.5 ], inf) * Pkey(\dur)).play;
    Pdeff(\p3, \p2, \freq, Pkey(\freq) * 0.75, \dur, 0.95 * Pkey(\dur)).play;
    Pdeff(\p4, \p3, \freq, Pkey(\freq) * 0.75, \dur, 0.95 * Pkey(\dur)).play;
    Pdeff(\p5, \p4, \freq, Pkey(\freq) * Pseq([0.85, 0.5, 0.75],inf), \dur, 0.95 * Pkey(\dur)).play;
    Pdeff(\p6, \p5, \freq, Pkey(\freq) * 0.75, \dur, 0.95 * Pkey(\dur)).play;
    Pdeff(\p7, \p6, \freq, 250, \dur, 0.95 * Pkey(\dur)).play;
    Pdeff(\p8, \p7, \instrument, p.def("click"), \freq, Prand([50, 40, 60, 80],inf), \dur, Pseq([Rest(4), 1],inf) * Pkey(\dur)).play;
Pdeff(\p9, \p8, \instrument, p.def("rexpodec"), \freq, 40, \dur, Pseq([Rest(8), 4],inf)).play;


Pdef(\p10, 
    Pbind(
        \instrument, p.def("click"),
        \amp, 0.9 * Pn.new(
            Pseq([ Prexpodec.new(16,  repeats: 1),
            Rest(4)],1),  
            repeats: inf, key: \up),
            \dur, 1.5 * Pgate.new(Pseq([0.125, 0.05, 0.1],inf),  repeats: inf, key: \up),
            \sustain, ( 0.5+Prexpodec.new(16, inf)  )* Pkey(\dur) * 0.5,
            \freq, Pgate.new(Pseq([85, 90, 95, 100, 105],inf),  repeats: inf,  key: \up)
        )
    ).play;

    Pdeff.new(\p11, \p5, \dur, 0.66 * Pkey(\dur), \freq, Pkey(\freq) * 1.65).play;
    Pdeff.new(\p12, \p6, \dur, 0.66 * Pkey(\dur), \freq, Pkey(\freq) * 1.75).play;
    Pdeff.new(\p13, \p12, \dur, 0.66 * Pkey(\dur), \freq, Pkey(\freq) * 1.75).play;
    Pdeff.new(\p14, \p13, \dur, 0.66 * Pkey(\dur), \freq, Pkey(\freq) * 1.165).play;




)
(
    Pdef(\p1).stop;
)

(
    Ndef(\sines,{|f=69, a=0.0029|

        var sig = SinOsc.ar([f, f*0.95, f*0.75,f*7.15, f*3.318, f*3.685, f*4.761, f*5.771, f*6.761, f*2.762, f*2.1285, f*1.25, f*1.185, f*1.33, f*1.927],  phase: 0.0,  mul: 1.0,  add: 0.0);

        a*Splay.ar(sig,  spread: SinOsc.kr(f/1000).linlin(-1.0,1.0,0.1,1.0),  level: 1,  center: 0.0,  levelComp: true)
    
    }).play;
)

(
    Ndef(\sines)[1] = \xset -> Pbind(\dur, Pseq([48, 64, 72],inf), \f, 1.2*Pseq([89, 99, 105, 95],inf));
)

Ndef(\sines).stop;

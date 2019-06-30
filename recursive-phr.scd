(
Pdef(\phr1, {|freq=1000, ratio=1|
    Pbind(
        \instrument, p.def("expodec"),
        \dur, Pseq((0.1,0.2..1.0)),
        \sustian, Pkey(\dur) * 0.5 * freq.value.explin(18000, 20, 0.1,1.0),
        \freq, freq.value
    )
});
)
( 
    Pdef(\master,
        Pbind(
            \type, \phrase,
            \instrument, \phr1,
            \freq, Pwhite(100,1000),
            \recursionLevel, 3,
            \sustain, 1
        )
    ).play;
)

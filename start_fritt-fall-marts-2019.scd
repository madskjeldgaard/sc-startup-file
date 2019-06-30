/*

start_fritt-fall-marts-2019.scd
2019-03-08
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/
(
    Pdef(\p1, 
            Pbind(
            \instrument, p.def("expodec", "sin"),
            \r, Pwrand.new([1.1,0.9,0.5], [0.5, 0.25, 0.25], inf),
            \freq, Pkey(\r)  * 10000,
            \amp, 1, 
            \dur, Pseq([Rest(1), 1.0, Pwhite(0.25, 4.0)], inf),
            \sustain, Pkey(\dur) * 0.001 * Pkey(\r).reciprocal,
            \pan, Pwhite(0.0,1.0)
        )
    );

    Pdef(\p1).play;
)

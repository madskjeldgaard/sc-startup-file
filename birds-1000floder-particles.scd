/***************** SETUP *****************/
( 
    ~numOuts = 4;
    Server.local.options.numOutputBusChannels_(~numOuts);
    ~numOuts = ~numOuts - 1;

    p = Particular.new();

)
/***************** PHRASES *****************/
( 
    Pdef(\a, 
        Pbind(
            \instrument, p.def("click"), 
            \dur, Pseq([Pn(0.1, 10), Rest(0.5)],2), 
            \sustain, Pkey(\dur)*Pwhite(0.125, 0.35),
            \freq, Pexpodec(15).linexp(-1.0,1.0,5000, 10000),
            \amp, Pwhite(0.2, 0.35)
        )
    );

    Pdef(\b, 
        Pbind(
            \instrument, p.def("click"), 
            \dur, Pseq([Rest(0.1), 0.05, Pxrand([0.1, 0.05, 0.125])],10), 
            \sustain, Pkey(\dur)*Pwrand([0.5, 1.25], [0.8, 0.2], inf),
            \freq, Pwrand([7000, Pstutter(3, 5000), 10100],[0.3, 0.1, 0.6], inf),
            \amp, Pwhite(0.1, 0.2)
        )
    );

    Pdef(\c, 
        Pbind(
            \instrument, p.def("click"), 
            \dur, Pseq([Rest(0.1), 0.05],20), 
            \sustain, Pkey(\dur) * Psine(10).linlin(-1.0,1.0,0.01,0.5),
            \freq, 8000,
            \amp, Pexpodec(20)* 0.5
        )
    );

    Pdef(\d,
        Pbindf(
            Pdef(\b), 
            \instrument, Pwrand([p.def("click"), p.def("rexpodec")], [0.9, 0.10], inf),
            \freq, ( 1-Pkey(\dur) ) * Pkey(\freq)
        )
    );

    Pdef(\e,
        Pbindf(Pstutter(2, Pdef(\a), \amp, Pseq([0.75, 0.5],inf)*Pkey(\amp))) 
    );

    Pdef(\0,
        Pbind(
            \dur, Prand([Rest(1.32348), Rest(2.812348), Rest(2.1234)], 1)
        )
    );

)
/***************** MASTER PATTERN *****************/
( 
    Pdef(\birdsequence1, 
        Pbindf(
            Psym(Pn(Pxrand("abcde0",6), inf, \phrases), Pdef.all),
            \dur, Pwhite(0.9, 1.1) * Psine(1).linlin(-1.0,1.0,1.0,3.0) * Pkey(\dur),
            \sustain, Psine(1, 1pi).linlin(-1.0,1.0,1.0,1.2) * Pkey(\sustain),
            \freq, Pgate.new(Pseq([1.0, 0.9, 0.8]),  repeats: inf,  key: \phrases)*Pkey(\freq),
            \out, Pxrand((0..~numOuts), inf)
        )
    );
)

Pdef(\birdsequence1).play;
s.record("~/Desktop/birds-4chan.wav".asAbsolutePath, numChannels: 4)

s.meter;

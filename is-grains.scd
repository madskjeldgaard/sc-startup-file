s.options.numOutputBusChannels=64;
s.reboot;

p = Particular.new;

p.postEnvs

b = Buffer.read(s, "/Users/madskjeldgaard/Dropbox/_projekter/Etude\ i\ is/Lydfiler/Peblinge\ Sø\ hydrofon\ is\ 2017\ \(clean\)\ render\ 001\ reversed\ 001\ render\ 002\ reversed\ 001.wav");

( 
    Pdef(\p1, 
        {|tightness=5| 
            Pbind(
                \instrument, p.def("quasi", "buf2"),
                \buffer, b,
                \stretch, 1.7,
                \rate, Pwhite(0.15,4.0) / tightness,
                \dur, Pn(Pexpodec(128)*2, inf) * Psine(tightness/100, tightness * 2pi).linlin(-1.0,1.0,0.01,0.1),
                \amp, Pexprand(0.75, 1.5),
                \out, Pseq((0..11), inf),
                \sustain, tightness*Pkey(\dur)
            )
        }
    ).play;

    Pdef(\p2, 
        {|tightness=1.5| 
            Pbind(
                \instrument, Pseq([p.def("rexpodec", "buf2"), p.def("expodec", "buf2")],inf),
                \buffer, b,
                \stretch, 1.27,
                \rate, Pwhite(0.15,5.0) / tightness,
                \dur, Pn(Pexpodec(128)*2, inf) * Psine(tightness/100, tightness * 2pi).linlin(-1.0,1.0,0.01,0.1),
                \amp, Pexprand(0.75, 1.5),
                \out, Pseq((0..11), inf),
                \sustain, tightness*Pkey(\dur)
            )
        }
    ).play;

    Pdef(\p3, 
        {|tightness=0.5| 
            Pbind(
                \instrument, p.def("click", "buf2"),
                \buffer, b,
                \stretch, 1.9,
                \rate, Pwhite(0.15,5.0) / tightness,
                \dur, Pn(Pexpodec(128)*2, inf) * Psine(tightness/100, tightness * 2pi).linlin(-1.0,1.0,0.01,0.1),
                \amp, Pexprand(0.75, 1.5),
                \out, Pseq((0..11), inf),
                \sustain, tightness*Pkey(\dur)
            )
        }
    ).play;

    Pdef(\p4, 
        {|tightness=3.3| 
            Pbind(
                \instrument, p.def("click", "buf2"),
                \buffer, b,
                \stretch, 1.9,
                \rate, Pwhite(0.15,5.0) / tightness,
                \dur, Pn(Pexpodec(128)*2, inf) * Psine(tightness/100, tightness * 2pi).linlin(-1.0,1.0,0.01,0.1),
                \amp, Pexprand(0.75, 1.5),
                \out, Pseq((0..11), inf),
                \sustain, tightness*Pkey(\dur)
            )
        }
    ).play;

    Pdef(\p5, 
        {|tightness=4.3| 
            Pbind(
                \instrument, p.def("expodec", "buf2"),
                \buffer, b,
                \stretch, 1.9,
                \rate, Pwhite(0.15,5.0) / tightness,
                \dur, Pn(Pexpodec(128)*2, inf) * Psine(tightness/100, tightness * 2pi).linlin(-1.0,1.0,0.01,0.1),
                \amp, Pexprand(0.75, 1.5),
                \out, Pseq((0..11), inf),
                \sustain, tightness*Pkey(\dur)
            )
        }
    ).play;

    Pdef(\p6, 
        {|tightness=7.3| 
            Pbind(
                \instrument, p.def("click", "buf2"),
                \buffer, b,
                \stretch, 1.9,
                \rate, Pwhite(0.15,5.0) / tightness,
                \dur, Pn(Pexpodec(128)*2, inf) * Psine(tightness/100, tightness * 2pi).linlin(-1.0,1.0,0.01,0.1),
                \amp, Pexprand(0.75, 1.5),
                \out, Pseq((0..11), inf),
                \sustain, tightness*Pkey(\dur)
            )
        }
    ).play;

    Pdef(\p7, 
        {|tightness=9.3| 
            Pbind(
                \instrument, p.def("click", "buf2"),
                \buffer, b,
                \stretch, 1.9,
                \rate, Pwhite(0.15,5.0) / tightness,
                \dur, Pn(Pexpodec(128)*2, inf) * Psine(tightness/100, tightness * 2pi).linlin(-1.0,1.0,0.01,0.1),
                \amp, Pexprand(0.75, 1.5),
                \out, Pseq((0..11), inf),
                \sustain, tightness*Pkey(\dur)
            )
        }
    ).play;






    Pdef(\phr1, 
        Pbind(
            \type, \phrase,
            \instrument, \p1,
            \dur, Pseq((1..10),inf),
            \sustain, Pkey(\dur)  + Psine(0.1).linlin(-1.0,1.0,0.0,10.0),
            \tightness, Pwhite(0.25, 2.0),
            \legato, 4,
            \recursionLevel, 1 
        )
    );
)

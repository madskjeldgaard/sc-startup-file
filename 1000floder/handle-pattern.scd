/*
Problems: spectral FX only 1 channel

*/
s.reboot;

b = BufFiles.new(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_real/PIEZO");
c = BufFiles.new(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_real/Pots\ and\ pans\ bernt\ ankers\ gate");
p = Particular.new;
(
    Pdef(\h1,
        Pbind(
            \instrument, Prand([ p.def("rexpodec", "buf1"), p.def("expodec", "buf2") ], inf), 
            \buffer, Pxrand(c, inf),
            \dur, Pwhite(0.75, 2.0) * ( Prexpodec.new(100, inf) + 0.1 ),
            \sustain, 8*Pkey(\dur),
            // \rate, Pwhite(0.25, 2.0) * Pkey(\dur).reciprocal,
            \rate, Ndef(\noise).asMap,
            \loop, 1,
            \start, 0.0, //Pwhite(0.0,0.75),
            \pan, Pwhite(0.0,1.0),
            \out, 0
        )
    ).play;

    Pdeff.new(\h2, \h1, \out, 2, \dur, Pwhite(1.0,2.0) * Pkey(\dur) * 2).play;
    Pdeff.new(\h3, \h2,\out, 4,  \dur, Pkey(\dur) * 2).play;
    Pdeff.new(\h4, \h3,\out, 6,  \dur, Pkey(\dur) * 3).play;
    Pdeff.new(\h5, \h4,\out, 8,  \dur, Pkey(\dur) * 3).play;

    Ndef(\noise, {2 +( LFCub.kr(0.125) * LFTri.kr(0.1256) * LFSaw.kr(0.143) * 6)});
)

s.options.numOutputBusChannels = 64;

s.meter;

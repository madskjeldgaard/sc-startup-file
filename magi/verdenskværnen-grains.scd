/*

verdenskværnen-grains.scd
2019-04-01
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/

(
    ~outs = (0..31);

    ~destinationFile = "verdenskværn-grains-%ch.wav".format(~outs.size);

    p = Particular.new;
    z = Score.new;

    // In files
    ~files = "/Users/madskjeldgaard/Dropbox/_sound_archive/_real/HANDLING\ NOISE";

    // Hvor lydene ender
    ~renderToFolder = "~/Desktop/";

    // Load buffers in i en array som føjes til score
    ~loadBuffersToScore = {|score, path|
        var files = PathName(path).files;
        var buffers = files.size.collect{Buffer.new(numChannels:2)};

        files.do({|soundfile, index| 
            score.add(
                [0,
                    buffers[index].allocReadMsg(soundfile.asAbsolutePath)
                ]
            )
        });

        score.sort;

        [ score, buffers ];
    };

    // 60 minutter
    ~duration = 32; 

    #z, b = ~loadBuffersToScore.(z, ~files); 

    // create a Buffer object for adding to the Score
    ~pattern = Pbind(
        \instrument, p.def("click", "buf2"), //Pxrand( [ p.def("expodec", "sin"), p.def("click", "sin"), p.def("rexpodec", "sin")], inf),
        \buffer, Pxrand(b, inf),
        \start, 0, //Pwhite(0.0, 0.75),
        \dur, Pstutter(~outs.size, Pseq((1..5), inf)) * 0.01,
        \rate, Pstutter(~outs.size, Pwhite(0.1,10.0)), 
        // \freq, Pseries(0,1,inf) + Pstutter(~outs.size, Pwhite(100, 1000), inf),
        \sustain, Pkey(\dur),
        // \amp, Psine(0.0099, 0.25).linlin(-1.0,1.0,0.3,0.5),
        \out, Pseq(~outs, inf)
    ).asScore(~duration);

    z.score = z.score ++ ~pattern.score;

    z.sort;

    // z.play;

    // Settings for the NRT server
    o = ServerOptions.new
    .numOutputBusChannels_(~outs.size)
    .maxNodes_(1024 * 256)
    .numBuffers_(1024 * 64)
    .memSize_(2.pow(20));

    // RENDER SCORE
    ~outfile = PathName( ~renderToFolder ++ ~destinationFile);
    // ~outfile = ~renderToFolder ++ PathName(~outfile.fileNameWithoutExtension).nextName ++ "." ++ ~outfile.extension;
    z.render(~outfile.asAbsolutePath, 
        maxTime: nil, 
        sampleRate: 96000, 
        headerFormat: "wav", 
        sampleFormat: "int16", 
        options: o
    );

)

s.meter;

0.25.reciprocal

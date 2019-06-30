/*

magi-pats.scd
2019-03-31
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/
( 

        // MAKE THE SYNTHS

		// Function for buffer player synth defs
		~bufplayerfunc = {|numchans=1|
			{|rate=1, buffer, trigger=1, start=0, loop=0, atk=0.1, sus=0.8, rel=0.1, curve=10, dur=1, amp=1, out=0|
				var env = EnvGen.kr(Env.linen(atk, sus, rel, 1, curve),  gate: 1.0,  levelScale: amp,  levelBias: 0.0, timeScale:dur,  doneAction: 2);
				var sig = PlayBuf.ar(numchans, buffer, rate * BufRateScale.kr(buffer),  trigger,  start * BufDur.kr(buffer),  loop);

				Out.ar(out, sig * env);
			}
		};
        
        // Store the CTK synths in a an event
        ~ctkSynths = ();

		[SynthDef, CtkSynthDef].do{|which|
			(1..64).do{|chanNum|
				var name = "bufplayer" ++ chanNum.asString;
				switch(which,
					SynthDef, { which.new(name, ~bufplayerfunc.value(chanNum)).add },
					CtkSynthDef, { ~ctkSynths[name.asSymbol] = which.new(name, ~bufplayerfunc.value(chanNum)) }
				);
			};
		};

    // NRT STUFF AKA WHERE THE MAGIC HAPPENS

    ~filename = "magi5.wav";

    z = Score.new;

    // In files
    ~files = "/Users/madskjeldgaard/Dropbox/scripts/sc/magi/magi1/Lyde\ fra\ Rasmus";

    // Hvor lydene ender
    ~renderToFolder = "/Users/madskjeldgaard/Dropbox/scripts/sc/magi/magi1/Lyde\ til\ Rasmus/";

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
    ~duration = 60*60; 

    #z, b = ~loadBuffersToScore.(z, ~files); 

    // create a Buffer object for adding to the Score
    ~pattern = Pbind(
        \instrument, \bufplayer2,
        \buffer, Pxrand(b, inf),
        \rate, Pwhite(0.1,1.0),
        \start, Pwhite(0.0, 0.75),
        \rel, Psine.new(0.01, phase: 0).linlin(-1.0,1.0,1.0,2.0),
        \dur, Pkey(\rel) * Pwhite(0.125, 1.0),
        \amp, Psine(0.0099, 0.25).linlin(-1.0,1.0,0.3,0.5)
    ).asScore(~duration);

    z.score = z.score ++ ~pattern.score;

    z.sort;

    // RENDER SCORE
    
    ~outfile = PathName( ~renderToFolder ++ ~filename );

    ~outfile = ~renderToFolder ++ PathName(~outfile.fileNameWithoutExtension).nextName ++ "." ++ ~outfile.extension;

    z.render(~outfile.asAbsolutePath, maxTime: nil, sampleRate: 96000, headerFormat: "wav", sampleFormat: "int16");

)

// Setup
~ambisetup = "/Users/madskjeldgaard/Dropbox/scripts/sc/instruments/vst-ambisonics.scd".load;
~ambisetup.value(/*order:3, speakerConfiguration, output, */search:false)

// Sound:
(
    // Synth functions
    Ndef(\blip, {|freq=0.25, numharm=0.5, freqoffset=0.2, amp=0.23|
        var minfreq=20, maxfreq=5000;
        Blip.ar(
            freqoffset.linexp(0.0,1.0,minfreq,maxfreq) + freq.linexp(0.0,1.0,minfreq,maxfreq) + [0, - 1], 
            numharm.linexp(0.0,1.0,1,500) - [1, 0],
            mul: amp,
            add: 0.0
        ).tanh;
    });

    Ndef(\blip)[1] = \filter -> {|in, winsize=0.25, pitch=0.5, pd=0.01, td=0.01|  
        PitchShift.ar(in, winsize, 1-pitch, pd, td)
    };

    Ndef(\blip)[2] = \filter -> {|in, delay=0.1, decay=0.1|  
        AllpassC.ar(in, 1.0, delay.exprange(0.001, 5.0).lag, decay.exprange(0.01, 10.0));
    };

    // Ndef(\blip)[2] = \filter -> {|in, gfreq=0.10, gdur=0.1|  
    //     GrainIn.ar(2, Dust.kr(gfreq.range(0.01,10.0)), 0.001+(1-gdur), in);
    // };

    Ndef(\blip)[2] = \filter -> {|in|  
        AllpassC.ar(in, 1.0, delay.linexp(0.001, 5.0), decay.linexp(0.01, 10.0));
    };

    Ndef(\blip)[1000] = \filter -> {|in| Limiter.ar(in)};

    // LFO
    Ndef(\lfo1, {|f=0.5|
        LFSaw.kr(/* LFNoise2.kr(f).range(0.99,1.01) * */f.linexp(0.0,1.0, 0.1, 100.0) * Ndef(\lfo1).kr.lag).range(0.0,1.0)}
    );

    // Make copies of the lfo
    Ndef(\lfo1).copy(\lfo2).set(\f, 5.5);
    Ndef(\lfo1).copy(\lfo3).set(\f, 0.5);
    Ndef(\lfo1).copy(\lfo4).set(\f, 0.15);

    // Reverse lfo
    Ndef(\rlfo1, {1-Ndef(\lfo1).kr.lag});

    // Slow LFO
    Ndef(\slowlfo1, {|f=0.1| LFTri.kr(f.linexp(0.0,1.0,0.00001,1.0)).range(0.0,1.0)});

    // Map lfos in a feedback network
    Ndef(\lfo1).map(\f, Ndef(\lfo4));
    Ndef(\lfo2).map(\f, Ndef(\lfo3));
    Ndef(\lfo3).map(\f, Ndef(\lfo1));

    // Map lfos to synth parameters
    Ndef(\blip).map(
        \freq, Ndef(\lfo2), 
        \numharm, Ndef(\lfo3), 
        \pitch, Ndef(\lfo1), 
        \pd, Ndef(\lfo3), 
        \td, Ndef(\lfo4), 
        \gdur, Ndef(\lfo1),
        \gfreq, Ndef(\lfo2)
    );

    // Set freq offset
    Ndef(\blip).set(\freqoffset, 0.5);

    Ndef(\blip).play(group:g.src1.g, addAction: \addToHead);

    g.src1.c.map(6, Ndef(\lfo1), 7, Ndef(\lfo4));

    g.verb.c.map(1, nil, 8, nil);
    // g.verb.c.map(1, Ndef(\rlfo1), 8, Ndef(\slowlfo1));
)
g.verb.c.gui


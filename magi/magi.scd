/*

magi.scd
2019-03-31
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/

/*

PLAN
- CTK
- Random bufferafspilning

*/

(
    var buffer, group;

    f = CtkFx.new;

    ~score = CtkScore.new;
    group = CtkGroup.new( 0.0, addAction: \addToHead, target: 1).addTo( ~score );

    ~lfo1 = CtkControl.lfo(LFNoise2, 5, 0.0, 1.0);
    ~lfo2 = CtkControl.lfo(LFNoise1, 0.5, 0.0, 1.0);

    ~lfopar = CtkControl.lfo(LFPar, 0.5, 0.0, 1.0);
    ~lfosaw = CtkControl.lfo(LFSaw, 0.5, 0.0, 1.0);

    buffer = CtkBuffer.playbuf("/Users/madskjeldgaard/Dropbox/scripts/sc/magi/magi1/Lyde\ fra\ Rasmus/MAGI3.wav",  
        startFrame: 0,  
        numFrames: nil,  
        server: nil,  
        channels: nil
    ).addTo(~score);
    
    // BUFFER NOTE
    ~bufnote = {|time=0.0, dur=12, lfo|
        var thisnote= ~ctkSynths[\bufplayer2]
        .note( time, dur, addAction: \head, target: group )
        .dur_( dur )
        .loop_( 1 )
        .atk_( 0.05 )
        .sus_( 0.95 )
        .rel_( 0.05 )
        .curve_( 1 )
        .start_(0)
        .rate_( lfo ?? 1)
        .buffer_( buffer )
        .amp_(0.5)
        .out_( 0 );

        ~score.add( thisnote );

    };

    ~bufnote.(time: 0.0, dur: 128, lfo: ~lfosaw);

    // Reverb
    ~score.add(
        f.greyhole(time: 0.0, dur: nil, param1: ~lfo1, param2: ~lfo2, param3: ~lfopar, wet: ~lfo1, group: group)
    );

    // Spectral fx 1 
    ~score.add(
        f.enhance(time: 0.0, dur: nil, param1: ~lfo1, param2: ~lfosaw, param3: ~lfopar, wet: 1, group: group)
    );

    
    // FrequencyShifter
    // ~score.add(
    //     f.freqshift(time: 0.0, dur: nil, param1: ~lfo1, param2: ~lfosaw, param3: ~lfopar, wet: 1, group: group)
    // );

    // Spectral fx 2 
    ~score.add(
        f.diffuse(time: 0.0, dur: nil, param1: ~lfo1, param2: ~lfosaw, param3: ~lfo2, wet: 1, group: group)
    );

    // Spectral fx 3 
    ~score.add(
        f.comb(time: 0.0, dur: nil, param1: ~lfo1, param2: ~lfo2, param3: ~lfopar, wet: ~lfopar, group: group)
    );


    // TEKSTUR
    // Warp
    // Bufferplayer

    // GRAINS

    // FX???
    
//			fxnote = { |param1=0.5, param2=0.5, param3=0.5, wet=0.75|
//				[
//					f.diffuse(0, dur, group, param1, param2, param3, wet, 0),
//					f.comb(0, dur, group, param1, param2, param3, wet, 0),
//					f.spectraldelay(0, dur, group, param1, param2, param3, wet, 0),
//					f.pitchshift(0, dur, group, param1, param2, param3, wet, 0)
//					// f.warpin(0, dur, group, param1, param2, param3, wet, 0)
//				].wchoose([0.3,0.1,0.5,0.2].normalizeSum)
//			};


~score.play(s);
)
( 
    ~score.write(path: outputfile.standardizePath, duration: 20, // defaults to 'nil' which is the length of the score 
        sampleRate: 96000, headerFormat: "WAV", 
        sampleFormat: "int32");

)
( 
    z = Pbind(
        \instrument, \saw, 
        \atk, Pwhite(), 
        \rel, 1-Pkey(\atk), 
        \degree, Pwhite(( -7),12) + [0, 2, 4], 
        \dur, Pwhite(0.1,4.0, inf)).asScore(32);

)

z.play

// create a Buffer object for adding to the Score
b = Buffer.new;

// for NRT rendering, the buffer messages must be added to the Score
z.add([0, b.allocReadMsg("sounds/a11wlk01-44_1.aiff")]);


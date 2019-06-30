s.boot;

b = BufFiles(s, "/Users/madskjeldgaard/scripts/sc/_live/algorave-odense/snd/jaap");

(

~numChans = 2;

Ndef(\bufplayer, {|buffer, rate=1, trig=1, start=0, loop=1, pan=0|
    var buf = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * rate, trig, BufFrames.kr(buffer) * start, loop, doneAction:0);

    PanAz.ar(~numChans, buf, pan.linlin(0.0,1.0, -1.0,1.0) );

    /* Pan2.ar(buf, pan.linlin(0.0,1.0, -1.0,1.0) ); */
});

~numChans.do{|i| 

    var newrate = 1 - ((i+1)/100);
    var newname = (\buf ++ i).asSymbol;

    Ndef(\bufplayer)
        .copy(newname)
        .set(
            \buffer, b,
            \rate, newrate, 
            \start, i / 1000,
            \pan, 0.5, // 1/i
        )
    };

)

Ndef(\buf1).edit

NdefMixer(s)

Ndef(\buf0).fadeTime = 4;
Ndef(\buf0)[1] = \filter -> {|in, freqshift=1| FreqShift.ar(in, freq: [freqshift, freqshift*1.01], phase: 0)};

Ndef(\lfo1, {|freq=0.001| 0.15*SinOsc.kr(freq)});
Ndef(\lfo2, {|freq=0.014| LFSaw.kr(Ndef(\lfo2) * Ndef(\lfo1) * freq).max(0) });


Ndef(\buf0).map(\windowSize, Ndef(\lfo1));
Ndef(\buf1).map(\pitch, Ndef(\lfo1));
Ndef(\buf0).map(\wet1, Ndef(\lfo2));
Ndef(\buf1).map(\pd, Ndef(\lfo2));

Ndef(\out).play;

Ndef(\out)[0] = { Splay.ar([Ndef(\buf0), Ndef(\buf1)], Ndef(\lfo2).lag ); };

(
Ndef(\out)[1] = \filter -> {|in| JPverb.ar(in, t60: 1,    damp: 0, size: 1, 
    earlyDiff: 0.707, modDepth: 0.1, modFreq: 2, 
    lowcut: 500, highcut: 2000)};

)

(
Ndef(\buf0)[2] = \filter -> {|in, windowSize=0.25, pitch=2, pd=0.1|  
    PitchShift.ar(in: in, windowSize: windowSize, pitchRatio: LFSaw.kr(0.01,
        pitch, 0.25), pitchDispersion: pd, timeDispersion: 0.1)
};
)

Ndef(\buf1).fadeTime = 4;

(
Ndef(\buf1)[1] = \filter -> {|in, windowSize=0.25, pitch=2, pd=0.1|  
    PitchShift.ar(in: in, windowSize: windowSize, pitchRatio: LFSaw.kr(0.01,
        pitch, 0.25), pitchDispersion: pd, timeDispersion: 0.1)
};
)

Ndef(\warp, {|buffer, rate=1, grain=0.55, pitch=1.5, overlaps=16, rand=0.1|
    Warp1.ar(2, bufnum: buffer, pointer: LFSaw.kr(BufRateScale.kr(buffer)*rate),
    freqScale:  pitch, windowSize: grain, envbufnum: -1, overlaps: overlaps,
    windowRandRatio: rand, interp: 4)
});

/* Ndef(\warp).play; */
Ndef(\warp).set(\buffer, b, \rate, 32.5, \grain, 0.193, \pitch, 1.5);

Ndef(\warp).play;

5.do{|i| Ndef(\warp).copy(\warp ++ i) };
5.do{|i| Ndef(\warp++i).play};

s.plotTree;

5.do{|i| Ndef(\warp ++ i.asSymbol).set(\buffer, b, \pitch, (1+i)/3, \rate, (1+i)/10) };
5.do{|i| Ndef(\warp ++ i.asSymbol).play};
5.do{|i| Ndef(\warp ++ i.asSymbol).edit};

Ndef(\warp).copy(\warp1);
Ndef(\warp1).play





\warp ++ 1.asSymbol

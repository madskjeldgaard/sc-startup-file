s.options.memSize = 1 * (8192 * 128);
s.reboot;

s.record;

b = BufFolders(s, "/Users/madskjeldgaard/scripts/sc/_live/algorave-odense/snd");

(
~bufferplay1.set(\buffer, b[\clusters][1]);
~bufferplay1 = {|r=1.0, buffer, trig=1, start=0, l=1, freq=0.5, grain=0.5, pan=0| 
    var sig = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * r, trig, start * BufFrames.kr(buffer), l, doneAction:0);
    /* var sig = Warp1.ar(1, bufnum: buffer, pointer: LFSaw.kr(r), freqScale: freq, windowSize: grain, envbufnum: -1, overlaps: 16, windowRandRatio: 0.01, interp: 4); */

    Pan2.ar(sig);
};
)

(

    ~lfo1 = {|f=0.01| SinOsc.kr(f)};

    ~lfo2 = {|f=1| SinOsc.kr(LFNoise2.kr(f))};

    ~lfo3 = {|f=1| LFPar.kr(~lfo1.kr * ~lfo2.kr)};

    ~ratelfo = { ((~lfo3.kr + ~lfo2.kr + ~lfo1.kr)/8)  + 0.25 };

    ~bufferplay1.map(\r, ~ratelfo);

)

(

    ~bufferplay1.set(\wet1, 0.8);
    ~bufferplay1[1] = \filter -> {|in| 

}
)

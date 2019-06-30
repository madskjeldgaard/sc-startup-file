b = Buffer.read(s, "/Users/madskjeldgaard/scripts/sc/_sessions/SC_180916_161721.wav");

p = ProxySpace.push(s);

p.fadeTime = 12;

s.record;

~texture.play;
~texture.set(\buffer, b);
~texture.fadeTime=8;
(
~texture[0] = {|r=1.25, buffer, trig=1, start=0.5, l=1, pan=0| 
    var sig = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * r, trig, start * BufFrames.kr(buffer), l, doneAction:0);

    sig*0.5;
    /* Pan2.ar(sig); */
}
)

(
~lfcub1 = {|f=0.001| LFCub.kr(f)};
~lfcub2 = {|f=0.02| LFPar.kr(f)};
)
~lfcub2.map(\f, ~m2);

~texture.set(\wet1, 0.5, \wet2, 0.5);
~texture.map(\f,~lfcub1, \wet1, ~lfcub2);
(
~texture[1] = \filter -> {|in, f=0.01| 
        FreqShift.ar(in, freq: f, phase: 0)
};

)
(
// MODS
~m1 = {MouseX.kr(0.01) };
~m2 = {MouseY.kr(0.01311)};
~lfsaw1 = {|f=0.0311| LFSaw.kr(f)};
~lfsaw2 = {|f=0.02| LFCub.kr(f)};
~lfsaw3 = {|f=0.003| LFNoise2.kr(f)};
~lfsaw4 = {|f=0.004| LFPar.kr(f)};
~sumsaw5 = {~lfsaw1 + ~lfsaw2 + ~lfsaw3 + ~lfsaw4};  
)
~lfsaw1.map(\f, ~m1);

~texture.map(\g, ~lfsaw1, \p, ~sumsaw5, \pd, ~lfsaw3, \td, ~lfsaw4);
(
~texture[2] = \filter -> {|in, g=0.25, p=0.5, pd=0.1, td=0.01| 
    PitchShift.ar(in: in, windowSize: g, pitchRatio: p, pitchDispersion: pd,
        timeDispersion: td)
};

)

~lfnoise1 = {|f=1| LFNoise2.kr(f)};

~texture.set(\wet3, 0.5);
~texture.map(\wet3, ~lfsaw3, \g2, ~lfcub1, \pd2, ~lfcub2, \td2, ~lfnoise1);
(
~texture[3] = \filter -> {|in, g2=0.25, p2=0.75, pd2=0.01, td2=0.0161| 
    PitchShift.ar(in: in, windowSize: g2, pitchRatio: p2 * 2, pitchDispersion: pd2, timeDispersion: td2)
};
)

~delnoise = { (~lfnoise1.kr.range(1,4) ) };

~texture.map(\del, ~delnoise, \wet4, ~lfcub1);

~texture.set(\wet4, 0.25);

~texture[4] = \filter -> {|in, del=1| CombC.ar(in: in, maxdelaytime: 4, delaytime: del , decaytime:1)};
~delnoise2 = { (~lfnoise1.kr.range(1,8) ) };

~texture.map(\del2, ~delnoise2, \wet5, ~lfsaw3);
~texture[5] = \filter -> {|in, del2=1| CombC.ar(in: in, maxdelaytime: 8, delaytime: del2, decaytime:2)};

~texture.map(\wet6, ~lfcub2);
(
~texture[6] = \filter -> {|in, g3=0.25, p3=0.75, pd3=0.01, td3=0.0161| 
    PitchShift.ar(in: in, windowSize: g3, pitchRatio: p3 * 2, pitchDispersion: pd3, timeDispersion: td3)
};
)

(
~texture[7] = \filter -> {|in, f=0.1| 
        FreqShift.ar(in, freq: [f, f*1.01], phase: [2pi, 1pi])
};

)
s.meter;

s.record;

(
~texture[8] = \filter -> {|in, g4=0.5, p4=1.75, pd3=0.01, td3=0.0161| 
    PitchShift.ar(in: in, windowSize: ~lfsaw3 * g4, pitchRatio: p4 * 3, pitchDispersion:
        ~lfsaw1 * pd3, timeDispersion: LFNoise1.kr(1) / 10)
};
)

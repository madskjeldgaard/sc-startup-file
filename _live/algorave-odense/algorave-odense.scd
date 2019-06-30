(
s.options.memSize = 1 * (8192 * 128);
s.reboot;

s.waitForBoot{ 
    /* b = BufFolders(s, "/Users/madskjeldgaard/scripts/sc/_live/algorave-odense/snd"); */
}
)

b = Buffer.read(s, "/Users/madskjeldgaard/Desktop/sky-tear.wav");

p = ProxySpace.push(s);
p.fadeTime = 10;

s.meter;

s.record;

// Basic

~buf1.play;

~buf1.set(\buffer, b);

b[\klang][0].play;
~buf1.set(\r, (0.5));

~g = {|f=1| Dust.kr(f)};
~g[1] = \set -> Pbind(\dur, 4, \f, Pseq([0.25, 0.1, 3],inf));

~g.scope;

~env = {|a=0.9,r=0.1, l=1, c=10, g=1, dur=4| 0.0 + EnvGen.kr(Env.perc(a,r, l, c), gate: ~g, timeScale: dur)};

~env[1] = \set -> Pbind(\dur, Pseq([10,2,5,1],inf), \a, Pseq([0.9, 0.1, 0.74],inf), \r, Pkey(\a)/10);

~env2 = {|a=0.1,r=0.9, l=1, c=(-10), g=1, dur=7| EnvGen.kr(Env.perc(a,r, l, c), gate: ~g, timeScale: dur)};
~env2[1] = \set -> Pbind(\dur, Pseq([1, 5, 12],inf), \a, Pseq([0.9, 0.1, 0.74],inf), \r, 0.1);

~noisenorm1 = {|f=1, scale=0.25| scale * LFNoise1.kr(f)};

~buf1.map(\td, ~normnoise1, \td2, ~normnoise1);

~env2.scope;

s.record;

~ratewobbler.map(\f, ~env);
~ratewobbler.set(\f, 10);

(
~ratewobbler = {|f=1.101, a=2.13, m=3.03| 
    0.1 + (~env2.kr.lag * LFPar.kr(f,0,m,a) + LFCub.kr(f,0,m,a) + SinOsc.kr(f,0, m,a));
};

)

~ratewobbler.scope;

~buf1.map(\r, ~ratewobbler);

~buf1.set(\r, (-1));

~buf1.addChild(\xset -> Pbind(\dur, 16, \r, Pseq([(-2), 1, (-0.1), 0.521],inf)));

(

~buf1.fadeTime = 2;

~buf1[0] = {|r=3.25, buffer, trig=1, start=0, l=1, freq=0.5, grain=0.5, pan=0| 
    var sig = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * r, trig, start * BufFrames.kr(buffer), l, doneAction:0);
    /* var sig = Warp1.ar(1, bufnum: buffer, pointer: LFSaw.kr(r), freqScale: freq, windowSize: grain, envbufnum: -1, overlaps: 16, windowRandRatio: 0.01, interp: 4); */

    ~env.kr * sig;
};

)

// Slot 1: Filter, pitch shift
~wet1 = {0.5};
~buf1.map(\wet1, ~wet1);

(
~buf1[1] = \filter -> {|in, grainsize=0.25, pitch=0.5, pd=0.01, td=0.01| 
    PitchShift.ar(in: in, windowSize: grainsize, pitchRatio: pitch, pitchDispersion: pd, timeDispersion: td)
}
)

~buf1.removeAt(1, 2); // Remove it

// Slot 1: Modulation and mapping
(
~mod1.fadeTime = 2;
~mod1 = {|f=0.002| SinOsc.kr(f).clip(0.0,1.0)};

~revmod1 = { 1/~mod1.kr };
)

(
~buf1.map(\wet1, ~mod1);
~buf1.map(\grainsize, ~revmod1);
)

(
~mod2.fadeTime = 2;
~mod2[0] = {|f=0.002| (~revmod1.kr * LFCub.kr(f)).clip(0.0,1.0)};

~revmod2 = { 1/~mod2.kr };

)

~mod1[1] = \xset -> Pbind(\dur, Pwrand((1..4), [0.25, 0.75, 0.125, 0.125].normalizeSum), \f, Pseq([1,7, 13, 22],inf) / 1000).trace;

~mod2[1] = \xset -> Pbind(\dur, Pwrand((1..4), [0.25, 0.75, 0.125, 0.125].normalizeSum), \f, Pseq([1,7, 13, 22].pyramid,inf) / 918).trace; 

(
~buf1.map(\pd, ~mod2);
~buf1.map(\td, ~revmod2);
~buf1.map(\pitch, ~revmod2);
)

// Slot 2: Filter, FREQUENCY SHIFT 
~wet2 = {0.25};
~buf1.map(\wet2, ~env2);

(
~buf1[2] = \filter -> {|in, f=0.1| 
    FreqShift.ar(in, freq: [f, f * 1.01], phase: [0, 2pi])
}
)

~buf1.removeAt(2, 2); // Remove it

// Slot 2: Modulation and mapping
(
~mod3.fadeTime = 2;
~mod3[0] = {|f=0.162, scale=1| 
    LFSaw.kr(f)
};

~revmod3 = { 0.125 * ( 1/~mod3.kr) };

~mod3prime = {~mod3.kr * 4};
)

~buf1.map(\f, ~mod3);
~buf1.map(\wet2, ~mod3);

~mod3[1] = \xset -> Pbind(\dur, 8, \f, Pstutter(3, Pseq((1..6),inf))/939);


// Slot 3: Filter, pitch shift
~buf1.map(\wet1, 0.6);

(
~buf1[3] = \filter -> {|in, grainsize2=0.25, pitch2=1.5, pd2=0.01, td2=0.02| 
    PitchShift.ar(in: in, windowSize: grainsize2, pitchRatio: pitch2,
        pitchDispersion: pd2 * ~g.kr.lag(0.1), timeDispersion: td2)
}
)

~buf1.removeAt(1, 2); // Remove it

// Slot 3: Modulation and mapping
(
~mod4.fadeTime = 2;
~mod4 = {|f=0.02| LFCub.kr(f) * LFPar.kr(f) * SinOsc.kr(f).clip(0.0,1.0)};

~revmod4 = { 0.001 + (LFSaw.kr(0.00123486) * (1/~mod4.kr)).lag(0.0125) };

~grmod4 = { 0.25 + (LFPar.kr(0.00001) + LFSaw.kr(0.0123486) * (1/~mod4.kr)) };


~pdmod4 = {LFNoise2.kr(0.001)};
~tdmod4 = {~pdmod4.kr.lag};

)
~pdmod4.scope;
(
~buf1.map(\wet3, ~env2);
~buf1.map(\grainsize2, ~grmod4);
~buf1.map(\pd2, ~env2); 
~buf1.map(\td2, ~tdmod4); 

)
~mod4[1] = \xset -> Pbind(\dur, Pwrand((1..10), [0.25, 0.75, 0.125, 0.125].normalizeSum), \f, Pseq([1,7, 13, 22],inf) / 1000).trace;

(
// PITCH MOD
~pitchmod1 = {|f=0.01, min=0.25, scale=1.91| ~env.kr.lag * LFNoise1.kr(f,scale,min)};
~pitchmod2 = {|f=0.051, min=0.1625, scale=1| ~env2.kr.lag * LFNoise1.kr(f,scale,min).lag(0.01)};

~buf1.map(\pitch, ~pitchmod1, \pitch2, ~pitchmod2);
)

~buf1.set(\wet1, 1, \wet2, 1, \wet3, 1);

(
~buf1[4] = \filter -> {|in| 

};
)

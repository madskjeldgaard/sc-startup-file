(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
//Record
//s.record;
)

~p1[0] = Pbind(
        \instrument, \unisonSamplePlayer2_vox3, 
        \buffer, Pseq(o["reflex"],inf), 
        \amp, 0.3,
        \rate, 1.33 * Pseq([0.5, 0.75, 1.0],inf), 
        \pitchenv, Pwrand([1,0], [0.1,0.9], repeats: inf),
        \filterenv,1,
        \cutoff, 500, 
        \loOrHi,1,
        \stretch, Pstutter(3, Pseq([1,2,0.25, 0.125],inf)),
        \dur, Pseq([0.5, 1/3, 1/9, Rest(1), 2, 1/4, 7], inf),
        \loop, 0,
        \atk, Pwrand([0,1], [0.8, 0.2], repeats: inf), 
        \rel, 1.0 , 
        \envcurve, \exp,
        \out, 0
    );

~p1.play(fadeTime:2);

~p2[0] = Pbindf(~p1.source, 
        \buffer, o["fbatmos"][0],
        \cutoff, 1500, 
        \rate, Pkey(\rate) * 4,
        \loOrHi, 1,
        \stretch, Pkey(\stretch) * 1.5,
        \atk, Pkey(\stretch) * Pkey(\dur), 
        \rel, Pkey(\atk)
    );
        
(
~p2[1] = \filter -> {|in| 
    (in + FreqShift.ar(in, freq: [68, 99,111,122] ).sum ) / 5
}

)
~s = {SinOsc.kr(0.001)};

~p3[0] = Pbind(
        \instrument, \phaseSyncSamplePlayer2_vox3, 
        \buffer, o["desertloops"][0], 
        \amp, 0.1,
        \cutoff, 300,
        \filterenv,Pseq([0,1,1,0,0,0],inf),
        \loOrHi,1,
        \rate, Pseq([0.25,0.5, 0.25, 0.3],inf), 
        \pitchenv, Pwrand([0,1], [0.9, 0.1], repeats: inf),
        \end, Pwhite(0.75, 0.85),
        \start, Pkey(\end) - 0.05,
        \dur, Pkrlive(~s) * 4 * Pseq([2, 4, 6], inf),
        \loop, 1,
        \atk, Pkey(\dur), 
        \rel, Pkey(\dur), 
        \out, 0
    );

~p3.play(fadeTime:8);
(
~p4[0] = {
    arg basefreq=68, dt=1.05, amp=0.1;

    LFSaw.kr(freq: ~s, iphase: 0, mul: 1, add: 0).linlin(-1,1,1,1.25) *
    SinOsc.ar(freq: [1,dt] * basefreq.lag(1), phase: 0, mul:
    1).sum!2 * amp; 
};
~p4[1] =  \xset -> Pbind(\basefreq, Pseq([111,222,333],inf),\amp,0.025, \dur, 5) ;
~p4.mold(2)
)


~p1[0] = Pbind(
        \instrument, \loopingSamplePlayer2, 
        \buffer, Pseq(o["ghost"],inf), 
        \amp, 0.3,
        \rate, [0.5, 1.0], 
        \dur, 8,
        \loop, 1,
        \atk, 0 * Pkey(\dur), 
        \rel, 0 * Pkey(\dur), 
        \out, 0
    );

~p1.play(fadeTime:8);

~p2[0] = Pbind(
    \instrument, \oneShotSamplePlayer2, 
    \buffer, Pxrand(o["zeng"],inf), 
    \amp, 1.5,
    \rate, Pstutter(3, Pseq([0.5, 1, 0.25],inf)), 
    \dur, Pseq([4,1,3,2,5], inf),
    \loOrHi,1,
    \cutoff, 500,
    \loop, 0,
    \atk, 0 * Pkey(\dur), 
    \rel, Pkey(\dur)/2, 
    \out, 0
);
(
~p2[1] = \filter -> {|in| var i = in + FreqShift.ar(in, freq: [88, 111, 222,
    333, 444], phase: 0).sum;
    PitchShift.ar(in: i, windowSize: 0.7, pitchRatio: 2.25, pitchDispersion: 0.01,
        timeDispersion: 0.1)
}

)

~p2.play(fadeTime:8);

~p3[0] = Pbind(
        \instrument, \oneShotSamplePlayer2, 
        \buffer, Pseq(o["fbatmos"],inf), 
        \amp, 0.5,
        \rate, 1.0, 
        \stretch, 2,
        \dur, Pseq([0.5, 1/3, 1/4, 7], inf),
        \loop, 0,
        \atk, 0 * Pkey(\dur), 
        \rel, 1.0 , 
        \envcurve, \exp,
        \out, 0
    );

~p3.play(fadeTime:8);



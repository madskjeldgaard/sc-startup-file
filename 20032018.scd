(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
v.clock.tempo = 1;
// Activate limiter
//StageLimiter.activate;
//Record
//s.record;
)

(
~fx = {|in| var i = In.ar(in); 
    JPverb.ar(i, t60: 1,    damp: 0, size: 1, 
    earlyDiff: 0.707, modDepth: 0.1, modFreq: 2, 
    lowcut: 500, highcut: 2000)};
~fx.play;
)

~p4[0] = Pbind(
    \instrument, \oneShotSamplePlayer2, 
    \buffer, Pseq(o["handling"],inf), 
    \amp, 0.3,
    \rate, 1.0, 
    \dur, Pseq([8, 12, 16], inf),
    \loop, 1,
    \atk, 0 * Pkey(\dur), 
    \send, 0.5,
    \effectBus, ~fx,
    \rel, 0*Pkey(\dur), 
    \out, 0
);

~p4.play(fadeTime:8);




~p1[0] = Pbind(
        \instrument, \oneShotSamplePlayer2, 
        \buffer, Pseq(o["handling"],inf), 
        \amp, 0.6,
        \cutoff, 500,
        \loOrHi,1,
        \rate, Pseq([1.0, -1.0, 0.5],inf), 
        \stretch, Pseq((1..3),inf),
        \dur, 10*Pseq([0.5, 1/3, 1/4, 7], inf),
        \loop, 0,
        \atk, Pkey(\dur), 
        \rel, 1, 
        \envcurve, \exp,
        \out, 0
    );
(
~p1[1] = \filter -> {|in| var x = ~p2 + ~p3+ in + PitchShift.ar(in: in, 
        windowSize: 0.2, pitchRatio: LFNoise2.kr(5).range(1, 2) , pitchDispersion: 0.1, timeDispersion:
        0.01)/2;

        x + JPverb.ar(x, t60: 1,    damp: 0, size: 2, 
            earlyDiff: 0.707, modDepth: 0.1, modFreq: 2, 
            lowcut: 500, highcut: 2000);
    };
)
~p1.play(fadeTime:8);
s.meter;

~s = {SinOsc.ar(LFSaw.kr(0.01).linlin(-1,1,0.5,3) * [68, 72, 88]).sum.wrap(0.11)/ 20 !2};
~s2 = {SinOsc.ar(50)/10!2};
~s2.play;

~s.fadeTime;
~s.play;

~p2[0] = Pbind(
        \instrument, Pseq([\unisonSamplePlayer2_vox3,
            \shimmeringSamplePlayer2_vox3,
            \phaseSyncSamplePlayer2_vox3],inf), 
        \buffer, Pxrand(o["fbsc"],inf), 
        \amp, 0.13,
        \rate, Pseq([0.5, 0.25, 1.0],inf), 
        \detune, Pkey(\rate)/10,
        \stretch, Pwhite(1,4,inf),
        \dur, Pseq([0.5, 1/3, 1/4, 7], inf),
        \loop, 1,
        \cutoff, 500,
        \loOrHi,1,
        \atk, 0 * Pkey(\dur), 
        \rel, Pkey(\dur)/8, 
        \envcurve, \exp,
        \out, 0
    );

~p2.stop;
o.keys


~p3[0] = Pbind(
        \instrument, \oneShotSamplePlayer2, 
        \buffer, Pseq(o["percspask"],inf), 
        \amp, 0.3,
        \rate, Pseq([0.5, 0.3, 0.25],inf), 
        \stretch, Pseq((0.5, 1.0 .. 3),inf),
        \dur, Pseq([0.5, 1/3, 1/4, 7], inf),
        \loop, 0,
        \atk, 0 * Pkey(\dur), 
        \rel, 1.0 , 
        \envcurve, \exp,
        \out, 0
    );

~p3.play(fadeTime:8);

~p3.fadeTime=8;


~p5[0] = Pbind(
    \instrument, \oneShotSamplePlayer2, 
    \buffer, Pseq(o["handling"],inf), 
    \amp, 0.3,
    \rate, 1.0, 
    \dur, Pseq([8, 12, 16], inf),
    \loop, 1,
    \atk, 0 * Pkey(\dur), 
    \rel, Pkey(\dur) 
);

~p5.play(out: ~output.index, fadeTime:8);

~output.scope;
~output = Bus.audio(s,2);

~output.numChannels

(
~r ={ |dw=1|
    var i = ~output;
    i + (dw*JPverb.ar(i, t60: 1,    damp: 0, size: 3, 
    earlyDiff: 0.707, modDepth: 0.1, modFreq: 2, 
    lowcut: 500, highcut: 2000));

};
~r.get(\dw);
~r.mold(2);
~r.play(out: 0);
)

~output.class;
~r.scope;
~output.scope;

iirghrteqairghrteqairghrteqairghrteqairghrteqairghrteqairghrteqairghrteqairghrteqairghrteqairghrteqairghrteqarirghrteqaghirghrteq
irghrteqa irghrteq aarteq gasfdhjijsdfa


Platform.userExtensionDir



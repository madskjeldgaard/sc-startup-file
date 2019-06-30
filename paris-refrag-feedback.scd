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
s.record;
)

(
// SETUP
~feedbackbus = Bus.audio(s, 2); 

~p1.play(fadeTime:8);
)

// Rundhyl 
~p1[0] = Pmono(
    \fb1, 
    \amp, 1.3,
    //\delaytime, Pseq((0.1, 0.125 .. 0.35),inf),
    \cutoff, Pn(Pseq([1150, 1500, 2000, 1100],inf), inf, key: \cutkey),
    \loOrHi, 0, //Pseq([1,0],inf), //Pgate(Pseq([0, 1, 0, Pseq([1.0]), 0]), inf, \cutkey),
    \freqscale, 0.25 * Pxrand([1,3,2.5, 1.25, 1.75, 0.5,2],inf),
    //\res, Pseq((0.0, 0.05..0.15),inf),
    //\pitchdisp, Pwhite(0.01, 0.05,inf), 
    //\timedisp, Pwhite(0.01, 0.05,inf),
    //\winsize, Pwhite(0.11,0.51,inf),
    \stretch, 1.52, 
    \dur, Pseq([8, 12, 16], inf),
    \out, 0
).trace;

(
    ~p1[1] = \filterIn -> {|in| 
        var sig = in + (FreqShift.ar(in, freq: [111, 222,
        333], phase: 0).sum/4);
        
        sig = sig + WaveLoss.ar(in:sig, drop: LFSaw.kr(freq:
            0.001).linlin(-1,1,20,35), outof: 40, mode: 2);

        sig = BPF.ar(in: sig, freq: LFSaw.kr(freq: 0.01).linlin(-1,1,200,2500), rq: 3);

        sig = DFM1.ar(sig, freq: 40+SinOsc.kr(0.01).linlin(-1,1,50,5000), res: 0.25, inputgain: 1, type:1, noiselevel: 0.0003); 

        sig = sig + FreqShift.ar(sig, freq: 88, phase: 0);

        sig = sig + AllpassC.ar(in: sig, maxdelaytime: 0.2, delaytime: 0.5, decaytime: 1);

        sig/4;
    };


)

~p1.set(\wet1, 0.55);

(
~p2[0] = {arg freq=88, amp=1.59; 
    var sig = SinOsc.ar([freq, freq*1.005, freq*5, freq*5*1.005]).sum * amp;
    sig;
}
)
(
~p3[0] = {arg freq=2555, amp=0.05; 
    var sig = SinOsc.ar([freq, freq*1.005]).sum * amp;
    LFSaw.kr(freq: 0.015).linlin(-1,1,0.1,1.0) * sig;
}
)

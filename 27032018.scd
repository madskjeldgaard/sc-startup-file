~p1[0] = Pmono(
    \fb1, 
    \amp, 1.2,
    \freqscale, Pxrand([1,5,3.5, 1.25, 1.75, 3,2],inf),
    \cutoff, 1000-Pseq([2500, 1500, 3000, 3100],inf),
    \loOrHi,1,
    \timedesp, Pwhite(0.01, 0.15,inf),
    \winsize, Pwhite(0.1,1,inf),
    \stretch, Pwrand((1..5), 0.2!5, repeats: inf),
    \dur, Pseq([8, 12, 16], inf),
    \out, 0
);

(
~p1[1] = \filterIn -> {|in| 

    var sig = in + DFM1.ar(in, freq: 900, res: 0.1, 
        inputgain: 1, type:1, noiselevel: 0.0003);

    sig = sig+AllpassC.ar(in: sig, maxdelaytime: 1.2, delaytime: 0.25, decaytime: 1);

    sig = sig + PitchShift.ar(in: sig, windowSize: 
        0.5, pitchRatio: LFSaw.kr(freq: 0.01).linlin(-1,1, 0.25, 1.0), 
        pitchDispersion: 0,
        timeDispersion: 0.5);
    
sig =  // Waveguide mesh physical models of drum membranes
	sig  + (MembraneHexagon.ar(sig, tension: 0.04, loss: 0.99999)/90);


    sig = sig+AllpassC.ar(in: sig, maxdelaytime: 1.2, delaytime:
        SinOsc.kr(0.1).linlin(-1,1,0.01, 0.25), decaytime: 2);

    sig = sig / 2;

    sig = LFSaw.kr(freq: 0.001, iphase: 0, mul: 1, add: 0).linlin(-1,1,0.25,1) *

   sig = Compander.ar(sig, sig,
        thresh: 0.5,
        slopeBelow: 1,
        slopeAbove: 0.5,
        clampTime:  0.11,
        relaxTime:  0.21
    );

    Pan2.ar(sig, pos: LFSaw.kr(1), level: 1);

};
)


(
~p1[2] = \filterIn -> {|in| 
    var sig = BPF.ar(in, 2500);
    sig = AllpassC.ar(in: sig, maxdelaytime: 0.5, delaytime:
        LFNoise0.kr(0.01).range(0.1, 1), decaytime: 1);
}
)
~p1.play(fadeTime:8);

s.plotTree;

~p1.set(\wet1,0.4);
~p1.set(\wet2,0.3);

(
~p2[0] = {arg freq=2200, amp=0.003, dt=1.1; SinOsc.ar([freq, dt*freq]) * amp};
~p2[1] = \xset -> Pbind(
    \freq, Pseq((2000..2200),inf), 
    \dur, 3,
    \amp, 0.005
    ); 
~p2.mold(2);
)

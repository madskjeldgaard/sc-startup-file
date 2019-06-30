(
~feedbackbus = Bus.audio(s,2);
~someBus = Bus.audio(s,2);

)
(
~p1 = Pmono(
    \fb2, 
    \freqscale, Pwhite(0.25, 0.99,inf),
    \stut, Pstutter(3, Pseq([1,2,3],inf)), 
    \cutoff, 3*Pkey(\stut) * Pseq([500, 1500, 250],inf),
    \winsize, Pseq((0.1, 0.2 .. 0.5),inf),
    \res, Pwhite(0.0, 0.25,inf),
    \slew, Pseq((0.1, 0.2 .. 0.7),inf),
    \loOrHi,0,
    \amp, 0.9,
    \dur,Pkey(\stut)* Pseq([8, 12, 16, 20, 24, 28, 32], inf),
    \out,0
);


~p1.play;

//{var sig = InBus.ar(~someBus.index, 2); sig = sig * LFSaw.kr(freq: 0.5); Out.ar(2, sig);}.play;
)


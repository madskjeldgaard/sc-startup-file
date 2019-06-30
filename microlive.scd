(
~i = 0.24;
~f = 100;
~f1 = ~f + (~f * ~i);
~f2 = ~f + (2 * ~f * ~i);
~f3 = ~f + (2*~f2 * ~i);
~f4 = ~f + (~f3 * ~i);

~d = 1.000 + ~dl;
)
~dl.play;
~dl = {LFCub.kr(0.001).range(0, 0.025)};
~l.play;
~l = {LFCub.kr(freq: ~f/100, iphase: 0, mul: 1.0, add: 0)};
~l2.play;
~l2 = {LFPar.kr(freq: ~f/250, iphase: 0, mul: 1.0, add: 0).range(0.1,4) * ~l};


(
~sine1.play(0,2);
~sine1 = {Pan2.ar(SinOsc.ar(freq: [~f1, ~f1*~d]*1, phase: 0, mul: 0.33), ~l*0.25);};
)
(
~sine2.play(0,2);
~sine2 = {Pan2.ar(SinOsc.ar(freq: [~f3, ~f4*~d]*1, phase: 0, mul: 0.09), ~l);};
)
(
~sine3.play(0,2);
~sine3 = {Pan2.ar(
        DFM1.ar(
            SinOscFB.ar(freq: [~f5, ~f6*~d]*1, feedback: ~l2, mul: 0.002), 
            freq: 1200, res: 0.6, 
            inputgain: 1, type:1, noiselevel: 0.0005), 
    ~l*0.5);};
)

~o = {Array.fill(8, {|i| SinOsc.ar(freq: 440*i, phase: 0, mul: 1) })};


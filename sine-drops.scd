( 
    ~time = 25;

    Ndef(\sine, {|f=0.1, amp=0.2| 
        SinOsc.ar([1.0, 2.0, 3.0] * f.linexp(0.0,1.0,30,400),  phase: 0.0,  mul: [1, 0.5, 0.25] * amp,  add: 0.0).sum}
    );

    Ndef(\env, {|time=4, atk=0.001, rel=0.999, g=1, level=0.10, bias=0.03| 
        EnvGen.kr(Env.perc(atk, rel, 1, ( -10 )), g,  levelScale: level,  levelBias: bias,  timeScale: time,  doneAction: 0) }
    ).set(\time, ~time);

    Ndef(\ampenv, {|time=4, atk=0.001, rel=0.999, g=1, level=0.30, bias=0.0| 
        EnvGen.kr(Env.perc(atk, rel, 1, ( -10 )), g,  levelScale: level,  levelBias: bias,  timeScale: time,  doneAction: 0)
    }).set(\time, ~time);

    Ndef(\sine).map(\f, Ndef(\env), \amp, Ndef(\ampenv));

s.record("~/Desktop/sinedrop.wav")
)

Ndef(\sine).play;

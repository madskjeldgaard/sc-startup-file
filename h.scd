( 
    Ndef(\hej, {|freq=0.5|
        var trig = Impulse.kr(freq) > 0;
        EnvGen.kr(Env.perc,  gate: trig,  levelScale: 1.0,  levelBias: 0.0,  timeScale: 1.0,  doneAction: 0)
    }).scope;
)

Quarks.install("Ctk")

Quarks.gui

Quarks.openFolder

Quarks.install("https://github.com/madskjeldgaard/Particular")

z = MKtl('s', "shanwan_ps3");

z.gui

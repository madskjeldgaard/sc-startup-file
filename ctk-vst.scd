(
    ~score=Score.new; 
    ~synth = CtkSynthDef.new(\vstsynth, {|out=0|
            var sig = Crackle.ar;
            sig = VSTPlugin.ar(sig,  numOut: 1);
            Out.ar(out, sig);
        });

        ~note = ~synth.note(8);

        ~fx = VSTPluginController(~note);

        ~fx.open("FabFilter Pro-R", info: true);

        ~note.addTo(~score); 

        ~score.write()
)

Quarks.install("Ctk")

CtkNote

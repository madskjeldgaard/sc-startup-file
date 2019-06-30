(
// A sort of oop way of writing a synthdef
o = {

    (

    env: {|self, time=1| 
        EnvGen.kr(Env([0, 1.0, 0.0], [time/2, time/2]), doneAction:2);  
    },

    sine: {|self, freq=110| 
        SinOsc.ar(freq)
    },

    init: {|self| 
        SynthDef(\sinetessst, {

            var env = SynthDef.wrap( {|time| self.env(time)});
            var sig = SynthDef.wrap( {|freq| self.sine(freq)} );

            Out.ar(0, sig*env);
        }).add;
    }

    )

};

// create an instance by calling the o objects value method to return the event
// containing the synth parts
i = o.value;

// Create the synth and add it
i.init;

3.do{|i| Synth.new(\sinetessst, [\time, 8*i, \freq, 110*i]); }
)

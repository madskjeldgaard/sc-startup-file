(

/* 
* Mass SynthDef creation using object prototyping, wrapping and events 
*
* This is a neat way of creating a lot of synth defs with few lines of code
* + keeping things modular.
*
*/

o = {

    (
    // Just a simple envelope
    env: {|self, atk=0, rel=1| 
        EnvGen.kr(Env([0, 1.0, 0.0], [atk, rel]), doneAction:2);  
    },

    // A sub event with different oscillator types
    oscillators: (

        sine: {|self, freq| 
            SinOsc.ar(freq)
        },
        
        saw: {|self, freq| 
            Saw.ar(freq)
        },

        tri: {|self, freq| 
            DPW3Tri.ar(freq)
        },

        fm: {|self, freq, ratio=2.1234| 
            SinOsc.ar(freq * SinOsc.ar(freq * ratio) )
        }
    ),

    // Define and create the synthdefs
    // Each synthdef has a name containing the oscillatortype
    init: {|self, basename='_'| 

        self.oscillators.keysValuesDo{|oscillatortype, oscillatorfunc| 
            var name = basename ++ oscillatortype.asSymbol;

            "making a synth named: %".format(name).postln;

            SynthDef(name, {|pan=0|
                var env = SynthDef.wrap({|atk=0, rel=1| self.env(atk, rel)}); 
                var sig = SynthDef.wrap(oscillatorfunc);
                sig = Pan2.ar(sig, pan);
                Out.ar(0, sig*env);
            }).add;
        }
    }
    
    )

};

// create an instance by calling the o objects value method to return the event
// containing the synth parts
i = o.value;
i.init;

// Play three different copies of it
s.waitForBoot{
    Synth.new(\_saw, [\time, 8, \freq, 200]);
    Synth.new(\_sine, [\time, 18, \freq, 100]);
    Synth.new(\_tri, [\time, 9, \freq, 400]);
    Synth.new(\_fm, [\time, 9, \freq, 300, \ratio, 3.125]);
}

)

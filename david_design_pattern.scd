(
var lagTime=0.1;

SynthDef(\s, {|bus, xfade=1.0| 
    var sig = In.ar(bus, 1); 
    sig = FreqShift.ar(sig, 800);
    XOut.ar(bus, xfade, sig)
}, lagTime).add;

SynthDef(\i, {|bus| 
    var sig = Saw.ar(100)*0.5;
    OffsetOut.ar(bus, sig)
}, lagTime).add;

SynthDef(\o, {|bus| 
    var sig = In.ar(bus, 1); 
    ReplaceOut.ar(0, sig)
}).add;

~g = Group.new;

~bus = Bus.audio(s,1);

Synth.head(~g, \i, [\bus, ~bus]);  
Synth.tail(~g, \s, [\bus, ~bus]);  
Synth.tail(~g, \o, [\bus, ~bus]);  

)

s.meter;
s.plotTree;

~b = Array.fill(3, {Bus.audio(s,1)});


~bus.asMap


bench { {SinOsc.ar(110)}.play }

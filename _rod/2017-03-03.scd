s.boot;
s.meter;
(// One day
// A minimalistic, microtonal composition

var aDay = 86400, aFreq = 130.82, aDayInFreqs = p{:(1/aDay)*x, x <-(0..aDay)};// seconds, hz, frequencies

SynthDef.new(\synthForOneDay, {
    arg f, a, amp = 0.75, dur; 
    var s = SinOsc.ar([f, f+a]), e = EnvGen.kr(Env.dadsr(dur), doneAction:2);
    Out.ar(0, s * amp * e) }).add;

Pbind( \instrument, \synthForOneDay, \f, aFreq, \a, aDayInFreqs, \dur, 1.0).play;


)
y = all{:(1/86000)*x, x <-(0..86000)};
y[3].postln;

86000.do{arg i; y[i].postln};

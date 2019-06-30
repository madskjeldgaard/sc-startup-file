(

SynthDef(\crackle, {|freq=0.2, amp=0.5|
    var env = EnvGen.ar(Env([1,0],[0.2]));
    var sig = Crackle.ar(freq,amp);
    Out.ar(0, sig * env);
}).add;

SynthDef(\sine, { |freq=400, amp=0.2, atk=0.1, rel=0.5, pan=0|
    var env, sig;
    env = EnvGen.ar(Env([0, amp, 0], [atk, rel], \sine), doneAction: 2);
    sig = SinOsc.ar(freq, 0, env);
    sig = Pan2.ar(sig, pan);
    OffsetOut.ar(0, sig);
}).add;

)

(

var w, much = 0.02, string, tri;

{
    var trig = Dust.kr(10), layers = 3, freqFrom=0.01, freqTo=0.75;
    Mix.fill(layers, {
        Pan2.ar(
        BufRd.ar(1, b.bufnum,
        SinOsc.ar(TRand.kr(freqFrom, freqTo, trig), 0, 0.5, 0.5)
        * BufFrames.kr(b.bufnum), 0, 4))
    })
}.play;
 
 
w = Window("colourful", Rect(600,700,600,600)).front;

w.drawFunc = { w.background = Color(1, 1.0.rand,1.0.rand,1.0.rand)};

{ while { w.isClosed.not } { w.refresh; rrand(0.05, 0.15).wait; } }.fork(AppClock);

// MADS ER SØD
)

(
b = Buffer.read(s,"/Users/madskjeldgaard/Desktop/ableton/User\ Library/Sounds/EMF/coil/SLUSHICE.WAV");
c = Buffer.read(s, "/Users/madskjeldgaard/Desktop/ableton/User\ Library/Sounds/TEXTURES/feedback/Accidental\ Bach\ +\ Feedback\ mixpre-6.wav");

SynthDef.new(\spreader, {|buffer, rate=2.5209, detune=0.00505, start=0,
    spread=1, out=0| 

    var sig = PlayBuf.ar(1, buffer!2, BufRateScale.kr(buffer) * [rate, rate* (1 + detune) ], 1,
    start, 1, doneAction:0);
    
    sig = Splay.ar(sig);

    Out.ar(out, sig * 0.125);
    }).add;

h = (instrument: \spreader, \buffer:b);
h.play;

)
(
h = (instrument: \spreader, \buffer:b, \detune: 0.009);
h.play;
)
a.play;
s.meter;

(
h = (instrument: \spreader, \buffer:b);
h.play;
)

(instrument: \spreader).play


(
{|buffer, rate=1.5109, detune=0.00905, start=0,
    spread=1, out=0| 

    var sig = Splay.ar(PlayBuf.ar(1,b, BufRateScale.kr(b) * [rate,
        rate + (rate * detune)], 
        1, start, 1, doneAction:0), spread);
        Splay.ar(sig);
}.play;
   
)

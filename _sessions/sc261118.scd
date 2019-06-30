s.boot;

b = BufFiles(s, "/Users/madskjeldgaard/Dropbox/Sounds/_FIELD/metallic\ objects");

Ndef(\player1, {|buffer, rate=1, trig=1, start=0, loop=1, amp=1|
    PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * rate, trig,
        start, loop, doneAction:2);
})

Ndef(\player1).play;

Ndef(\player1).set(\rate, 1)

Ndef(\lfo1, {|f=0.1| 1 + (SinOsc.kr(f) * LFNoise2.kr(f))})

Ndef(\player1).xmap(\rate, Ndef(\lfo1))

(
Ndef(\player1).at(1, 
    \filter -> {|in, win=0.5, shift=3.2, pd=0.1, td=0.5|
    PitchShift.ar(in: in, windowSize: win, pitchRatio: shift, pitchDispersion:
        pd, timeDispersion: td)
} 
);

Ndef(\player1).at(2, 
    \set -> Pbind(\buffer, Pxrand(b, inf), \dur, 8).trace; 
)

)

Ndef(\player1).gui



Ndef(\sawww, {|f=90, w=0.5, a=0.1| VarSaw.ar([ f , f * ( 1.00 - ( w.lag2/100 ))], 0, w.lag, a/2).sum!2})

Ndef(\sawww).play

Ndef(\sawww).mold(2)

Ndef(\e, {|f=1, a=0.01, r=0.99, dur=0.3| EnvGen.kr(Env.perc(a,r, 1, 10), Dust.kr(f), 1, 0, dur)})

Ndef(\sawww) <<>.w Ndef(\e)
Ndef(\sawww) <<>.a Ndef(\e)

NK2.new

NanoKontrol2.new

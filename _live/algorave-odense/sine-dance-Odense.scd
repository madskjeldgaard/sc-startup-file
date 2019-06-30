//
// Sine dance
//
// Odense, Denmark, 6th of October 2018

~ph = {LFNoise2.kr(0.001) * 0.25};
~gdiff = {|gd=0| gd.poll; gd};
~gdiff[1] = \xset -> Pbind(\dur, 16, \gd, Pseq((1..4).pyramid, inf) / 4);

~gdiff.scope;

PanAz

(
~sine1 = {|f=100, diff=1| SinOsc.ar([f, f-(diff + ~gdiff)], ~ph).sum};

~sine2 = {|f=111, diff=2, amp=0.5| SinOsc.ar([f, f-(diff + ~gdiff)], ~ph).sum * amp};

~sine3 = {|f=333, diff=3, amp=0.125| SinOsc.ar([f, f-(diff + ~gdiff)], ~ph).sum * amp};
~sine3[1] = \filter -> {|in, fs=0.1| FreqShift.ar(in, fs)};
~sine3.set(\wet1, 0.5);
)

~sine3.mold(1, 'audio');

~out = {Splay.ar([~sine1, ~sine2, ~sine3],1)};

~out.play
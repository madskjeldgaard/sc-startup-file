(
Ndef('fuck').fadeTime = 0.2;

Ndef('fuck',
	{|f=110, w=0.5|
v = VarSaw.ar([ f , f * LFSaw.kr(0.0001).range(1.0, 1.05)], 0, LocalIn.ar(1, 1.0) * w * [1, rrand(0.9, 1.1)]);

v = v ++ SinOsc.ar(( LFGauss.kr(1) * v ) * f * 0.95,  phase: 0.0,  mul: 1.0,  add: 0.0);
v = PitchShift.ar(v, LFGauss.kr() * 5);
LocalOut.ar(v[0]);
Splay.ar(v);

}).play;
)
(

Ndef('fuck')[100] = \xset -> Pbind(\dur, 0.15, \f, Pwhite(100,200));


)

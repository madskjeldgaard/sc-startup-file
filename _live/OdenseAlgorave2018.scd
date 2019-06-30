// Sine dance
p.fadeTime = 10;

~sine1.mold(4);
~sine1.play;

~gdiff.fadeTime = 12;

~gdiff = {|d=0.5| d*0.25};

~gdiff[1] = \xset -> Pbind(\dur, Pstutter(4, Pseq([16, 12, 8, 4],inf)), \d, Pseq([0.75, 0.5, 0.4, 0.71, 1],inf) + Pn(Pseries(0.0, 0.01, 100), 100) );

~panfreq.fadeTime = 16;
~panfreq = {|f=0.001| f*3};
~panfreq[1] = \xset -> Pbind(\dur,32, \f, Pseq([-1.0, 1.0],inf) * 0.0015);

~sine1 = {|f=110| PanAz.ar(4, SinOsc.ar([f, f- (~gdiff * 1.1)]).sum * 0.1, SinOsc.kr(0)) }

~sine1.stop;

~sine2.play;
~sine2.fadeTime = 16;
~sine2 = {|f=112| PanAz.ar(4, SinOsc.ar([f, f-(~gdiff * 1.251)]).sum * 0.01, SinOsc.kr(~panfreq/10)) }

~sine2.set(\f, 255);

~sine3.stop;

(
~sine3.fadeTime = 16;
~sine3 = {|f=144| PanAz.ar(4, SinOsc.ar([f, f-(2.1572*~gdiff)]).sum * 0.01, SinOsc.kr(~panfreq/11)) }
)

~sine3.play;
~sine3.mold(4);

~sine4.play;

~sine4.stop;

~sine4.fadeTime=10;

~sine4 = {|f=41| SinOsc.ar([f, f-(1.3151572*~gdiff)]).sum!2 * 0.09}



~sine4[1] = \xset -> Pbind(\dur, 32, \f, Pwhite(50.0, 55.0, inf));


~saw1.fadeTime = 16;
~saw1.play;

~saw1.stop;

~saw1 = {|f=122, cutoff=500| PanAz.ar(4, DFM1.ar(Saw.ar(f), cutoff + SinOsc.kr(~panfreq * 10, 0, 100, 100).clip(100.0, 200.0) ) * 0.010, SinOsc.kr(~panfreq/12))}

~saw1.mold(4);
(
~sine5.play;
~sine5.fadeTime = 16;
~sine5 = {|f=375| PanAz.ar(4, SinOsc.ar([f, f-(1.721*~gdiff)]).sum * 0.005, SinOsc.kr(~panfreq/12)) }
)


~sine5.stop;
~sine6.stop;

(
~sine6.play;
~sine6.fadeTime = 16;
~sine6 = {|f=433| PanAz.ar(4, SinOsc.ar([f, f-(1.572*~gdiff)]).sum * 0.005, SinOsc.kr(-1.0 * (~panfreq/2) )) }
)

~sine3.mold(4);

(
~sine7.play;
~sine7.fadeTime = 16;
~sine7 = {|f=777| PanAz.ar(4, SinOsc.ar([f, f-(1.372*~gdiff)]).sum * 0.0015, SinOsc.kr(-1.0 * (~panfreq/2.15) )) }
)

~sine7.mold(4);
~sine7.stop;
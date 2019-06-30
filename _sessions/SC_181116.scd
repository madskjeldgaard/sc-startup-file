//Algoritme til Information
s.boot;
(
play{g=20;y=SawDPW;m=SinOsc.ar([0.01,0.0125],[-4pi,4pi]);HPF.ar(m*Splay.ar(y.ar({|i|m.sum+y.kr(i/g)+exprand(40,1000)}!g),m[0].lag2),y.kr(0.1*m).lag3.exprange(10,2000))};
s.record;
)

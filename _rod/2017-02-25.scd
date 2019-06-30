s.boot;
g = ServerOptionsGui(s);
p = ProxySpace.push(s);
p.fadeTime = 10;
Server.hardFreeAll;

(
~folder = {
    DFM1.ar(Fold.ar(SinOsc.ar([
        91 * SinOsc.kr(0.000001, 0.5).range(1.0, 1.025) ,
        92.75 * SinOsc.kr(0.0000001).range(1.0, 1.025) ]), 
    0.0!2,
    SinOsc.kr(0.00001).range(0.0, 0.4)!2), 
    freq: Lag.kr(Saw.kr(0.0001).range(50, 3000)!2, 0.25), 
    res: LFTri.kr(0.001).range(0.0, 0.5)!2) * 0.85}
)

~folder.play;
~folder.stop;

(
~folder2 = {
    DFM1.ar(Fold.ar(SinOsc.ar([
        45 * SinOsc.kr(0.000001, 0.5).range(1.0, 1.025) ,
        45.75 * SinOsc.kr(0.0000001).range(1.0, 1.025) ]), 
    0.0!2,
    SinOsc.kr(0.00001).range(0.0, 0.4)!2), 
    freq: Lag.kr(Saw.kr(0.0001).range(50, 800)!2, 0.25), 
    res: LFTri.kr(0.001).range(0.0, 0.5)!2) * 0.95}
)

~folder2.play;

(
~folder3 = {
    f = 373.0;
    DFM1.ar(Fold.ar(SinOsc.ar([
        f * SinOsc.kr(0.000001, 0.5).range(1.0, 1.025) ,
        f * SinOsc.kr(0.0000001).range(1.0, 1.025) ]), 
    0.2!2,
    SinOsc.kr(0.00001).range(0.0, 0.7)!2), 
    freq: Lag.kr(Saw.kr(0.0001).range(50, 1000)!2, 0.25), 
    res: LFTri.kr(0.001).range(0.0, 0.5)!2) * 0.45; }
)

~folder4.play;
(
~folder4 = {
    f = 373.0;
    DFM1.ar(Saw.ar([
        f * SinOsc.kr(0.002001, 0.5).range(1.0, 1.025) ,
        f * SinOsc.kr(0.0020001).range(1.0, 1.025) ]), 
    freq: Lag.kr(Saw.kr(0.0001).range(50, 500)!2, 0.25), 
    res: LFTri.kr(0.001).range(0.0, 0.5)!2) * 0.25; }
)

~x = {SinOsc.ar(120)*0.25};
~x.play;
~x.stop;

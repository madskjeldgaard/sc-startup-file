

// Algorithmic singing bowl, 
// infinitely ringing


({ var n = PinkNoise.ar(), f = (0.01, 0.015 ..0.07);
v = LFTri.kr(f.scramble[5..7]).range(0.0001, 0.003);
Splay.ar( MembraneHexagon.ar(n, f.scramble[1..3], mul: v), 
    SinOsc.kr(f.choose))
}.play)

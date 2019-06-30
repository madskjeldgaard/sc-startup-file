5.cubed

z = SinOsc.ar(_);

{ z.(110)!2; }.play;

s.boot

1.for(35, {arg i; i.postln;} )

(
/*** Batch load samples for arrayOfSamples ***/
// Be careful when using samples in eg. grain Ugens: They expect mono
// samples.
~arrayOfSamples = Array.new; 

~folder = PathName.new("path/to/samples");

~folder.entries.do({
  arg path;
  ~arrayOfSamples = ~arrayOfSamples.add(Buffer.read(s, path.fullPath));
});
)
// Test if samples work
~arrayOfSamples[0].play;

({x = LFSaw.kr(0.25).range(_, _); 
f = [140, 180, 220, 550, 330]; a = x.(0.0,0.5)!f.size; 
r = 1!f.size; i = PinkNoise.ar(0.01); k = Klank.ar(`[f, a, r], i, _); 
Splay.ar([k.(1.0) * x.(0,1.1), k.(4.0) * x.(0,0.75), LinXFade2.ar(k.(0.5), k.(1.8), LFTri.kr(0.1001).(-1.0,1.0))], x.(0,1)); 
}.play)

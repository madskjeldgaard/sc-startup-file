s.boot;

p = ProxySpace.push(s)

b = BufFiles.new(s, "/Users/madskjeldgaard/Projekter/User\ Library/Sounds/_FIELD/HANDLING\ NOISE" );

~hn1.asPentes(\bufplayer2, args: [\buffer, b[0]])

~hn1.addPentesModule(\fbgrain1);
~hn1.play;

PentesModules.postModuleList 

~hn1.postParamValues

~hn1.xsetAllRand;

~hn1.set(\buffer, b[2], \rate, 0.15)

(
~e = { |a=0.1, r=0.9, g=1, c=10,dur=1| EnvGen.kr(
    Env.perc(a,r, 1, c), g, 1, 0, dur)
};
)

~e[1] = \xset -> Pbind(\g, 1, \dur, Pxrand((1..10),inf), \a, 0.9, \r, 0.1); 

~hn1.xmap(\wet8, ~e)
~hn1.xmapRand(~e)

~hn1.set(\buffer, b.choose)

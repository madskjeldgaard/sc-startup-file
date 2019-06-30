s.boot;

// This just loads a bunch of files into an array of Buffers
b = BufFiles(s, "/Users/madskjeldgaard/scripts/sc/_live/algorave-odense/snd");

p = ProxySpace.push(s);

~buf1.play; // Play the nodeProxy

// Set source to a PlayBuf
// This works fine...

(
~buf1.fadeTime = 8;

~buf1[0] = {|r=0.25, buffer, trig=1, start=0, l=1, pan=0| 
    PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * r, trig, start, l, doneAction:0);
};

~buf1.set(\buffer, b[2]);
)

// This will give you the 'rate' error
~buf1[1] = \set -> Pbind(\dur, 3, \buffer, Pseq(b, inf), \p, Pfunc({|ev| ev.rate.postln}));

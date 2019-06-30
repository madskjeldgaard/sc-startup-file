/**************************** 
           5.cubed 
*****************************/

(
// Allocate memory
s.options.memSize = 8192 * 64;

// Set sample rate
//s.options.sampleRate= 44100;

// Number of hardware ins / outs
s.options.numOutputBusChannels;
s.options.numInputBusChannels;

// increase this if you are getting drop outs and the message "too many nodes"
s.options.maxNodes = 1024 * 64; 

// Audio meters
s.meter;

// Server visualisation 
s.plotTree;

// ProxySpace setup
//p = ProxySpace.push(s);

// Boot the server 
s.reboot;
)
(

p = ProxySpace.push(s);
p.fadeTime = 2;
p.clear;
)

// Algorithmic singing bowl, 
// infinitely ringing
(~singingBowlInfinitelyRinging = { var n = PinkNoise.ar(), f = (0.01, 0.015 ..0.07);
v = LFTri.kr(f[5..7]).range(0.0001, 0.003);
Splay.ar( MembraneHexagon.ar(n, f[8..11], mul: v), 
    SinOsc.kr(f.choose))
};
~singingBowlInfinitelyRinging.play;
)

// Swarm 
(~swarm = {var f1 = 5.cubed, f2 = f1*1.025, mp=0.95, mfb = 0.75;    
h = HenonC.ar(freq: 5).range(_, _); l = LorenzL.ar(freq: h.(0.1,5.0)).range(_,_); 
DFM1.ar(LinXFade2.ar(SinOscFB.ar(freq: [f1,l.(f1,f2)], feedback: l.(0,mfb)!2, mul: 0.01),
    SinOsc.ar(freq: [f1,l.(f1,f2)], phase: h.(0,mp)!2, mul: 0.01),
    pan: l.((-1.0), 1.0), level: 1), 1000, noiselevel: 0.0010)
};
~swarm.play;
)

// Malformed zen
(~malformedZen = {z = TChoose.kr(Impulse.kr(0.1), [0.25, 0.5, 0.33, 0.4]); x = (LFTri.kr(z) * LFSaw.kr(z)).range(_, _); 
p = x.(0,1); f = all {: (x*5.cubed)+p, x <- (1..5)}; r = f.log10*p; a = f.reverse.frac; 
k = Klank.ar(`[f, a, r], PinkNoise.ar(0.01), _); w = WaveLoss.ar(k.(0.5) * x.(0,1.0), x.(0,20), 40, 2, p*z);
j = Splay.ar([w, k.(2.0) * x.(0,0.75)*z, 
    LinXFade2.ar(k.(0.5), k.(1.0)*w.range(0.25,0.75), LFTri.kr(0.1001).(-1.0,1.0))], x.(0,1));}; 
~malformedZen.play;
)

// Autechre-ey, trance-ey
({
f = all {: x, x <- (80,81..100)};
t = Impulse.kr((1..f.size+1)); i = Impulse.kr(0.25); c = TChoose.kr(_,_);
f = [all {: x, x <- f}, all {: x*2, x <- f}, all {: x*3, x <- f}, all {: x*4, x <- f}];
s = PulseDPW.ar(freq: c.(i, [c.(t,f[0]), c.(t,f[3]),c.(t, f[1]), c.(t, f[2])]),
width: (0.1,0.2..1.0), mul:0.05/f.size);
s = Splay.ar(DFM1.ar(s, freq: Saw.kr(LFNoise0.kr(5).range(0.1,5.0)).range(200, 9000)!f.size, res:0.6));
s = s * EnvGen.kr(Env.perc, gate: t);
s = s * EnvGen.kr(Env([0,1,0.75,0.5, 0.0],[0.05,0.5,1.55, 2.5]), gate: i);
}.play() )


// Xylo 
(
~xylo={f = all {: x*30, x <- (1..20), x.isPrime}; c = LFPar.kr(_) * LFSaw.kr(_); 
d = Dust.kr(_); a = (1..f.size)*c.(0.05, 0.10).range(f.size/1000,f.size/100) ; 
e = EnvGen.kr(Env.perc, gate: d.(a)); n =  LFNoise0.kr(5).range(0, 1);
z = WhiteNoise.ar(); z = ComplexRes.ar(z, freq: f+c.(2.25!2)+n)*e;
Splay.ar(DFM1.ar(z, 2000 * c.(0.75,0.5).range(1,2) , 0.1, 8), c.(0.01, 0.11)) * 1.25;
};
~xylo.play(0,2)
)

// Call from Uganda
(
~call = {var beat=1.525, saw, chords = all {: [x, y, z.squared].midicps*10, x <- (1..12), y <- (3..x), z <-(x..y), y.even, z.odd};
b = Buffer.read(s, "callfromuganda.wav" ); t = Impulse.kr(_); r = r*BufRateScale.kr(b);c = Saw.kr(_); r = 1.0; 
p = PlayBuf.ar(1, b,r*c.(1).range(0.5,1.25),1,0,1); 
d = Lag.kr(Duty.kr(Dseq([10,5,12,8],inf),0, Dseq(chords,inf) ),1);
saw = SawDPW.ar(freq:d, iphase:[0, pi, 2pi]); 
e = EnvGen.kr(Env([0,1,0.75,0], [beat/4, beat/2, beat/4]), gate: Duty.kr(Dseq([1,1,12,8],inf))); 
saw = DFM1.ar(saw, freq: c.(0.4).range(200,1000)* c.(5).range(1,2), res: 0.75*c.(2) ) *0.95; 
Greyhole.ar(Splay.ar([p*0.5,saw*e].sum, c.(1)),  delayTime: 0.125, size: 4, feedback: 0.01, modDepth: 0.3, modFreq: 2 )
};
~call.play



)

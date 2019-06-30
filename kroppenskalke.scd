300.do{" ~,.--... Er der ikk hul ???? `´`".post;};
300.do{"jeg hedder Mads Kjeldgaard ~ + - , _ ~".post;};
300.do{"///// jeg sender live fra Paris )))  ".post;};
(
p = ProxySpace.push(s);
p.fadeTime = 16;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
m = ProxyMixer(p, 12);
s.scope;
)

// Organisation
(
// LFO stuff
20.collect{|i| ~l[i] = {LFTri.kr( (1/128) * (1+i)).range(0.05, 1)};};
15.collect{|i| ~ls[i] = {LFPar.kr( (1/128) * (1+i)).range(0.05, 1)};};
30.collect{|i| ~lf[i] = (1/128) * (1+i)};
)
(
// Frequency
~b = {99 + ~l[0]};
~i = 0.25;
30.collect{|i| ~f[i] = ~b + ((1+i) * ~i * ~b);};
)
(
~d = 1.005;
~dz = {~d-1}; 
~d2 = ~d + {(~dz * LFTri.kr(~lf[1]).range(0,1))};
~d3 = ~d + {((~dz*2) * LFTri.kr(~lf[10]).range(0,1))};
)
(
~k.play(0,2);
~k = { var x = 0, amps, input, ring, pan=LFCub.kr(~lf[2]).range(-0.5,0.5); 
    amps = [~l[1], ~l[3], ~l[5]];
    ring = [~l[0], ~l[2], ~l[4]];
    input = ~l[0]*Dust.ar(2500);
    //input = PinkNoise.ar(0.8);
    z = DynKlank.ar(`[[~f[7], ~f[15], ~f[17]], 
        amps, ring], input,
        freqscale: 1, freqoffset: 0, decayscale: 1.5);
    z = Basinski.ar(in: z, loss:0.25, lossFreq:5.0, noise:0.3);
    z = DFM1.ar(0.04*z, 700, 0, noiselevel: 0.0005)*0.5;
    z = Splay.ar(z,~l[x]);
    ~l[0] * Balance2.ar(z[0], z[1], pan);
};
)
s.meter;
(
~lowend.play(0,2);
~lowend = { var x=0, 
    phaser = LFPar.kr(~lf[x]).range(-8pi, 8pi); 
    z = SinOsc.ar(freq: [~f[x]/2, (~f[x]/2)*~d3], phase: 0.99*phaser, mul: 0.25);
    //z = DFM1.ar(z, 250);
    0.50 * Pan2.ar(z,0);
};
)
(
// SAW !!!!
~lowend.play(0,2);
~lowend = { var x = 0, 
    phaser = LFPar.kr(~lf[x+1]).range(-8pi, 8pi), 
    pan= 0; //LFSaw.kr(~lf[x+2]).range(-1,1); 
    z = SawDPW.ar([~f[x]/2, ((~f[x]/2)*~d3)], phaser);
    z = DFM1.ar(z, 105 * (1+~ls[x]), 0.15*~ls[x], inputgain: 1.25+(1.5*~ls[3+x]), noiselevel: 0.0025);
    0.20*Balance2.ar(z[0], z[1],pan);
};
)
(
~saw.play(0,2);
~saw = { var x = 10, 
    phaser = LFPar.kr(~lf[x+1]).range(-8pi, 8pi), 
    pan=LFTri.kr(~lf[x+2]).range(-1,1); 
    z = SawDPW.ar([~f[x]/2, ((~f[x]/2)*~d2)], phaser);
    z = DFM1.ar(z, 350, 0.05*~l[x], inputgain: 1.25 + ~ls[x], noiselevel: 0.0035);
    ~ls[x+3]*0.03*Balance2.ar(z[0], z[1],pan);
};
)
~saw.free;

(
~saw3.play(0,2);
~saw3 = { var x = 5, 
    phaser = LFPar.kr(~lf[x+1]).range(-8pi, 8pi), 
    pan=LFTri.kr(~lf[x+2]).range(-1,1); 
    z = SawDPW.ar([~f[x], ((~f[x])*~d3)], phaser);
    z = DFM1.ar(z, 350 * (1+~ls[x]), 0.35*~l[x], inputgain: 1.25 + ~ls[x], noiselevel: 0.0035);
    ~ls[x+3]*0.03*Balance2.ar(z[0], z[1],pan);
};
)
~saw.free;

~sin1.free;
(
~sin2.play(0,2);
~sin2 = { var x=3, 
    pan = LFTri.kr(~lf[x]).range(-1,1),phaser = LFPar.kr(~lf[x]).range(-8pi, 8pi); 
    z = SinOsc.ar(freq: [~f[x], ~f[x]*~d2], phase: ~ls[x]*phaser, mul: 0.15);
    //z = DFM1.ar(z, 250);
    ~l[x]*Pan2.ar(z,pan);
};
)
~sin2.free;
(
~sin3.play(0,2);
~sin3 = { var x=12, 
    pan = LFTri.kr(~lf[x]).range(-1,1),phaser = LFPar.kr(~lf[x]).range(-4pi, 4pi); 
    z = SinOsc.ar(freq: [~f[x], ~f[x]*~d3], phase: phaser, mul: 0.15);
    //z = DFM1.ar(z, 250);
    ~l[x+2]*Pan2.ar(z,pan);
};
)

~sin3.free;

(
~sin4.play(0,2);
~sin4 = { var x=10, 
    pan = LFTri.kr(~lf[x]).range(0,1),phaser = LFPar.kr(~lf[x]).range(-4pi, 4pi); 
    z = SinOsc.ar(freq: [~f[x], ~f[x]*~d2], phase: phaser, mul: 0.25);
    //z = DFM1.ar(z, 250);
    Splay.ar(z,pan);
};
)
~sin4.free;
(
~sin5.play(0,2);
~sin5 = { var x=11, 
    pan = LFTri.kr(~lf[x]).range(0,1),phaser = LFPar.kr(~lf[x]).range(-6pi, 6pi); 
    z = SinOsc.ar(freq: [~f[x], ~f[x]*~d3], phase: phaser, mul: 0.25);
    //z = DFM1.ar(z, 250);
    Splay.ar(z,pan);
};
)
~sin4.free;

(
~saw2.play(0,2);
~saw2 = { var x = 12,
    pan = LFTri.kr(~lf[x]).range(0,1), phaser = LFPar.kr(~lf[x]).range(-4pi, 4pi); 
    z = SawDPW.ar([~f[x], ~f[x]*~d2], phaser);
    z = DFM1.ar(z, 450, 0.95*~l[x], noiselevel: 0.0035);
    z = Basinski.ar(in: z, loss:0.1, lossFreq:1.0, noise:0.1);
    0.05*~l[x]*Splay.ar(z,pan);
};
)

(
~sq1.play(0,2);
~sq1= { var x = 2, cutter = LFTri.kr(~lf[x+2]).range(1,2),
    pan = LFTri.kr(~lf[x]).range(-1,1); 
    z = LFPulse.ar([~f[x], ~f[x]*~d3]);
    z = DFM1.ar(z,300*cutter, 0.05*~l[x+1], noiselevel: 0.0035);
    0.25*~l[x]*Balance2.ar(z[0], z[1],pan);
};


)
(
~sfb1.play(0,2);
~sfb1= { var x = 9, fb = LFSaw.kr(~lf[x+10]).range(0.6,1.75),
    pan = LFTri.kr(~lf[x]).range(-1,1), phaser = LFPar.kr(~lf[x]).range(-4pi, 4pi); 
    z = SinOscFB.ar(freq: [~f[x], ~f[x]*~d], feedback: ~l[x]*fb, mul: 1);
    z = DFM1.ar(z,850, 0.05*~l[x+1], noiselevel: 0.0035);
    0.08*~l[x]*Balance2.ar(z[0], z[1], pan);
};
)
10-3
(
~sin6.play(0,2);
~sin6 = { var x=15, 
    pan = LFTri.kr(~lf[x]).range(0,1),phaser = LFPar.kr(~lf[x]).range(-6pi, 6pi); 
    z = SinOsc.ar(freq: [~f[x], ~f[x]*~d3], phase: phaser, mul: 0.25);
    //z = DFM1.ar(z, 250);
    z = Splay.ar(z,pan);
    z = Basinski.ar(in: z, loss:~ls[x-3], lossFreq:1.0, noise:0.0);

};
)


// Memories arriving at the ear, twisted


g = ServerOptionsGui(s);
(
// Allocate memory
s.options.memSize = 8192 * 128;

// Set sample rate
//s.options.sampleRate= 44100;

// Number of hardware ins / outs
//s.options.numOutputBusChannels;
s.options.numOutputBusChannels=12;
s.options.numInputBusChannels;

// increase this if you are getting drop outs and the message "too many nodes"
s.options.maxNodes = 1024 * 128; 

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
p.fadeTime = 1;
p.clear;
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
)

// Erindringer ind gennem ørerne, men også den anden vej

/**************************** 
    printer  
*****************************/

(
300.do{"_-´~`".post;};
300.do{"((( Bonsoir a tous ))) ".post;};
300.do{"_-´~`".post;};
)

/**************************** 
    synths  
*****************************/

/* --- SYNTH: s1 --- */
SynthDef(\s1, {
  arg out=0, amp=1.0, freq, dur, cutoff = 2000, res=0.5,
  loss = 0.1, noise=0.1, revamount = 1.0,
  atk=3, sus=1, rel=3, pan=0, autopan=0.75, filtermod=0.10;
  var env, panner, sig, bas, amplitudes, ringtimes, freqs, lfo;

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.5, 0.0], [atk, sus, dur, rel]), doneAction:2);

  // Signal
  freqs = [freq, freq*2];//, freq*3, freq*4];

  amplitudes = Array.fill(freqs.size, {Rand.new(0.1,0.5)});

  ringtimes = Array.fill(amplitudes.size, {Rand.new(0.15, 0.5)}); 

  sig =  DynKlank.ar(`[[freq, freq*2, freq*3], amplitudes, ringtimes],
  PinkNoise.ar(0.01),
  freqscale: 2, freqoffset: 0, decayscale: 1);

  bas = Basinski.ar(in: sig, loss:loss, lossFreq:1.1, noise:noise);

  //sig = XFade2.ar(bas,sig, pan: env.range(-1,1), level: 1);

  sig = Basinski.ar(in: sig, loss:loss, lossFreq:1.0, noise:noise);    

  // Filter
  lfo = LFTri.kr(freq/10, 0, 50*filtermod);
  sig = DFM1.ar(sig, freq: Lag.kr(cutoff, 0.5)+lfo, res: res*env, 
    inputgain: 1, type:0, noiselevel: 0.0003);     

  // Pan
  panner = LFCub.kr(freq/1000).range(-1.0,1.0) * autopan;
  sig = Pan2.ar(sig, panner);

  sig = sig * amp * env;
  Out.ar(out, sig )
}).add;


/* --- SYNTH: s2 --- */
SynthDef(\s2, {
  arg out=9, amp=0.25, fmi=1, freq=440, gdur=0.11, noise=0.1,
  atk=1, sus=1, rel=1, pan=0, trigrate=20,dur, cloudsize=10, lfofreq=0.25,
  cutoff=2500, loss=0.05;
  var env, sig, trigger, freqs, trigs, graindurs, lfo, size=3;

  // Arrays 
  freqs = all {: x*freq, x<-(1..size)};
  freqs = freqs ++ all {: x*1.01, x <- freqs };
  graindurs = all {:gdur/x, x <- (1..freqs.size+1)};
  trigs = Array.fill(freqs.size, {arg i; (1+i)*trigrate});

  // Modulation
  lfo = LFTri.kr(lfofreq);  

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel]), doneAction:2);

  // Trigger
  trigger = Dust.ar(trigs*0.25);

  // Signal
  //sig = GrainSin.ar(numChannels: 2, trigger: trigger, dur: gdur, freq: freqs*1.01, pan: lfo, envbufnum: -1, maxGrains: 512, mul: 0.1/cloudsize, add: 0);

  //sig = Basinski.ar(in: sig, loss:loss, lossFreq:lfofreq, noise:0.4)*(loss/2);

  sig = FMGrain.ar(trigger: trigger, dur: graindurs, carfreq: freqs, modfreq: freqs*4, index: 1, mul:0.1/cloudsize);    
  sig = sig/2 + Basinski.ar(in: sig, loss:loss, lossFreq:lfofreq, noise:noise)/2;

  // Filter
  sig = DFM1.ar(sig, freq: cutoff, res: 0.1, inputgain: 1, type:0, noiselevel: 0.0003);
  sig = HPF.ar(sig,100);
  // Output+mix
  sig = Splay.ar(sig, lfo);    
  sig = Pan2.ar(sig, lfo.range(-1.0,1.0), 1);
  sig = sig * env * amp;
  Out.ar(out, sig )
}).add;

/* --- SYNTH: s3 --- */
SynthDef(\s3, {
  arg out=0, amp=1.0,freq,dur, cutoff=500,
  atk=1, sus=1, rel=1, pan=0, loss=0.0, noise=0.0;
  var env, sig, lfo;

  // lfo
  lfo = LFSaw.kr(freq/10, mul:cutoff/10); 

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, sus, rel]), doneAction:2);

  // Signal
  sig = SinOscFB.ar([freq, freq*3]*env.range(0.10,1.0), 0.2, [1.0,0.3]);
  sig = sig/2 + SawDPW.ar(freq: [freq, freq*3]*env.range(0.05,1.0), iphase: env, mul:0.03)/2;
  sig = Basinski.ar(in: sig, loss:loss, lossFreq:1.0, noise:noise);
  sig = DFM1.ar(sig, freq: cutoff+lfo, res: env.range(0,0.8), 
    inputgain: 1, type:0, noiselevel: 0.0003); 
  sig = HPF.ar(sig, 40);   
  sig = Pan2.ar(sig.sum, pan);

  sig = sig * env * amp;
  Out.ar(out, sig )
}).add;

/* --- SYNTH: s4 --- */
SynthDef(\s4, {
  arg out=0, amp=1.0,freq,dur, cutoff=500,
  atk=1, sus=1, rel=1, pan=0, loss=0.0, noise=0.0, res=0.9;
  var env, sig, lfo;

  // lfo
  lfo = LFSaw.kr(freq/10, mul:cutoff/5); 

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, sus, rel]), doneAction:2);

  // Signal
  sig = SinOscFB.ar([freq, freq*3], 0.2, [1.0,0.3]);
  sig = sig/2 + SawDPW.ar(freq: [freq, freq*3], iphase: env, mul:0.03)/2;
  sig = Basinski.ar(in: sig, loss:loss, lossFreq:1.0, noise:noise);
  sig = DFM1.ar(sig, freq: cutoff+lfo, res: res*env, 
    inputgain: 1, type:0, noiselevel: 0.0003); 
  sig = HPF.ar(sig, 40);   
  sig = Pan2.ar(sig.sum, pan);

  sig = sig * env * amp;
  Out.ar(out, sig )
}).add;

/**************************** 
    patterns  
*****************************/
~sin.play;
~sin = {1+LFPulse.kr(freq:26.reciprocal, mul:0.25)};
(
// frequency organisation 
o = Scale.bartok;
o.degrees.midicps*12;
d = Dictionary.new;
d[\f] = [53, 53*1.25, 53*2.5, 53*3]++[53, 53*1.25, 53*2.5, 53*3];
//d[\f] = o.degrees.midicps*12;
d[\mf1] = Pseq([d[\f][0..3], d[\f][2..3], d[\f][0..3]],1);
d[\mf15] = Pseq([d[\f][0..3], d[\f][2..4], d[\f][0..3]],1)*1.5;
d[\mf2] = Pseq([d[\f][0..3], d[\f][2..3], d[\f][0..3]],1)*2;
d[\mf3] = Pseq([d[\f][0..3], d[\f][2..3], d[\f][0..3]],1)*3;
)
~p1.play;
~p1 = Pbind( \instrument, \s1, 
\amp, 0.07, 
\freq, Pseq([d[\mf1], d[\mf2], d[\mf1],d[\mf1], d[\mf15]],inf), 
\cutoff, Pseries(200, 100), 
\rel, 1,
\dur, Pseq([8,3,15], inf), 
\filtermod, 0.8,
\res, 0.7,
\loss, Pn(Pseries(0, 0.01, 50), inf),
\noise,0.0,
\out, 0,
\pfunc, Pfunc({"%: p1 is playing s1 synth".format(Date.getDate.format("%H:%M:%S")).postln}),
\autopan, 0.5);

~p2.play;
~p2.free;
i = d[\f][2..7];
~p2 = Pbind(
  \instrument, \s1, 
  \amp, 0.02,
  \atk, 3,
  \sus, 2,
  \rel, 3.5,
  \res, 0.92,
  \autopan, 0.95,
  \freq, Pseq([i*6, Pxrand(i*10, 2), i*12],inf),
  \pan, Pwhite(-1.0,1.0,inf),
  \dur, Pseq([1.5, 1.25, 1.75, Rest(13.5)], inf),
  \loss, Pseq([0.2, 0.5, 0.6],inf),
  \noise, Pwhite(0,0.75),
  \cutoff, Pwhite(1000,3000,inf),
  \pfunc, Pfunc({"%: p2 is playing s1 synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 2
);


/*** Pattern p3 for s2 synth ***/
// Grains
~p3.play;
~p3.free;
~p3 = Pbind(
  \instrument, \s2, 
  \amp, 0.10,
  \trigrate, 10, //Pbrown(0.51, 1.55, 0.25),
  \gdur, Pbrown(0.15,0.5, 0.1),
  \freq, Pseq([i*12, i*6, i*12],inf),
  \atk, 4,
  \cutoff, 3000,
  \loss, Pn(Pseries(0.05, 0.1, 5), inf),
  \noise, Pn(Pseries(0.25, 0.1, 5), inf),
  \rel, 4,
  \lfofreq, Pseq([1/8, 0.25, 0.25, 0.5],inf),
  \dur, Pseq([8, Rest(4)], inf),
  \pfunc, Pfunc({"%: p3 is playing s2 synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 4
);

/*** Pattern p4 for s3 synth ***/
~p4.free
(
~p4.play;
// Måger
r = 0.25;
~p4 = Pbind(
  \instrument, \s3,
  \amp, 0.010,
  \atk,Pxrand([0.1,0.25, 0.5],inf),
  \cutoff, 2000,//Pseries(100,100,inf),
  \sus, 1.00,
  \rel, Pseq([Pn(r,10),Pn(r*4, 10),Pn(r*3, 10)],inf),
  \loss, 0.83,
  \noise, 0.5,
  \freq, Pseq([i*8, i*12, i*15],inf, 3),
  \pan, Pwhite(-1.0,1.0,inf),
  \dur, Pseq([Pseq([r, r*3, r, Rest(r*2), r, r*5, Rest(r)],2), Rest(16)],inf),
  \out, 6
);
)
/*** Pattern p5 for s3 synth ***/
// poly 
~p5.free;
(
~p5.play;
b = d[\f][0..2].reverse;
~p5 = Pbind(
  \instrument, \s4, 
  \amp, 0.008,
  \freq, Pseq([b*5, b*2, b*10]*4,inf),
  \dur, Pseq([Pstutter(7, Pseq([0.25,Rest(2),1,2, Rest(1)], 3)), Rest(8)],inf),
  \cutoff, 800,
  \pan, Pseq([-0.55, -0.15, 0.15, 0.55],inf),
  \atk,0.25,
  \loss, Pn(Pseries(0, 0.1, 5), inf),
  \noise, Pn(Pseries(0, 0.1, 6), inf),
  \sus, 2,
  \rel, 3.25,
  \pfunc, Pfunc({"%: p5 is playing s4 synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 8
);
)
~p6.free;
(
// Low end 
~p6.play;
~p6 = Pbind(
  \instrument, \s4, 
  \amp, 0.13,
  \freq, Pseq([Pseq(b*0.5,1), Rest(10)],inf),
  \atk, 0.1,
  \dur, Pseq([8,3,15, 8, 8], inf), 
  \cutoff, 50,
  \res, 0.25,
  //\loss, Pn(Pseries(0, 0.1, 5), inf),
  //\noise, Pn(Pseries(0, 0.1, 5), inf),
  \pfunc, Pfunc({"%: p6 is playing s4 synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 10 
);

//~p6 = Pmulp(\dur,Pseq([0.25,2],inf),~p6); 
)
(
// Record
s.record;
Ppar([~p1, ~p2, ~p3, ~p4, ~p5, ~p6] ).play
)
~p1.play
~p1.free;
~p2.play;
~p2.free;
~p3.play;
~p3.free;
~p4.play;
~p4.free;
~p5.play;
~p5.free;
~p6.play;
~p6.free;
s.meter;
s.avgCPU;
s.stopRecording;a
Scale.directory;

[1,2,3,4].size;

Server.local.avgCPU;
s.record
s.stopRecording;s.stopRecording;

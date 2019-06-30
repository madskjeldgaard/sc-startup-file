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
s.boot;
)


/* --- EFFECT AUX: reverb --- */

~reverbBus = Bus.audio(s, 1); // 2 channel audio bus 

(
SynthDef(\reverb, {
  arg out=0, amp=0.5, inBus = ~reverbBus;

  var sig, in;

  // Signal
  in = In.ar(inBus,1);
  
  /*sig = Greyhole.ar(in, 
    delayTime: 0.25, 
    damp: 0, //  0 is no damping, 1 is very strong damping (0..1)
    size: 5, // Values below 1 can sound metallic. (0.5..5) 
    diff: 0.107, // controls pattern of echoes produced by the diffuser. 
    feedback: 0.5, 
    modDepth: 0.8, // (0..1) 
    modFreq: 8 // (0..10) 
  );*/ 
  sig = JPverb.ar(in, 
    t60: 1, // approximate reverberation time in seconds (T60 - the time for the reverb to decay 60db) 
    damp: 0, 
    size: 1, 
    earlyDiff: 0.707, //controls shape of early reflections. Values of 0.707 or more produce smooth exponential decay.
    modDepth: 0.1, 
    modFreq: 2, 
    low: 1,   
    mid: 1, 
    high: 1, 
    lowcut: 500, highcut: 2000);
  sig = sig * amp;
  Out.ar(out, sig)
}).add;

/* --- SYNTH: unstableSine--- */
SynthDef(\unstableSine, {
  arg out=0, effectbus=~reverbBus, amp=1.0, freq = 110,
  atk=2, sus=1, rel=1, pan=0, fatk= atk/2, frel = rel/2, 
  lpf=200, res=0.8, phase=0, lpfmod=0.00, revamount=0.00, dur;
  var env, sig,lfo,rev, devfreq;

  devfreq = freq + ( (freq/100) * SinOsc.kr(freq/25).range(1.0,2.0));

  // LFO
  lfo = LFPar.kr(lpfmod).range(1,2);

  // Envelope
  env = EnvGen.kr(Env([0,1,1,0],[atk,dur-rel,rel] ), gate:dur, doneAction:2);

  // Signal
  sig = Mix.fill(1, SinOscFB.ar([freq, devfreq, freq*3, devfreq*5], [pi, 2pi, 4pi, 2pi, pi])) * 0.1 ;
  sig = (sig + Fold.ar(sig, 0.0, 0.30));
  sig = DFM1.ar(sig, Lag.kr(lpf), res: res*env, noiselevel: 0.0010); 
  sig = Splay.ar(sig, 0,1, pan);

  sig = sig * env * amp;

  //Out.ar(effectbus, sig*revamount);
  Out.ar(out, sig )
}).add;

/* --- SYNTH: spaceGrain --- */
SynthDef(\spaceGrain, {
  arg out=0, effectbus=~reverbBus, amp=1.0, freq = 110,
  atk=2, sus=1, rel=1, pan=0, fatk= atk/2, frel = rel/2, 
  lpf=2000, res=0.7, phase=0, lpfmod=0.10, revamount=0.75, graindur = 0.05,
  grainlvl=0.30, grainlfo=0.25, dur;
  var env, sig,lfo,rev, grain, gfreq, devfreq, fmgrain, glfo1, glfo2;

  devfreq = freq + ( (freq/100) * SinOsc.kr(freq/10).range(1.0,3.0));

  // LFO
  lfo = LFPar.kr(lpfmod).range(1,2);

  glfo1 = LFTri.kr(grainlfo);
  glfo2 = LFTri.kr(grainlfo + (grainlfo/10));

  // Envelope
  env = EnvGen.kr(Env([0,1,1,0],[atk,dur-rel,rel] ), gate:dur, doneAction:2);

  // Grains
  gfreq = Array.fill(10, {|i| 10*[freq, devfreq]*(i+1)});
  grain = SinGrain.ar(Dust.kr(freq), graindur, gfreq, 0.3/gfreq.size).sum * glfo1;
  fmgrain = FMGrain.ar(Dust.kr(freq), graindur, gfreq, gfreq*4, mul:0.3/gfreq.size).sum *glfo2; 

  sig = Splay.ar([grain*grainlvl, fmgrain*grainlvl],pan);
  sig = DFM1.ar(sig, Lag.kr(lpf)*lfo, res: res*env, noiselevel: 0.0001); 

  sig = sig * env * amp;

  Out.ar(effectbus, sig*revamount);
  Out.ar(out, sig )
}).add;

/* --- SYNTH: polySaw --- */
SynthDef(\polySaw, {
  arg out=0, effectbus=~reverbBus, amp=1.0, freq = 110,
  atk=1, sus=1, rel=1, pan=0, fatk= atk/2, frel = rel/2, 
  lpf=200, res=0.7, phase=0, lpfmod=0.10, revamount=0.75, dur;
  var env, sig,lfo,rev, fenv;

  // LFO
  lfo = LFPar.kr(lpfmod).range(1,2);

  // Envelope
  env = EnvGen.kr(Env([0,1,1,0],[atk,dur-rel,rel] ), gate:dur, doneAction:2);

  // Signal
  sig = SawDPW.ar(freq: freq, iphase: Saw.kr(0.25).range(-1.0,1.0))*0.3;
  sig = DFM1.ar(sig, Lag.kr(lpf)*lfo, res: res*env, noiselevel: 0.0009); 
  sig = Splay.ar(sig,pan);

  sig = sig * env * amp;

  Out.ar(effectbus, sig*revamount);
  Out.ar(out, sig )
}).add;
)
(
~i = 1;    
~root = 65;
~step = (~root/12) + ~root;
~n1 = all {: x*~i, x <- (~root..~root*2), x.isPrime};
~c1 = all {: [x,y,z], x <- ~n1[0..], y<- ~n1[2..],z<- ~n1[4..]}; 
~c2 = all {: [x,y,z], x <- ~n1[0..], y<- ~n1[2..],z<- ~n1[6..]}; 



/*** Pattern sawpat1 for polySaw synth ***/
~sawpat1 = Pbind(
  \instrument, \polySaw, 
  \amp, 0.2,
  \res, 0.85,
  \freq, Pseq([~c2[0], ~c2[0]],inf),
  \dur, Pseq([3,Rest(4),5], 14),
  \lpf, Pseq([30, 25],inf) + Pseries(0,10,inf), 
  \lpfmod, Pseq([0.1,2],inf),
  \pfunc, Pfunc({"%: sawpat1 is playing polySaw synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);
/*** Pattern sawpat2 for polySaw synth ***/
~sawpat2 = Pbind(
  \instrument, \unstableSine, 
  \amp, 0.05,
  \freq, Pseq([~c1[0][0], ~c1[0][2], ~c1[0][1]]*5, inf), 
  \atk, 0.1,
  \lpf, 500,
  \lpfmod, Pseq([2,2,4,8],8),
  \pan, Pwhite(0,1,inf),
  \revamount, 1.0,
  \dur, 1*2,   
  \pfunc, Pfunc({"%: sawpat2 is playing polySaw synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);
/*** Pattern sawpat3 for polySaw synth ***/
~sawpat3 = Pbind(
  \instrument, \polySaw, 
  \amp, 0.05,
  \freq, Pseq([~c1[0][0], ~c1[0][2], ~c1[0][1]]*5, inf), 
  \lpf, Pseq([200, 50],inf) + Pseries(0,1,inf), 
  \lpfmod, 5,
  \pan, Pwhite(0,1,inf),
  \dur, Pstutter(3, Pseq([1,0.25,1]/5, 128)),
  \pfunc, Pfunc({"%: sawpat3 is playing polySaw synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);



/*** Pattern sinepat1 for unstableSine synth ***/
~sinepat1 = Pbind(
  \instrument, \unstableSine, 
  \amp, 0.40,
  \freq, Pseq([~c1[0][0], ~c1[0][2], ~c1[0][1]], 16), 
  \lfomod, 0.00,
  \lpf, 100, //Pseq([500, 400, 300, 400, 500, 800, 300, ]/2,inf), 
  \revamount, 0,
  \atk, 0.1,
  \rel,1.0,
  \dur, Pseq([2,Rest(3),4,5], inf),
  \pfunc, Pfunc({"%: is playing unstableSine synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

/*** Pattern spacegrainpat for spaceGrain synth ***/
~spacegrainpat = Pbind(
  \instrument, \spaceGrain, 
  \amp, 0.01,
  \freq, Pseq([~c1[0][0], ~c1[0][2], ~c1[0][1]], 16), 
  \lpf, Pseq([500, 400, 300, 400, 500, 800, 300, ]*5,inf), 
  \dur, Pseq([2,Rest(3),4,5], inf),
  \pfunc, Pfunc({"%: spacegrainpat is playing spaceGrain synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \revamount, 1, 
  \out, 0
);
/*** Pattern spacekick for kickdrum synth ***/
~spacekick = Pbind(
  \instrument, \kickdrummm, 
  \amp, 0.7,
  \dur, Pseq([2,Rest(3),4,5], inf),
  \freq, ~c1[0][0],
  \send, 0.000,
  \rel, Pkey(\dur) ,
  \pfunc, Pfunc({"%: spacekick is playing kickdrum synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

//~sawpat1.play;
//~reverb = Synth(\reverb);
~spacekick.play;
~sawpat3.play;
~spacegrainpat.play;
//~sinepat1.play;

)

(
~reverb = Synth(\reverb);

Pseq([
Pfindur(148, Ppar([~sawpat3, ~sinepat1],1)),
Pfindur(16, Ppar([~sawpat2, ~sinepat1],1))
], 1).play;
)

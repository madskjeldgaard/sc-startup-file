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

// Boot the server 
s.reboot;
)

/* --- SYNTH: tape --- */
SynthDef(\tape, {
  arg buffer, out=0, amp=2.0, rate=1.0,
  atk=1, sus=1, rel=1, revAmount=0.5, lpf=1000, res=0.25, 
  loss = 1, reverbBus=~reverbBus, grainBus = ~concatBus;
  var env, sig, h, s;

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);
    
  sig = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * rate + (env/10 *
      Lag.kr(Dust.kr(18))), doneAction:0);

  // Signal
  sig = Meddis.ar(Meddis.ar(sig));
  h =  Meddis.ar(PitchShift.ar(sig, SinOsc.kr(2).range(0, 1), 0.9, 0.26, 0.2));
    s = Meddis.ar(FreqShift.ar(sig, freq: 0.25, phase: 0.75, mul: loss * 0.5)) * Dust.kr(loss);
  sig = DFM1.ar(sig, freq: lpf, res: res, inputgain: 1.9, type:0, noiselevel: 0.0039); 
  sig = Splay.ar([sig, h,s], Saw.kr(0.25).range(0, 1), 1, LFNoise1.kr(0.1).range(0.0, 1)  );
  //sig = WaveLoss.ar(sig, Saw.kr(2).range(0, 40) , 40, 2);
  sig = Meddis.ar(sig);

  sig = sig * env * amp;
    Out.ar(reverbBus, sig * revAmount);
    Out.ar(grainBus, sig * revAmount);

  Out.ar(out, sig )
}).add;

/* --- SYNTH: tapeMono --- */
SynthDef(\tapeMono, {
  arg buffer, out=0, amp=2.0, rate=1.0,
  atk=1, sus=1, rel=1, revAmount=0.5, lpf=1000, res=0.25, 
  loss = 1, reverbBus=~reverbBus, grainBus = ~concatBus;
  var env, sig, h, s;

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);
    
  sig = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * rate + (env/10 *
      Lag.kr(Dust.kr(18))), doneAction:0);

  // Signal
  sig = Meddis.ar(Meddis.ar(sig));
  h =  Meddis.ar(PitchShift.ar(sig, SinOsc.kr(2).range(0, 1), 0.9, 0.26, 0.2));
    s = Meddis.ar(FreqShift.ar(sig, freq: 0.25, phase: 0.75, mul: loss * 0.5)) * Dust.kr(loss);
  sig = DFM1.ar(sig, freq: lpf, res: res, inputgain: 1.9, type:0, noiselevel: 0.0039); 
  sig = Splay.ar([sig, h,s]);
  sig = WaveLoss.ar(sig, Saw.kr(2).range(0, 40) , 40, 2);
  //sig = Meddis.ar(Meddis.ar(Meddis.ar(sig)));

  sig = sig * env * amp;
    Out.ar(reverbBus, sig * revAmount);
    Out.ar(grainBus, sig * revAmount);

  Out.ar(out, sig )
}).add;


/* --- EFFECT AUX: reverb --- */

~reverbBus = Bus.audio(s, 2); // 2 channel audio bus 

SynthDef(\reverb, {
  arg out=0, amp=0.75, inBus = ~reverbBus,effectBus = ~concatBus,  time=1, size=1, modD = 0.2, modF=2;

  var sig, in;

  // Signal
  in = In.ar(inBus, 2);
  
  sig = JPverb.ar(in, 
    t60: Lag.kr(time, 5.0), // approximate reverberation time in seconds (T60 - the time for the reverb to decay 60db) 
    damp: 0, 
    size: Lag.kr(size, 6.0), 
    earlyDiff: 0.707, //controls shape of early reflections. Values of 0.707 or more produce smooth exponential decay.
    modDepth: modD, 
    modFreq: modF, 
    low: 1,   
    mid: 1, 
    high: 1, 
    lowcut: 500, highcut: 2000);
  sig = sig * amp;
//sig = Meddis.ar(Meddis.ar(Meddis.ar(sig)));
//sig = WaveLoss.ar(sig, Saw.kr(2).range(0, 40) , 40, 2);

  Out.ar(out, sig)
}).add;

(
/*** Batch load samples for arrayOfSamples ***/
// Be careful when using samples in eg. grain Ugens: They expect mono
// samples.
~arrayOfSamples = Array.new; 

~folder =
PathName.new("/Users/madskjeldgaard/Desktop/Projekter/SOUL/samples/stereo/cello");

~folder.entries.do({
  arg path;
  ~arrayOfSamples = ~arrayOfSamples.add(Buffer.read(s, path.fullPath));
});
)

/*** Pattern pattern1 for tape synth ***/
~pattern1 = Pbind(
  \instrument, \tape, 
  \buffer, ~arrayOfSamples[41],
  \rate, Pseq([0.75, 0.5, 1.25],inf)*3,
  \amp, 0.25,
  \dur, Pseq([4,Rest(8),5,3], 16)/2,
\rel, Pseq([4,4,4,4], 8),
  \pfunc, Pfunc({"%: pattern1 is playing tape synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

~pattern2 = Pbind(
  \instrument, \tape, 
  \buffer, ~arrayOfSamples[42],
  \rate, Pseq([Pseq([0.75, 0.5, 1.34],2)*2,
        Pseq([0.75, 0.5, 1.34],1)*1,
        Pseq([0.75, 0.5],1)*2], 4) ,
  \res, Pwhite(0.25, 0.5),
  \amp, 0.25,
  \dur, Pseq([1,2,3, 4, 5,6], inf)/2,
\rel, 1.25,
  \pfunc, Pfunc({"%: pattern2 is playing tape synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

~pattern3 = Pbind(
  \instrument, \tape, 
  \buffer, ~arrayOfSamples[40],
  \rate, Pseq([0.75, 1.5], inf),
  \amp, 0.25,
  \dur, Pseq([6,Rest(8)], 3),
\rel, 1.00,
  \pfunc, Pfunc({"%: pattern3 is playing tape synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

/*** Pattern pattern4 for tape synth ***/
~pattern4 = Pbind(
  \instrument, \tape, 
  \amp, 0.25,
  \buffer, ~arrayOfSamples[43],
  \rate, 0.75,
  \dur, 12,
  \pfunc, Pfunc({"%: pattern4 is playing tape synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

/*** Pattern pattern5 for synthDefName synth ***/
~pattern5 = Pbind(
\instrument, \tape, 
  \buffer, ~arrayOfSamples[49],
  \rate, Pseq([0.75, 0.5, 1.25],inf)*5,
  \res, Pwhite(0.25, 0.5),
  \amp, 0.25,
  \lpf, 2000,
  \dur, Pseq([1,2,Rest(3),4], 16)/5,
\rel, 1.25,
  \out, 0,
  \pfunc, Pfunc({"%: pattern5 is playing synthDefName synth".format(Date.getDate.format("%H:%M:%S")).postln})
);

/*** Pattern pattern6 for tape synth ***/
~pattern6 = Pbind(
  \instrument, \tape, 
  \buffer, ~arrayOfSamples[50],
  \rate, Pseries(1, 0.25),
  \amp, 0.1,
  \dur, Pseq([2,Rest(2),4,Rest(4)], 2)/2,
  \pfunc, Pfunc({"%: pattern6 is playing tape synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

/*** Pattern revpat for reverb synth ***/
~revpat = Pmono(
  \reverb, 
  \amp, 0.5,
  \size, Pseq([3,2.75], inf),
  \time, Pkey(\size)*2,
  \modF, Pkey(\size)/2,
  \modD, Pwhite(0.2,0.8, inf),
  \dur, Pseq([16,32,22,32], inf),
  \pfunc, Pfunc({"%: revpat is playing reverb synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

~revpat.play;
~pattern1.play;
~pattern2.play;
~pattern3.play;
~pattern4.play;
~pattern6.play;

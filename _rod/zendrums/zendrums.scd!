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

(
/*** Batch load samples for s2 ***/
// Be careful when using samples in eg. grain Ugens: They expect mono
// samples.
~s2 = Array.new; 

~folder = PathName.new("/Users/madskjeldgaard/Desktop/Field\ rec/Vand");

~folder.entries.do({
  arg path;
  ~s2 = ~s2.add(Buffer.read(s, path.fullPath));
});
)
// Test if samples work
~s2[0].play;

/* --- EFFECT AUX: reverb --- */

~reverbBus = Bus.audio(s, 2); // 2 channel audio bus 

SynthDef(\reverb, {
  arg out=0, amp=0.75, inBus = ~reverbBus,effectBus = ~concatBus,  time=1, size=1, modD = 0.5, modF=8;

  var sig, in;

  // Signal
  in = In.ar(inBus, 2);
  
  sig = JPverb.ar(in, 
    t60: Lag.kr(time, 2.0), // approximate reverberation time in seconds (T60 - the time for the reverb to decay 60db) 
    damp: 0, 
    size: Lag.kr(size, 4.0), 
    earlyDiff: 0.707, //controls shape of early reflections. Values of 0.707 or more produce smooth exponential decay.
    modDepth: modD, 
    modFreq: modF, 
    low: 1,   
    mid: 1, 
    high: 1, 
    lowcut: 200, highcut: 2000);
  /*
  sig = WaveLoss.ar(sig, Saw.kr(5).range(0, 40) , 40, 2);
  sig = Meddis.ar(Meddis.ar(sig));
  */

  //sig = Splay.ar(sig, Saw.kr(0.5).range(0, 1));
  sig = sig * amp;
  Out.ar(out, sig)
}).add;


/* --- SYNTH: zenDrum1 --- */
SynthDef(\zenDrum1, {
  arg out=0, amp=0.5,
  atk=0, sus=0.5, rel=5, freq=250, res=0.1, 
  floatingThoughts = 0.05, tension=4,
  pan=0, reverbBus = ~reverbBus;
  var env, sig, exciter, panOsc;

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);



  // Exciter
    exciter = WhiteNoise.ar() * Saw.kr(floatingThoughts) * 0.02;

    exciter = DFM1.ar(exciter, freq: freq, res: res, 
      inputgain: 1, type:0, noiselevel: 0.0003); 

  // Signal
  sig = MembraneCircle.ar(exciter, tension: 0.01*tension) * env;
  panOsc = PMOsc.kr(freq/100, freq/25, pmindex: 0.5, modphase: 0.25);
  sig = Pan2.ar(sig, pos: pan, level: 1);   

  sig = sig * amp;
  Out.ar(reverbBus, sig);

  Out.ar(out, sig )
}).add;

/* --- SYNTH: zenDrum2 --- */
SynthDef(\zenDrum2, {
  arg out=0, amp=0.5,
  atk=0, sus=0.5, rel=5, freq=250, res=0.1, 
  floatingThoughts = 0.05, tension=4,
  pan=0, reverbBus = ~reverbBus;
  var env, sig, exciter, panOsc;

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);



  // Exciter
    exciter = WhiteNoise.ar() * Saw.kr(floatingThoughts) * 0.02;

    exciter = DFM1.ar(exciter, freq: freq, res: res, 
      inputgain: 1, type:0, noiselevel: 0.0003); 

  // Signal
  sig = MembraneHexagon.ar(exciter, tension: 0.01*tension) * env;
  panOsc = PMOsc.kr(freq/100, freq/25, pmindex: 0.5, modphase: 0.25);
  sig = Pan2.ar(sig, pos: pan, level: 1);   

  sig = sig * amp;
  Out.ar(reverbBus, sig);

  Out.ar(out, sig )
}).add;


(
i = 5; 

a = Pseq([1, 1.00, 1.05, 1.10],1);
r = Pseq([1, 1.00, 1.05, 1.10],1)*3;

~tensionpat = Pseq([a*1, a*3, a*2, a*2.5 ],inf);
~releasepat = Pseq([r*2, r*3, r*1, r*3],inf);

/*** Pattern pattern2 for zenDrum1 synth ***/
~pattern1 = Pbind(
  \instrument, \zenDrum1, 
  \amp, 0.15,
  \dur, Pseries(1,1, 5),
  \freq, Pwhite(200, 800),
  \tension, ~tensionpat,
  \rel, ~releasepat,
  \pan, Prand([1.0, 0.25, 0.0, (-0.25), (-1.0)],inf),
  \pfunc, Pfunc({"%: pattern1 is playing zenDrum1 synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);
~pattern2 = Pbind(
  \instrument, \zenDrum1, 
  \amp, 0.25,
  \dur, Pseq([2,3, Rest(3)], 16, 3),
  \freq, Pwhite(200, 1800),
  \floatingThoughts, 0.10,
  \tension, 2.10,
  \rel, ~releasepat,
  \pan, Prand([1.0, 0.25, 0.0, (-0.25), (-1.0)],inf),
  \pfunc, Pfunc({"%: pattern2 is playing zenDrum1 synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

~pattern3 = Pbind(
  \instrument, \zenDrum1, 
  \amp, 0.25,
  \dur, Pseq([2,3, Rest(3)], 16, 3),
  \freq, Pwhite(200, 1800),
  \floatingThoughts, 0.50,
  \tension, 3.30,
  \rel, ~releasepat*2,
  \pan, Prand([1.0, 0.25, 0.0, (-0.25), (-1.0)],inf),
  \pfunc, Pfunc({"%: pattern3 is playing zenDrum1 synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

~pattern4 = Pbind(
  \instrument, \zenDrum2, 
  \amp, 0.25,
  \dur, Pseq([3,2, Rest(5)], 16, 3),
  \freq, Pwhite(200, 1800),
  \floatingThoughts, 0.50,
  \tension, 4.40,
  \rel, ~releasepat*2,
  \pan, Prand([1.0, 0.25, 0.0, (-0.25), (-1.0)],inf),
  \pfunc, Pfunc({"%: pattern3 is playing zenDrum1 synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

~pattern5 = Pbind(
  \instrument, \zenDrum2, 
  \amp, 0.25,
  \dur, Pseq([Rest(32), 8], 16),
  \freq, Pwhite(200, 1800),
  \floatingThoughts, 0.50,
  \tension, 1.10,
  \rel, ~releasepat*2,
  \pan, Prand([1.0, 0.25, 0.0, (-0.25), (-1.0)],inf),
  \pfunc, Pfunc({"%: pattern3 is playing zenDrum1 synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

/*** Pattern revpat for reverb synth ***/
~revpat = Pmono(
  \reverb, 
  \amp, 0.5,
  \size, Pseq([4,2.75, 2.5, 2.25], inf),
  \time, Pkey(\size)*2,
  \modF, Pkey(\size)*2,
  \modD, Pwhite(0.2,0.8, inf),
  \dur, Pseq([6,16,12,12], inf),
  \pfunc, Pfunc({"%: revpat is playing reverb synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

~tapepat = Pbind(
  \instrument, \tape, 
  \buffer, ~arrayOfSamples[11],
  \rate, Pseq([Pseq([0.75, 0.5, 1.34],2)*1.7,
        Pseq([0.75, 0.5, 1.34],1)*1,
        Pseq([0.75, 0.5],1)*2], 4) ,
  \res, Pwhite(0.25, 0.5),
  \amp, 0.5,
  \dur, Pseq([1,2,3, 4, 5,6], inf)*6,
\rel, 1.25,
  \pfunc, Pfunc({"%: pattern2 is playing tape synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

~tapepat2 = Pbind(
  \instrument, \tapeMono, 
  \buffer, ~s2[8],
  \lpf, 8000,
  \rate, 1.0,
    \res, Pwhite(0.25, 0.5),
  \amp, 0.25,
  \dur, Pseq([Rest(2),1,2,3, 4, 5,6], inf)*6,
\rel, 1.25,
  \pfunc, Pfunc({"%: tapepat2 is playing tape synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

/*** Pattern tapepat3 for tapeMono synth ***/
~tapepat3 = Pbind(
  \instrument, \tape, 
  \buffer, Pseq([~s2[1],~s2[0]],4),
  \amp, 0.5,
  \lpf, 2000, 
  \rate, Pseq([0.75, 1.0, 1.15],inf),
  \sus, Pseq([48], inf),
  \dur, Pseq([48], inf),
  \pfunc, Pfunc({"%: tapepat3 is playing tapeMono synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

)

(
~revpat.play;
//Pn(~pattern1, 4).play;
~pattern2.play;
~pattern3.play;
~pattern4.play;
~pattern5.play;
~tapepat.play;
~tapepat2.play;
~tapepat3.play;
)
~s2[13].play;

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

/* --- SYNTH: s --- */
SynthDef(\s, {
  arg out=0, amp=1.0,
  atk=1, sus=1, rel=1, pan=0;
  var env, sig, f1, f2;
    
  f1 = In.kr(~finger1,3);
  f2 = In.kr(~finger2,3);

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);

  // Signal
  sig = SinOsc.ar([110 * f1[1].range(1,2), 112 * f2[1].range(1,2)]) ;
  sig = Pan2.ar(sig, f1[0].range(-1,1));
  sig = sig * env * amp;
  Out.ar(out, sig )
}).add;

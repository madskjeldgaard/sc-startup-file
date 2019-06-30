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
s.boot;
)

~audiobus = Bus.audio(s, 2); // 2 channel audio bus

/* --- SYNTH: output --- */
SynthDef(\output, {
  arg out=0, amp=1.0,
  atk=0.1, sus=0.1, rel=0.1, eBus;
  var env, sig;

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), gate: Dust.kr(1));

  // Signal
  sig = LFTri.ar([110, 112]) ;
  sig = Splay.ar(sig);
    sig = sig*env*amp;


  Out.ar(eBus, sig);
  Out.ar(out, sig)
}).add;

/* --- SYNTH: effect --- */
SynthDef(\effect, {
  arg out=0, amp=1.0,
  atk=1, sus=1, rel=1, inBus;
  var env, sig, in;

  // Signal
  in = In.ar(inBus, 1);
  sig = Greyhole.ar(in, 
    delayTime: 2, 
    damp: 0, //  0 is no damping, 1 is very strong damping (0..1)
    size: 1, // Values below 1 can sound metallic. (0.5..5) 
    diff: 0.707, // controls pattern of echoes produced by the diffuser. 
    feedback: 0.9, 
    modDepth: 0.1, // (0..1) 
    modFreq: 2 // (0..10) 
  );
  sig = Splay.ar(sig);

  Out.ar(out, sig * amp)
}).add;

(
y = Synth.new(\effect, [\inbus, ~audiobus]); 
x = Synth.new(\output, [\eBus, ~audiobus]); 
)

/* --- SYNTH: hej --- */
SynthDef(\hej, {
  arg out=0, amp=1.0,
  atk=1, sus=1, rel=1;
  var env, sig;

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);

  // Signal
  sig = whatup ;
  p


  sig = Splay.ar(sig);

  Out.ar(out, sig * env * amp)
}).add;

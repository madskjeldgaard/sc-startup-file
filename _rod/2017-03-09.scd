g = ServerOptionsGui(s);
s.reboot;

(
/*** Batch load samples for celloSamples ***/
~celloSamples = Array.new; 

~folder =
PathName.new("/Users/madskjeldgaard/Desktop/Projekter/SOUL/samples/stereo/cello");

~folder.entries.do({
  arg path;
  ~celloSamples = ~celloSamples.add(Buffer.read(s, path.fullPath));
});
)

/*** Synth Definition: samplePlayerStereo ***/
SynthDef(\samplePlayerStereo, {
  arg out=0, amp=1.0,
  atk=1, sus=0, rel=1,
  buffer, rate=1.0, trig=1, start=0,
  warpFreq=4,
  loop=0, freqScale=1;
  var env, sig, pointer;

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);

  pointer = LFTri.kr(warpFreq).range(0,1);

  // Signal
  sig = Warp1.ar(numChannels: 2, bufnum: buffer, pointer: pointer, 
      freqScale: freqScale, windowSize: 1.0, envbufnum: -1, 
      overlaps: 8, windowRandRatio: 0, interp: 1);

  sig = Splay.ar(sig);

  Out.ar(out, sig)
}).add;

/*** Pattern cellopat1 for samplePlayer synth ***/
~cellopat1 = Pbind(
  \instrument, \samplePlayerStereo, 
  \buffer, ~celloSamples[10],
  \warpFreq, 1.25,
  \amp, 1.0,
  \freqScale, Pseq([2.0, 2.75, 2.5], inf),
  \dur, Pseq([6,6,6,6], 3),
  \rel, Pkey(\dur)/3,
  \atk, Pkey(\dur)/3,
  \sus, Pkey(\dur)/3,
  \pfunc, Pfunc({"%: cellopat1 is playing samplePlayer synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);

~cellopat1.play;

/* --- SYNTH: sampleWarper --- */
SynthDef(\sampleWarper, {
  arg buffer, out = 0, amp = 1.0, 
  warpFreq=4, freqScale = 0.5, grainSize = 0.25,
  overlaps = 8, ran = 0.0, 
  atk=1, sus=1, rel=1;    
  var sig, pointer, env;

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);

  // This oscillator will browse through the buffer
  pointer = Saw.kr(warpFreq).range(0,1);

  // This is the warping algorithm
  sig = Warp1.ar(2, buffer, pointer, freqScale, grainSize, -1, overlaps, ran);

  Out.ar(out, sig * amp * env);
}).add;

/* --- SYNTH: samplePlayerHello --- */
SynthDef(\samplePlayerHello, {
  arg buffer, out = 0, amp = 1.0, 
  rate=1, trig=1, start=0, loop=0,
  atk=1, sus=1, rel=1;    

  var sig, env;

  // Envelope
  env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);

  // Signal: Play buffer 
  sig = PlayBuf.ar(numChannels:, buffer, BufRateScale.kr(buffer) * rate, 
  trig, start, loop, doneAction:0);

  Out.ar(out, sig * amp * env);
}).add;

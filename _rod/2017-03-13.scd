(

// physical model of resonating spring
// Physical model of bouncing object  
// models the impacts of a bouncing object that is reflected by a vibrating surface
{
    // Waveguide mesh physical models of drum membranes
    MembraneHexagon.ar(DFM1.ar(WhiteNoise.ar().range(0, 1) * Saw.kr(0.05).range(0, 1)), tension: 0.01)!2 * 0.02 * Saw.kr(0.05)
}.play;
)


/* --- SYNTH: zenDrum --- */
SynthDef(\zenDrum1, {
  arg out=0, amp=0.5,
  atk=0, sus=0.5, rel=5, freq=250, res=0.1, 
  floatingThoughts = 0.05, tension=4,
  pan=0;
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
  Out.ar(out, sig )
}).add;

x = Synth(\zenDrum1, [\freq, 200, \tension, 1.25, \pan, 1.0 ]);

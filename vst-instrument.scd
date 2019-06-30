// Cmd + .
(
SynthDef.new(\vsti, {arg out = 0;
    // VST instruments usually don't have inputs
    Out.ar(out, VSTPlugin.ar(nil, 2));
}).add;
)

// create Synth with VST instrument
~vsti = VSTPluginController(Synth(\vsti));
// open plugin
~vsti.gui;
// or if you want the VST editor:
~vsti.open("/plugin/path", editor: true);

// play the instrument with a \midi Pbind
(
p = Pbind(
    \type, \midi,
    \midiout, ~vsti.midi, // set the midi target
    \chan, 0,
    \degree, Pwhite(0, 12, inf),
    \dur, Prand(#[0.125, 0.25, 0.5, 1], inf),
    \legato, Pexprand(0.5, 1.0, inf),
    \amp, Pexprand(0.5, 1.0, inf)
).play(quant: 1);
)

// change programs
~vsti.program_(1);

p.stop;

~vsti.numParameters.do{|paramnum| ~vsti.set(paramnum, 0.0.rrand(1.0))};

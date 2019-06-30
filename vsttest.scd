VSTPlugin.search

VSTPluginGui.gui
VSTPlugin.pluginKeys.do{|k| k.postln}


(
// a simple insert FX:
SynthDef.new(\insert, {arg bus = 0;
    ReplaceOut.ar(bus, VSTPlugin.ar(In.ar(bus, 2), 2));
}).add;
)
​
(
// create 2 VSTPlugins
~fx1 = VSTPluginController(Synth(\insert));
~fx2 = VSTPluginController(Synth(\insert));
)
​
// show each GUI in its own window
~fx1.gui;
~fx2.gui;
​
// close the windows


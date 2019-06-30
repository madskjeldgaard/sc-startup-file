(
// Setup
s.waitForBoot{
	k = MKtl('k', "korg-nanokontrol2");
	l = MKtl('l', "akai-lpd8");
	m = KModules.new;
	b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
};
)

(
var modules = m['fx']['spectral'].asArray;
var resetButtons = {
	8.do{|col|
		k.elAt('bt', 'S', col).value_(1);
		k.elAt('bt', 'R', col).value_(0);
		k.elAt('bt', 'M', col).value_(0);
	}
};

resetButtons.();

// S buttons
8.do{|col|
	k.elAt('bt', 'S', col).action = {|el|
		v.col[col].mode = 0;

		el.value_(1);
		k.elAt('bt', 'R', col).value_(0);
		k.elAt('bt', 'M', col).value_(0);
	}
};
// M buttons
8.do{|col|
	k.elAt('bt', 'M', col).action = {|el|
		v.col[col].mode = 1;

		el.value_(1);
		k.elAt('bt', 'S', col).value_(0);
		k.elAt('bt', 'R', col).value_(0);
	}
};

// R buttons
8.do{|col|
	k.elAt('bt', 'R', col).action = {|el|
		v.col[col].mode = 2;

		el.value_(1);
		k.elAt('bt', 'S', col).value_(0);
		k.elAt('bt', 'M', col).value_(0);
	}
};

// Values
v = ();
v.col = ()!8;
v.col.collect{|k| k.moduleChoice = 0};
v.col.collect{|k| k.mode = 0};

// Set the source sound
Ndef(\source, m['src']['bufplayer1']).set(\buffer, b, \rate, 0.125);
Ndef(\source).fadeTime = 0.1;

// Set up lfo's
8.do{|lfonum|
	Ndef(("lfo" ++ lfonum).asSymbol, {|f=1, crossfade=0|
		var noiseFunc = [LFNoise0, LFNoise1, LFNoise2].choose;
		XFade2.kr(DC.kr(1),noiseFunc.kr(f*10).abs, crossfade.linlin(0.0,1.0,-1.0,1.0))
	})
};

// Transport
k.elAt('tr', 'play').action = {|el| Ndef(\source).play};
k.elAt('tr', 'stop').action = {|el| Ndef(\source).stop};

// Knobs: Change fx
8.do{|knobnum|
	k.elAt('kn', knobnum).action = {|el|

		var choice = el.value.linlin(0.0, 1.0, 0, modules.size-1).asInt;

		v.col[knobnum].mode.switch(
			// S
			0, {
				if (choice != v.col[knobnum].moduleChoice){
					Ndef(\source)[knobnum+1] = \kfilter -> modules[choice];
					v.col[knobnum].moduleChoice = choice;
					v.col[knobnum].moduleArgs = modules[choice].argNames.reject{|a| a == \in};
				}
			},
			// M
			1, {
				// Get all even numbers of args
				var args = v.col[knobnum].moduleArgs.select{|n, i| i.even};

				"Setting args % to %".format(args, el.value).postln;

				args.do{|a|
					Ndef(\source).set(a.asSymbol ++ (knobnum+1), el.value);
				};

			},
			// R
			2, {
				/*
				var args = Ndef(\source)[0].argNames.reject{|a|a == \buffer}.reject{|a|a == \interpolation};
				args = args.select{|n, i| i.even};

				"Setting args % to %".format(args, el.value).postln;

				args.do{|a|
				Ndef(\source).set(a.asSymbol, el.value);
				};*/

				Ndef(("lfo" ++ knobnum).asSymbol).set(\f, el.value);

			}

		);

		// modules[choice].argNames.postln;
	};
};

// Sliders: Wet/dry
8.do{|slidernum|
	k.elAt('sl', slidernum).action = {|el|

		v.col[slidernum].mode.switch(
			// S
			0, {
				var sym = ("wet" ++ (slidernum+1)).asSymbol;
				Ndef(\source).set(sym, el.value);

			},
			// M
			1, {
				// Get all uneven numbers of args
				var args = v.col[slidernum].moduleArgs.select{|n, i| i.even.not};
				"Setting args % to %".format(args, el.value).postln;

				args.do{|a|
					Ndef(\source).set(a.asSymbol ++ (slidernum+1), el.value);
				};

			},
			// R
			2, {
				/*
				var args = Ndef(\source)[0].argNames.reject{|a|a == \buffer}.reject{|a|a == \interpolation};

				args = args.select{|n, i| i.even.not};

				"Setting args % to %".format(args, el.value).postln;

				args.do{|a|
				Ndef(\source).set(a.asSymbol, el.value);
				};*/

				Ndef(("lfo" ++ slidernum).asSymbol).set(\crossfade, el.value);

			}

		);

	}
};

)


(

Ndef(\lfo0).scope
Ndef(\lfo0).gui
)


Noise.allSubclasses.select{|c| c.asString.contains("LFNoise")}.postln
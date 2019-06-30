(
	// Sound source for testing
	Ndef(\addy, {|f1,f2,f3,f4,f5,a1,a2,a3,a4,a5,w=1|
		var freqs = [f1,f2,f3,f4,f5].collect{|f| f.exprange(20,12000)};
		var sig = VarSaw.ar(freqs, 0, w, [a1,a2,a3,a4,a5]) / 10;
		Splay.ar(sig);
	});

	// Make some control rate Ndefs (lfos)
	10.do{|i| 
		var name = ("lll" ++ i).asSymbol;

		Ndef(name)
			.source_({|f| SinOsc.kr(f)})
			.set(\f, exprand(0.0001,10.0));
	};

	// Make a list of all Ndefs named in a certain way
	~findAllNdefsContaining = { |stringInName="lll"|
		var found = [];

		Ndef.all.localhost.keysValuesDo{|k,ndef| 
			var ndname = ndef.key.asString;

			if(ndname.contains(stringInName), {
				found = found.add(ndef);
			});

		};

		found
	};

	// Gather all lfos in a list
	~lfos = ~findAllNdefsContaining.value("lll").postln;

	// Randomly map Ndefs to one Ndefs parameters
	~randomMap = { |name='src', lfolist, scram=true|
		// The Ndef 
		var nd = Ndef(name);

		// Get names of all controls
		var ctrls = nd.controlKeys;

		// Randomize control order
		scram.if(ctrls = ctrls.scramble);

		// Map lfos to controls
		[lfolist, ctrls].flopWith{ |lfo, param|

			"Mapping % to %".format(lfo.key, param).postln;

			nd.map(param, lfo);	

		};
	};

	~randomMap.value('addy', ~lfos);
)

Ndef(\addy).play;
Ndef(\addy).gui;

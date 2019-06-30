/*

ndef-functions.scd
2019-06-30
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/

/*

FUNCTIONS 

*/
(
	/*

	RANDOMIZE NDEF PARAMETERS

	*/

	~randomizeNdefParameters = { |name='lll1', randmin=0.0, randmax=1.0|
		var nd = Ndef(name);
		var params = nd.controlKeys;

		params.do{|param|
			nd.set(param, rrand(randmin, randmax))
		}
	};

	/*

	MAKE A LIST OF ALL NDEFS CONTAINING STRING IN NAME

	A nice way to gather all ndefs named using a certain convention, for
	example with names containing the word "lfo" 

	*/

	~findAllNdefs = { |searchName="lll"|
		var found = [];

		Ndef.all.localhost.keysValuesDo{|k,ndef| 
			var ndname = ndef.key.asString;

			if(ndname.contains(searchName), {
				found = found.add(ndef);
			});

		};

		found
	};

	/*

	RANDOMIZE ALL NDEFS WITH NAME

	Combines the find and randomize functions from above
	
	*/

	~randomizeAllNdefsWithName = { |searchName="lll"| 
		var ndefs = ~findAllNdefs.value(searchName);	

		ndefs.do{|n|
			~randomizeNdefParameters.value(n)
		}
	};
	/*

	RANDOMLY MAP A BUNCH OF NDEFS TO ONE NDEF'S PARAMETERS

	*/

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

	/*

	NDEF + CALLBACK FUNCTION

	This takes a control rate function (an lfo of some sort for example) and puts it in an Ndef.

	It automatically extracts the output of the Ndef and passes the value to a callback function.

	This is useful if you want to do something with Ndef output in the language
	side of things, eg. trigger functions/tasks/routines.
	*/

	~makeNdefWithCallback = {|name="crazylfo", ndeffunc, callbackfunc|
		var oscPath = "/%".format(name).asSymbol;

		Ndef(name).source = {|sendRate=10|
			var sig = SynthDef.wrap(ndeffunc);
			SendReply.kr(Impulse.kr(sendRate), oscPath, sig);
			sig
		};

		OSCdef(name, {|msg, time, addr, recvPort|
			var val = msg[3];
			callbackfunc.value(val);
		},  oscPath)
	};
)
/*

EXAMPLES

*/
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
		.source_({|f| SinOsc.kr(f).range(0.0,1.0)})
		.set(\f, exprand(0.0001,10.0));
	};

	// Gather all lfos in a list
	~lfos = ~findAllNdefsContaining.value("lll").postln;
	~randomMap.value('soundsource1', ~lfos);
)

Ndef(\hello, {|f,a,e,b| f.poll; a.poll; e.poll; b.poll});

~randomizeNdefParameters.value('hello')

Array

/*

startup.scd
2019-02-18
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/

"Loading startup file".postt;

p = Particular.new;
k = KModules.new;

/************************************

VSTs

*************************************/

s.doWhenBooted{
    VSTPlugin.search();
};

(1..64).do{|numchans|
    SynthDef("vst" ++ numchans, { arg bus;
        ReplaceOut.ar(bus, VSTPlugin.ar(In.ar(bus, numchans), numchans));  
    }).add;
};

/************************************

flood post window

*************************************/


~flood = {|text|

    100.do{ 
        50.do{text.post};
        "".postln;
    }
};

/************************************

PANNER

*************************************/


SynthDef.new(\panner,
    {|out, pan=0.5, gate=1|
        var env = Linen.kr(gate, 0.05, 1, 0.4, 2);  
        var in = In.ar(out, 1);
        var sig = Pan2.ar(in, pan.linlin(0.0,1.0,-1.0,1.0));
        XOut.ar(out, env, sig)
    }
).add;


/************************************

SETTINGS

*************************************/
// increase this if you are getting drop outs and the message "too many nodes"
s.options.maxNodes = 1024 * 128;

// Allocate memory
s.options.memSize = 2.pow(20);

s.options.numAudioBusChannels = 4048;

// Increase number of buffers available
s.options.numBuffers = 1024 * 32;

// Where to put recordings
thisProcess.platform.recordingsDir = "/Users/madskjeldgaard/Dropbox/_sound_archive/_sc_sessions/";

// Which format to use
s.recHeaderFormat = "wav";

/************************************

	Nice default synth defs

*************************************/

SynthDef.new(\saw, {|out=0, freq=442, atk=0.01, rel=0.99, width=0.3, dur=1, amp=1, pan=0.5|
	var env = EnvGen.kr(Env.perc(atk, rel), gate: 1, timeScale: dur,  doneAction: 2);
	var sig = VarSaw.ar(freq, 0, width: width, mul: env);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, amp * sig);
}).add;

/************************************

BUFPLAYER + RECORDER

*************************************/

// Make buffer player synth defs for 1-64 channel buffers
// And set bufplayer1 as default synthdef
(
		~ctkSynths = ();

		~defaultbuf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

		// Function for buffer player synth defs
		~bufplayerfunc = {|numchans=1|
			{|rate=1, buffer, trigger=1, start=0, loop=0, atk=0.1, sus=0.8, rel=0.1, curve=10, dur=1, amp=1, out=0|
				var env = EnvGen.kr(Env.linen(atk, sus, rel, 1, curve),  gate: 1.0,  levelScale: amp,  levelBias: 0.0, timeScale:dur,  doneAction: 2);
				var sig = PlayBuf.ar(numchans, buffer, rate * BufRateScale.kr(buffer),  trigger,  start * BufDur.kr(buffer),  loop);

				Out.ar(out, sig * env);
			}
		};

		[SynthDef, CtkSynthDef].do{|which|
			(1..64).do{|chanNum|
				var name = "bufplayer" ++ chanNum.asString;

				switch(which,
					SynthDef, { which.new(name, ~bufplayerfunc.value(chanNum)).add },
					CtkSynthDef, { ~ctkSynths[name.asSymbol] = which.new(name, ~bufplayerfunc.value(chanNum)) }
				);
			};
		};

		// Set default SynthDef as mono buffer player
		SynthDef(\default, ~bufplayerfunc.value(1)).add;

		// Buf recorder function
		~bufrecorderfunc = {|numchans=1|
			{|in, buffer, offset=0, reclvl=1, prelvl=0, run=1, loop=0, trigger=1|
				RecordBuf.ar(In.ar(in, numchans).tanh.poll, buffer, offset, reclvl, prelvl, run, loop, trigger, doneAction:2);
			}
		};

		[SynthDef, CtkSynthDef].do{|which|
			(1..64).do{|chanNum|
				var name="bufrecorder" ++ chanNum.asString;

				switch(which,
					SynthDef, { which.new(name, ~bufrecorderfunc.value(chanNum)).add },
					CtkSynthDef, { ~ctkSynths[name.asSymbol] = which.new(name, ~bufrecorderfunc.value(chanNum)) }
				);
			};
		};

		// Test bufrecorder:
		// (
		//	b = Buffer.alloc(s, 44100 * 1,  numChannels: 1);
		//	a = Bus.audio(s,  numChannels: 1);
		//	{Out.ar(a, SinOsc.ar(LFNoise2.kr(100)*1000))}.play;
		//	Synth.tail(1, \bufrecorder1, [\buffer, b, \in, a]);
		// )

	/************************************

	CHOOSE IN / OUT DEVICE

	*************************************/

	// Choose in / out device via functions (used with vim key bindings)
	~chooseOutDev = {|choice=0|
		choice = ServerOptions.outDevices[choice];
		"Setting out device to: %".format(choice).postt;
		s.options.outDevice = choice;
	};

	~chooseInDev = {|choice=0|
		choice = ServerOptions.inDevices[choice];
		"Setting in device to: %".format(choice).postt;
		s.options.inDevice = choice;
	};

	/************************************

	KEY BUF

	*************************************/

	// This is used with vim key bindings: When pressing a key, this function is called
	// It records the input of the sound card to a buffer for a few secons

	s.doWhenBooted{
		b = ();
		~recTime = 2;

		// Create buffers
		~keyBufs = 8.collect{
			Buffer.alloc(s, s.sampleRate * ~recTime)
		};

		// Record function
		~keyBufRecorder = {|keyBufNumber=0|
			{0.0 * RecordBuf.ar(SoundIn.ar(0), ~keyBufs[keyBufNumber],  loop: 0.0, doneAction: 2)}.play
		};

		// Buffer recorder for keyboard
		~keyBufRout = {|keyBufNumber=0|
			Routine({
				"Recording to buffer in ~keyBufs[%] in 3 sec".format(keyBufNumber).postt;
				1.wait;
				"3".postt;
				1.wait;
				"2".postt;
				1.wait;
				"1".postt;
				1.wait;
				"RECORDING".postt;
				~keyBufRecorder.value(keyBufNumber);
				2.wait;
				~keyBufs=~keyBufs.collect{|k| k.normalize};
			}).play
		};
	};
)


/*

startup.scd
2019-02-18
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/

"Loading startup file".postt;
/************************************

BUFPLAYER

*************************************/
(
s.doWhenBooted{
	~defaultbuf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

	// Function for buffer player synth defs
	~bufplayerfunc = {|numchans=0|
		{|rate=1, buffer, trigger=1, start=0, loop=0, atk=0.1, sus=0.8, rel=0.1, curve=10, dur=1, amp=1, out=0|
			var env = EnvGen.kr(Env.linen(atk, sus, rel, 1, curve),  gate: 1.0,  levelScale: amp,  levelBias: 0.0, timeScale:dur,  doneAction: 2);
			var sig = PlayBuf.ar(numchans, buffer, rate * BufRateScale.kr(buffer),  trigger,  start * BufDur.kr(buffer),  loop);

			Out.ar(out, sig);
		}
	};

	// Make buffer player synth defs for 1-64 channel buffers
	64.do{|chanNum|
		chanNum=chanNum+1;

		SynthDef.new("bufplayer" ++ chanNum.asString,
			~bufplayerfunc.value(chanNum)
		).add;
	};

	// Set default SynthDef as mono buffer player
	SynthDef(\default, ~bufplayerfunc.value(1)).add;


};

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


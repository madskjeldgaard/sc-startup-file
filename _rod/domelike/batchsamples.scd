/***************************

LOAD FOLDER OF SAMPLES

****************************/
s.reboot;
s.unmute;
// To see the limit of buffers on server:
// s.options.numBuffers;
// To set new limit on buffers on server and then reboot:
s.options.numBuffers = 2000; s.reboot;
(
// Creat array for sounds
~sounds = Array.new;

// Set up path name to folder containing samples
~folder = PathName.new("/Users/madskjeldgaard/Desktop/Samples/algosamples/fjeder");

// Iterate over all sound files in folder and load them to buffers
~folder.entries.do({
	arg path;
	~sounds = ~sounds.add(Buffer.read(s, path.fullPath));

});

// Array of buffers is now in ~sounds;
// Accessable eg like this ~sounds[10].play;

//~sounds[10].play;
)

/*** Define synth to play samples ***/
(
SynthDef.new(\monoSamplePlay, {
	arg buf, amp = 1, out = 1, panrate=1.0, loop = 0, rate, channels = 1;
	var sig; // Signal
    var start = LFNoise0.kr(2).range(0.0, 1.0);
    //rate = XLine.kr(0.0,1.0,1);
	sig = PlayBuf.ar(1, buf, rate*BufRateScale.ir(buf), loop, startPos: start, doneAction:2);
	Out.ar(out, sig);

}).add;
)

// Create synth from above to play sounds
x = Synth.new(\monoSamplePlay, [\buf, ~sounds.choose, \loop, 0]);
x.play;

/*

Audio Spray Gun 0.8.0

A system to generate and spatialise large groups of sound-events from a single mono soundfile.

ASG08_init.scd
================

Initialisation program

To run this program, place the cursor anywhere within the main body of the program
Then type cmd-return.

Select audio interface, sample rate, speaker configuration etc. for your system and press "Boot".

For more information, see the acompanying pdf

*************************************************************************************************************
*                                             WARNING                                                       *
* Audio Spray Gun can play very large numbers of samples simultaneously, resulting in high sound pressures. *
* Please protect your ears and your speakers by experimenting at low playback levels.                       *
*                                                                                                           *
*************************************************************************************************************

Richard Garrett
richard@sundaydance.co.uk
June 13th 2015


*/

(

var win        = Window.new("Initialise SuperCollider");
var deviceList = ServerOptions.outDevices;
var device, instrument, channels, sampleRate, vbapArray, presetMenu;

var presets = [
	(label: "stereo", instr: 0, chans: 2, rate: 48000, vbap: "none"),
	(label: "4.0", instr: 1, chans: 4, rate: 48000, vbap: "2, [-45, 45, -135, 135]"),
	(label: "5.1", instr: 1, chans: 5, rate: 48000, vbap: "2, [-30, 30, 0, -110, 110 ]"),
	(label: "8.0 circle", instr: 1, chans: 8, rate: 48000, vbap: "2, [-22.5, 22.5, 67.5, 112.5, 157.5, -157.5, -112.5, -67.5]"),
	(label: "8.0 4x2", instr: 1, chans: 8, rate: 48000, vbap: "2, [-22.5, 22.5, -67.5, 67.5, -112.5, 112.5, -157.5, 157.5]"),
	(label: "16.0 (lower: 4x2, upper: offset pi/16)", instr: 1, chans: 16, rate: 48000,
		vbap: "3, [[-22.5, 0], [22.5, 0], [-67.5, 0], [67.5, 0], [-112.5, 0], [112.5, 0], [-157.5, 0], [157.5, 0],[-45, 30],[45, 30], [-90, 30], [90, 30], [-135, 30],[135, 30], [180, 30], [0, 30]]"),
	(label: "BEAST Dome", instr: 1, chans: 20, rate: 48000,
		vbap: "3, [[-45, 0], [45, 0], [-90, 0], [90, 0], [-135, 0], [135, 0], [0, 0], [180, 0],[-22.5, 35.26],[22.5, 35.26], [-67.5, 35.26], [67.5, 35.26], [-112.5, 35.26],[112.5, 35.26], [-157.5, 35.26], [157.5, 35.26],[-45, 60], [45, 60], [-135, 60], [135, 60]]")
];

var presetLabels = Array.fill(presets.size, {|i| presets[i].label;});

var getPresets   = {arg val;

	var preset = presets[val];

	instrument.value = preset.instr;
	channels.value   = preset.chans;
	sampleRate.value = preset.rate;
	vbapArray.string = preset.vbap;
};

var writeAndBoot = {|server, action|
	var array;

	~serverOptions            = server.options;
	if(device.value == 0, {~serverOptions.device = nil;}, {~serverOptions.device = device.item;});

	//~serverOptions.device     = if(device.value == 0, {nil;}, {device.item;});
	~serverOptions.sampleRate = sampleRate.value;

	~vbapChannels = channels.value.asInteger;
	~serverOptions.numOutputBusChannels = if(~vbapChannels<8,{8;},{~vbapChannels;});


	~instrument = [\oneShot, \oneShotV].at(instrument.value);

	if(instrument.value !=0, {
		array = ("[" ++ vbapArray.string ++ "]").interpret;
		~speakerArray = VBAPSpeakerArray.new(array[0], array[1]);
	});

	server.reboot;

	server.waitForBoot(action);

	win.close;
};

var thisFolder = PathName(thisProcess.nowExecutingPath).pathOnly;

(thisFolder ++ "ASG08_library.scd").loadPaths;

presetMenu  = ~labelledMenu.(win, 10, 10, 300, label: "presets", params: presetLabels,
	action: {|menu| getPresets.(menu.value);});
device      = ~labelledMenu.(win, 10, 50, 200, label: "device", params: deviceList);
instrument  = ~labelledMenu.(win, 10, 90, 200, label: "instrument", params: ["stereo", "VBAP"]);
channels    = NumberBox(win, Rect(90, 130, 48, 20))
	.value_(2)
	.align_(\center);

StaticText(win, Rect(10,130, 88, 20)).string_("channels");

sampleRate    = NumberBox(win, Rect(230, 130, 60, 20))
	.value_(48000)
	.align_(\center);

StaticText(win, Rect(140,130, 88, 20)).string_("sample rate");
StaticText(win, Rect(10,152, 88, 20)).string_("VBAP array");

vbapArray = TextView(win, Rect(10, 172, 380, 100));

presetMenu.valueAction_(0);

~bang.(win, Rect(100, 300, 90, 28), "Boot",{
	writeAndBoot.(Server.local, {
		~recordBuffer = Buffer.alloc(s, 65536, ~vbapChannels);
		("loading ASG 0.8.0...").postln;
		(thisFolder ++ "AudioSprayGun_08.scd").load;
	});
});

win.front;
)

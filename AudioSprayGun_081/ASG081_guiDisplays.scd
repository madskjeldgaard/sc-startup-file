// === ASG08_guiDisplays.scd ====

/*

Audio Spray Gun 0.8.1 - guiDisplays

A system to generate and spatialise large groups of sound-events from a single mono soundfile.

builds GUI for Audio Spray Gun

For more information, see the accompanying pdf

*************************************************************************************************************
*                                             WARNING                                                       *
* Audio Spray Gun can play very large numbers of samples simultaneously, resulting in high sound pressures. *
* Please protect your ears and your speakers by experimenting at low playback levels.                       *
*                                                                                                           *
*************************************************************************************************************

To run ASG, open ASG081_init.scd and follow the instructions

Richard Garrett
richard@sundaydance.co.uk
September 10th 2015


CONTENTS

   1.     ~funcGenFactory: Makes function Generators for ASG.
   2.     ~makeParamWindow: Makes parameter window containing function generators.
   3.     ~buildDisplayPanel
   4.     ~buildMasterView
   4.1     loadParameters: load routine for master panel- includes backwards compatability for old file formats
   4.2     loadTxt: load txt files from fileversion 0.1, 0.2
   4.2.1   convert01: convert funcGen data from txt format 0.1
   4.2.2   convert02: convert funcGen data from txt format 0.2
   4.3     ~reset: disable write, replay buttons when no eventArray present (e.g. after New/ Load)
   5.      ~writePanel: Pop up panel called by master function "Write".
   6.      ~buildViews: builds three main windows

*/

(

var loadParameters, loadTxt, convert01, convert02;

/*

   1. ~funcGenFactory: Makes function Generators for ASG.
   ======================================================

INPUT:

window:       parent window
startPoint:   point(x,y) - top left hand corner of func gen within window
label:        name of parameter for which function will be generated

OUTPUT:

<Event>       object model of a function generator


*/

~funcGenFactory = {arg window, startPoint, label;

	var sliders = ~sliders;
	var predicates = Array.series(sliders,0, 1/sliders);
	var consequents = Array.fill(sliders,0);
	var add=0, mult=1, menuVal = 0;

	var presetArray = [
	["zero line", Array.fill(sliders, 0)],
	["slope", Array.series(sliders,0,1/sliders)],
	["sine (1/4)", Array.fill(sliders, {arg i; (i*pi/(2*sliders)).sin})],
	["cos (1/2)", Array.fill(sliders, {arg i; 0.5*(1+(i*pi/(sliders)).cos)})],
	["squared", Array.fill(sliders, {arg i; (i/sliders).squared;})],
	["cubed", Array.fill(sliders, {arg i; (i/sliders).cubed})],
	["sine (1/2)", Array.fill(sliders, {arg i; (i*pi/(sliders)).sin})],
	["cos (1)", Array.fill(sliders, {arg i; 0.5*(1+(i*2*pi/(sliders)).cos)})],
	["sawtooth 2", Array.fill(sliders, {arg i; (2*i/sliders).frac})],
	["sawtooth 3", Array.fill(sliders, {arg i; (3*i/sliders).frac})],
	["sawtooth 4", Array.fill(sliders, {arg i; (4*i/sliders).frac})],
	["offsetSaw 1", Array.fill(sliders, {arg i; ((i/sliders)+0.5).frac})],
	["offsetSaw 2", Array.fill(sliders, {arg i; ((2*i/sliders)+0.5).frac})],
	["offsetSaw 3", Array.fill(sliders, {arg i; ((3*i/sliders)+0.5).frac})],
	["offsetSaw 4", Array.fill(sliders, {arg i; ((4*i/sliders)+0.5).frac})],
	["teardrop", Array.fill(sliders, {arg i;
			var golden = sliders*0.618;
			if(i<=golden, {((i/golden)*(pi/2)).sin},{((1+((i-golden)/(sliders-golden)))*(pi/2)).sin});
		})],
	["slowCentre", Array.fill(sliders, {arg i;
			var x = i/sliders;
			0.5*(1 + (1 - (2*x)).cubed);
		})]
];

	var compView= CompositeView(window, Rect(startPoint.x,startPoint.y, 366, 100));

	var mSlider = ~mSlider.(compView, 10, 0, sliders, labelled: true, label: label);
	var addBox  = ~labelledNumBox.(compView,216, 0,"add",add);
	var multBox = ~labelledNumBox.(compView,216, 40,"mult",mult);
	var menu    = ~labelledMenu.(compView, 265, 0, 100, 36, "mode", ["linear", "rand", "rand2", "linrand"], menuVal);
	var presets = ~presetControl.(compView,265,40, presets: presetArray, mSlider: mSlider);



// event definition
	(
		predicates: predicates,
		range: 1,
		mSlider: mSlider,
		addBox: addBox,
		multBox: multBox,
		menu: menu,
		defaults: [Array.fill(sliders,0), 0, 1.0, 0],

		// methods

		getFunction: {arg self;

			// pass current GUI object values to variables

			var consequents = self.mSlider.value;
			var randomMode  = self.menu.value;
			var add         = self.addBox.value;
			var mult        = self.multBox.value;

			var thisRule = ~ruleFactory.(self.range*self.predicates, consequents);

			// make randomised rule according to menu option

			var randomisedRule = [
				{arg val; thisRule.test(val);},
				{arg val; rand(thisRule.test(val));},
				{arg val; rand2(thisRule.test(val));},
				{arg val; linrand(thisRule.test(val));}
			].at(randomMode);

			// return function

			{arg val; add + (mult*randomisedRule.(val))};
		},

		getParams: {arg self;
			[
				self.mSlider.value.round(0.01),
				self.addBox.value,
				self.multBox.value,
				self.menu.value
			]
		},

		setParams: {arg self, paramArray;
			self.mSlider.value_(paramArray[0]);
			self.addBox.value_(paramArray[1]);
			self.multBox.value_(paramArray[2]);
			self.menu.value_(paramArray[3]);
		},

		restoreDefaults: {arg self;
			self.setParams(self.defaults);
		},

		setDefaults: {arg self, paramArray;
			self.defaults = paramArray;
		}
	);
};

/*

   2. ~makeParamWindow: Makes parameter window containing function generators.
   ============================================================================

Initialises function generators

INPUT:

win:       empty parameter window

OUTPUT:

win:       filled parameter window


*/

~makeParamWindow = {arg win;

	var initArray = Array.fill(~sliders,0);
	var defaultControlArray = [

		[0,500, 0],      //rho(centre)
		[0, 2, 0],       //theta(centre)
		[0, 1, 0],       //phi(centre)
		[1, 1, 0],       //spectral(centre)
		[0, 100, 0],     //spread(centre)
		[0.01, 0.04, 0], //delta (centre)

		[0, 20, 1],      //rho(event)
		[0, 1, 2],       //theta(event)
		[0, 0.2, 1],     //phi(event)
		[0, 1, 1],       //spectral(centre)
		[0, 10, 1],       //spread(event)
		[0, 0.01, 1]     //delta (event)
	];

	~rhoXCentreFuncGen      = ~funcGenFactory.(win, 0@0, "x/ rho(centre)");
	~thetaYCentreFuncGen    = ~funcGenFactory.(win, 0@100, "y/ theta(centre)");
	~phiZCentreFuncGen      = ~funcGenFactory.(win, 0@200, "z/ phi(centre)");
	~spectralCentreFuncGen  = ~funcGenFactory.(win, 0@300, "spectral(centre)");
	~spreadCentreFuncGen    = ~funcGenFactory.(win, 0@400, "spread(centre)");
	~deltaCentreFuncGen     = ~funcGenFactory.(win, 0@500, "delta (centre)");

	~rhoXEventFuncGen       = ~funcGenFactory.(win, 375@0, "x/ rho(event)");
	~thetaYEventFuncGen     = ~funcGenFactory.(win, 375@100, "y/ theta(event)");
	~phiZEventFuncGen       = ~funcGenFactory.(win, 375@200, "z/ phi(event)");
	~spectralEventFuncGen   = ~funcGenFactory.(win, 375@300, "spectral(event)");
	~spreadEventFuncGen     = ~funcGenFactory.(win, 375@400, "spread(event)");
	~deltaEventFuncGen      = ~funcGenFactory.(win, 375@500, "delta (event)");


	~funcGens = [
		~rhoXCentreFuncGen,
		~thetaYCentreFuncGen,
		~phiZCentreFuncGen,
		~spectralCentreFuncGen,
		~spreadCentreFuncGen,
		~deltaCentreFuncGen,

		~rhoXEventFuncGen,
		~thetaYEventFuncGen,
		~phiZEventFuncGen,
		~spectralEventFuncGen,
		~spreadEventFuncGen,
		~deltaEventFuncGen
	];

	~funcGens.do({arg item, i;
		var array = defaultControlArray[i];
		item.setDefaults(array.addFirst(initArray));
		item.restoreDefaults;
	});

	win;
};

/*

   3. ~buildDisplayPanel
   ======================

Display panel shows events from above
.drawFunc runs every time the window updaets during animation

INPUT:

window:         display window
startX, startY: inset values from edge of display window (default =1 10)

OUTPUT:

<UserView> of display panel


*/

~buildDisplayPanel = {arg window, startX=10, startY=10;

	var rule = {arg test, predicates, consequents; consequents.blendAt(predicates.indexInBetween(test));};

	UserView(window, window.view.bounds.insetBy(startX, startY))
	.background_(Color.white)
	.drawFunc = {arg me;

		var halfWidth = me.bounds.width/2;

		Pen.translate(halfWidth,halfWidth);
		Pen.scale((halfWidth/~rhoMax),(halfWidth/~rhoMax));

		Pen.color = Color.grey;
		// cross-hairs
		Pen.moveTo(~rhoMax @ 0); Pen.lineTo(~rhoMax.neg @ 0); Pen.stroke;
		Pen.moveTo(0 @ ~rhoMax); Pen.lineTo(0 @ ~rhoMax.neg); Pen.stroke;
		// circles
		Pen.strokeOval(Rect(~rhoMax.neg, ~rhoMax.neg,2*~rhoMax,2*~rhoMax));
		Pen.strokeOval(Rect((~rhoMax/2.neg), (~rhoMax/2).neg,~rhoMax,~rhoMax));

		window.name = format("display (radius: % metres)", ~rhoMax.round(1));


		~dispArray.do({arg item;

			var phiRange = [~phiMin, ~phiMin+((~phiMax - ~phiMin)/2), ~phiMax];

			Pen.fillColor = Color.new255(
				rule.(item.phi, phiRange, [255, 0, 0]).floor,  //red
				rule.(item.phi, phiRange, [0,255, 0]).floor,   //green
				rule.(item.phi, phiRange, [0, 0, 255]).floor,  //blue
				127
			);
			Pen.fillOval(Rect(item.x -(~rhoMax/60), item.y -(~rhoMax/60), ~rhoMax/30, ~rhoMax/30));
		});
	};
};

/*

   4.0 ~buildMasterView
   ====================


INPUT:

window:         master window
startX, startY: start values from edge of master window (default =1 10)
width, height

OUTPUT:

master event    <event> containg all master control settings for load/save/ main prog

*/

~buildMasterControl ={arg window, startX = 10, startY = 10, width = 742 , height = 140;

	var duration = 30.0, masterVol = 0.25, events =200, mode = 1;// defaults

	var compView = CompositeView(window, Rect(startX, startY, width, height));

	// newButton:    restore defaults, clear display

	var newButton  = ~bang.(compView, Rect(0, 25, 80, 28),"New", {
        ~reset.("", true, clearDisplay: true, init: true);
		}
	);

	// loadButton:  load parameter file, reset buttons

	var loadButton = ~bang.(compView, Rect(0, 55, 80, 28),"Open",
        {Dialog.openPanel({arg path;
			if (path.endsWith(".txt"), {loadTxt.(path)}, {loadParameters.(path);});},{});}
	);

	// saveButton: save Parameters to file

	var saveButton = ~bang.(compView, Rect(0, 85, 80, 28),"Save",
		{Dialog.savePanel({arg path;
			~writeArchiveFromObjectParams.(path, ~appHeader, [~master] ++ ~funcGens );
			~paramWindow.name = PathName.new(path).fileName;
		},{});}
	);

	// showButton:  bring panels to front

	var showButton = ~bang.(compView, Rect(467, 85, 80, 28),"Show",{~paramWindow.front; ~displayWindow.front;});

	// playButton: audition source

	var playButton = ~bang.(compView, Rect(692, 0, 48, 20),"source",{
		b = ~loadAudio.(b, ~master.filename); (instrument: \oneShot, bufnum: b, amp: 0.8).play;
	});

	~writeButton = ~bang.(compView, Rect(692, 25, 48, 88),"Write", {~writePanel.(~master);}).enabled = false;

	~goButton = ~toggle.(compView, Rect(550, 25, 88, 88), "Go","Abort",
		action1: {~initTask.(); ~buildGroup.start;},
		action0: {~buildGroup.stop; ~displayPanel.animate = false; ~reset.("stopped");}
	);

    ~replayButton = ~toggle.(compView, Rect(642, 25, 48, 88),"Play", "Stop",
        {~playEvents.stop;}, {~playEvents.start;},
        Color.green(0.4, 0.5), Color.green(0.8)
    ).enabled = false;

	~infoText = TextField(compView, Rect(0, 122, width, 20));

	(
		defaults:    (duration: 30.0, gain: 0.25, events: 200, mode: 1, filename: "drop audio file here", coords: 1),
		delayButton: ~toggle.(compView, Rect(467, 55, 80, 28),"Delay Off","Delay On",
			color0: Color.yellow(0.5, 0.5), color1: Color.yellow(0.8)).value_(0),
		modeButton:   ~toggle.(compView, Rect(467, 25, 80, 28),"Duration","Events").value_(mode),

		coordsMenu:  ~labelledMenu.(compView, 93, 25, 100, 36, "co-ordinates",
			["cartesian (xyz)", "Cylindrical", "Spherical"], 1,),

		dropFile:     DragSink(compView, Rect(0, 0, width - 52, 20))
		.align_(\left).string_("drop audio file here"),

		eventsKnob:   ~knobWithBox.(compView,  293, 22, "events", events, clipHi: 1300, decimals: 0),
		volumeKnob:   ~knobWithBox.(compView,  353, 22, "volume", masterVol),
		timeKnob:     ~knobWithBox.(compView,  233, 22, "dur (s)",duration, clipHi: 240, decimals: 0),


		delay:        {arg self; self.delayButton.value;},
		mode:         {arg self; self.modeButton.value;},
		filename:     {arg self; self.dropFile.value;},
		events:       {arg self; self.eventsKnob.value;},
		duration:     {arg self; self.timeKnob.value;},
		gain:         {arg self; self.volumeKnob.value;},
		coords:       {arg self; self.coordsMenu.value;},

		getParams:    {arg self;
			(
				delay:        self.delayButton.value,
				mode:         self.modeButton.value,
				filename:     self.dropFile.value,
				events:       self.eventsKnob.value,
				duration:     self.timeKnob.value,
				gain:         self.volumeKnob.value,
				coords:       self.coordsMenu.value,
			)
		},

		setParams:    {arg self, data;
			(
				self.dropFile.value         = data.filename;
				self.timeKnob.valueAction   = data.duration;
				self.volumeKnob.valueAction = data.gain;
				self.eventsKnob.valueAction = data.events;
				self.delayButton.value      = data.delay;
				self.modeButton.value       = data.mode;
				self.coordsMenu.value       = data.coords;
			)
		},

		restoreDefaults: {arg self;
			self.setParams(self.defaults);
		}
	);


};

/*   4.1  loadParameters: load routine for master panel- includes backwards compatability for old file formats
     ==========================================================================================================
*/

loadParameters = {|path|

    var objectFromFile = Object.readArchive(path);
    var funcGens03    = [
        ~rhoXCentreFuncGen, ~thetaYCentreFuncGen, ~phiZCentreFuncGen,
        ~spectralCentreFuncGen, ~spreadCentreFuncGen, ~deltaCentreFuncGen,
        ~rhoXEventFuncGen, ~thetaYEventFuncGen, ~phiZEventFuncGen,
        ~spectralEventFuncGen, ~spreadCentreFuncGen
    ];

    if (~isParamFile.(objectFromFile.header, ~appHeader), {
        var fileVersion = objectFromFile.header.fileVersion.asFloat;
        var targetObjects = switch(fileVersion,
            0.3,    {[~master] ++ funcGens03},
            0.4,    {[~master] ++ ~funcGens},
            {"not supported"}
        );

        if (targetObjects != "not supported", {
            ~readArchiveToObjectParams.(path, targetObjects);
            ~reset.("", true, PathName.new(path).fileName);
            },
            {
                ~infoText.value_("LOAD FAILED: file version not supported");
        });
        },
        {
            ~infoText.value_("LOAD FAILED: not an ASG parameter file");
    });

};

/*   4.2 loadTxt: load txt files from fileversion 0.1, 0.2
    =======================================================
*/

loadTxt = {|path|
	var data = SemiColonFileReader.read(path, true);
	var masterData, fgData;
	var funcGens02    = [
		~deltaCentreFuncGen, ~rhoXCentreFuncGen, ~thetaYCentreFuncGen,
		~spectralCentreFuncGen, ~rhoXEventFuncGen, ~thetaYEventFuncGen,
		~spectralEventFuncGen
	];
	var fileUnrecognised = false;

	if ((data[0].at(0)== "AudioSprayGun"),
		{
			switch (data[1].at(0).asFloat,
				0.1, {
					masterData = (
						filename: data[2].at(0),
						duration: data[3].at(0).asFloat,
						gain:     data[4].at(0).asFloat,
						events:   200,
						mode:     0,
						delay:    0,
						coords:   1
					);
					fgData = Array.fill(funcGens02.size,
						{|i| convert01.(data[5+i].at(0).interpret, ~sliders);}
					);
				},
				0.2, {
					masterData = (
						filename: data[2].at(0),
						duration: data[3].at(0).asFloat,
						events:   data[4].at(0).asFloat,
						gain:     data[5].at(0).asFloat,
						mode:     data[6].at(0).asFloat,
						delay:    data[7].at(0).interpret,
						coords:   1
					);
					fgData = Array.fill(funcGens02.size,
						{|i| convert02.(data[8+i].at(0).interpret, ~sliders);}
					);
				},
				{fileUnrecognised = true}
			);

			if(fileUnrecognised, {~infoText.value_("LOAD FAILED: text file version not recognised");},
				{
					~master.setParams(masterData);
					~funcGens.do({arg item, i; item.restoreDefaults;});
					funcGens02.do({arg item, i; item.setParams(fgData[i]);});
					~reset.("", true, PathName.new(path).fileName);
			})
		},
		{
			~infoText.value_("LOAD FAILED: not an ASG text file");
	});
};

/*  4.2.1 convert01: convert funcGen data from txt format 0.1
    ==========================================================
*/
convert01 ={arg oldData, steps;
	var thisRule    = ~ruleFactory.(oldData[0], oldData[1]);
	[thisRule.getArray(steps)].addAll(oldData[2..]);
};

/*  4.2.2 convert02: convert funcGen data from txt format 0.2
    ==========================================================
*/

convert02 = {arg oldData, steps;
	var consequents = oldData[0];
	var thisRule    = ~ruleFactory.(Array.series(consequents.size, 0, 1/consequents.size), consequents);
	[thisRule.getArray(steps)].addAll(oldData[1..]);
};



/*   4.3 ~reset: disable write, replay buttons when no eventArray present (e.g. after New/ Load)
     ===========================================================================================
*/

~reset = {|info, changeWinName = false, winName="New", clearDisplay = true, init = false|
    ~infoText.value_(info);
    if (changeWinName, {~paramWindow.name = winName});
    if (clearDisplay, {~dispArray = []; ~displayPanel.refresh;});
	if (init, {
		~funcGens.do({arg item, i; item.restoreDefaults;});
		~master.restoreDefaults;
		//~goButton.enabled = false;
	});
    ~writeButton.enabled = false;
    ~replayButton.enabled = false;
    ~replayButton.value= 0;
};


/* 5. ~writePanel: Pop up panel called by master function "Write".
   =================================================================

Auto-generates filename for three files:
metadata:   fname_meta   (SC archive)
audio:      fname.aiff   (audio)
parameters: fname_params (SC archive) -optional

These are stored in three designated folders
folder names are preserved until next time.


*/

~audioFolder = "<none>";
~metaFolder = "<none>";
~paramFolder = "<none>";
~audioTail = 15;

~writePanel = {arg master;

	var fnameFromData = {|samplePath, mode, duration, events|

		format("%_%_%",
			PathName.new(samplePath).fileNameWithoutExtension,
			["t", "n"].at(mode),
			[duration, events].at(mode)
		);
	};

	var writeWin = ~centreWindow.("Write", 500, 300).front;

	var fnameField = ~labelledTextField.(writeWin, 10, 4, 480, label: "filename",
		initString: fnameFromData.(master.filename, master.mode, master.duration, master.events));

	var audioField = ~labelledTextField.(writeWin, 10, 48, 480, label: "audio folder", initString: ~audioFolder);
	var metaField  = ~labelledTextField.(writeWin, 10, 116, 480,  label: "metadata folder", initString: ~metaFolder);
	var paramField = ~labelledTextField.(writeWin, 10, 158, 480, label: "parameter file folder", initString: ~paramFolder);

	var saveParams = CheckBox(writeWin, Rect(10, 200, 480, 20)).string_("save parameter file when writing audio");
	var audioTail  = NumberBox(writeWin, Rect(10, 92, 48, 20))
	.value_(~audioTail)
	.align_(\center);

	StaticText(writeWin, Rect(64, 92, 400, 20))
	.string_("seconds roll out");

	~bang.(writeWin, Rect(100, 232, 100, 28),"Write",
		{
			var fname = fnameField.value;

			// update folders etc
			~audioFolder = audioField.value; ~metaFolder  = metaField.value;
			~paramFolder = paramField.value; ~audioTail   = audioTail.value;

			// write metadata
			~writeArchiveFromObjects.(
				~metaFolder ++ fname ++ "_meta",
				~groupFileHeader,
				[~master.getParams] ++ ~eventArray
			);

			//if(box.val, write params
			if(saveParams.value, {
				var paramFname = fname ++ "_params";
				~writeArchiveFromObjectParams.(~paramFolder ++ paramFname, ~appHeader,[~master] ++ ~funcGens );
				~paramWindow.name = paramFname;
				}
			);
			//record audio
			~recordBuffer.write(~audioFolder ++ fname ++ ".aif", "aiff", "int16", 0, 0, true);
			~recSynth = Synth.tail(nil, \zonesDiskOut16, ["bufnum", ~recordBuffer]);

			Task({

				0.5.wait;

				~eventArray.do({arg item, i;
					~renderEvent.(item, ~instrument, b, ~masterVol, ~delayMode).play;
					item.delta.wait;
				});

				~audioTail.wait;

				~recSynth.free;
				~recordBuffer.close;
				{writeWin.close;}.defer;
			}).start;

		}
	);


	~bang.(writeWin, Rect(300, 232, 100, 28),"Cancel",{writeWin.close;});

};



/* 6. ~buildViews: builds three main windows
   =========================================

~launchWindow   - master controls (e.g. open, save, Go, delay mode, time/ count mode etc.)
~paramWindow    - seven function generators for the seven parameters plus master volume, events, duration
~displayWindow  - "cross hairs" display plotting events

*/

~buildViews = {

	~dispArray =[];

	~launchWindow = Window.new("Audio SprayGun 0.8.1", Rect(160, 70, 762, 165), false)
	.onClose_({~paramWindow.close;~displayWindow.close;});

	~displayWindow = Window.new("display", Rect(770, 600, 520, 520), false);

	~master       = ~buildMasterControl.(~launchWindow);
	~paramWindow  = ~makeParamWindow.(Window.new("New", Rect(10, 500, 755, 615), false));
	~displayPanel = ~buildDisplayPanel.(~displayWindow);


	~paramWindow.front;
	~displayWindow.front;
	~launchWindow.front;


};

"displays built".postln;

)


/*
   === ASG 0.8.1 library ======================

   component library for ASG 0.8.1
   attempt to create building blocks which can be re-used in subsequent
   versions without too much more modification.

   CONTENTS

       1. Fuzzy Operators etc.

          1.1  ~ruleFactory:    implements fuzzy membership rule as a test or an array
          1.2  ~fuzzyANDArrays: fuzzy AND (min) of two same-length arrays
          1.3  ~fuzzyORArrays:  fuzzy OR (max) of two same-length arrays
          1.4  ~map01:          map a value from/to 0-1 to/from min-max (lin or log scale)

       2. GUI factories

          2.1  ~mSlider:           Multislider factory with or without label
          2.2  ~labelledNumBox:    Number Box factory with label
          2.3  ~labelledMenu:      Drop down menu factory with label
          2.4  ~knobWithBox:       Factory for knob with box
          2.5  ~bang:              buttons to do one thing
          2.6  ~toggle:            toggle factory
          2.7  ~control2D:         makes 2D slider with two numb boxes, label (lin or log scale)
          2.8  ~presetControl:     drop-down preset menu sends with rev, inv, sends value to mSlider
          2.9  ~labelledTextField: text field with label above
          2.10 ~centreWindow:      create a window in the middle of the screen

       3. File Handling

          3.1  ~loadAudio:                    load audio file
          3.2  ~writeArchiveFromObjects:      save header plus list of objects to SC Archive file
          3.3  ~writeArchiveFromObjectParams: save header plus list of parameters from objects to SC Archive file
          3.4  ~isParamFile:                  compare AppName in file header with application header
          3.5  ~readArchiveToObjectParams:    read params from file to a list of objects

       4. 3D Geometry

          4.1  ~xyzPoint:         make a 3D cartesian point with asxyz, asCylindrical and asSpherical methods
          4.2  ~cylindricalPoint: make a 3D cylindrical point with asxyz, asCylindrical and asSpherical methods
          4.3  ~sphericalPoint:   make a 3D spherical point with asxyz, asCylindrical and asSpherical methods
          4.4  ~xyzWRT :          calculate cartesian 3D location wrt new origin (returns xyzPoint)

       5. Audio Rendering

          5.1  ~renderEvent: make audio event from location event
          5.2  ~playEvents:  render and play soundEvents (~eventArray)

       6. Graphics

          6.1  ~makeDot: plots x,y,spectral elements on graphic display

   ===============================================================================

Richard Garrett
richard@sundaydance.co.uk
September 10th 2015

*/

(

//var testWindow = Window.new;

//   1. Fuzzy Operators etc.
//   =======================

//      1.1 ~ruleFactory: implements fuzzy membership rule as a test or an array
//      ------------------------------------------------------------------------

~ruleFactory = {arg predicates, consequents;

	(
		predicates: predicates,
		consequents: consequents,

		// test: rule.test(testVal) returns fuzzy membership value for testVal

		test: {arg self, testVal;
			self.consequents.blendAt(self.predicates.indexInBetween(testVal));},

		// getArray: returns an array of length steps representing the rule
		// start and len values can be used to extract a subset of the rule array

		getArray: {arg self, steps, start = self.predicates[0], len = self.predicates[self.predicates.size-1];
			var array, step = len/(steps-1);
			array = Array.fill(steps, {arg i; start + (step*i);});
			array.collect({arg item; self.test(item);});
		}
	);
};

//      1.2 ~fuzzyANDArrays: fuzzy AND (min) of two same-length arrays
//      --------------------------------------------------------------


~fuzzyANDArrays = {arg array1, array2;
	Array.fill(array1.size, {arg i; array1[i].min(array2.[i]);});
};

//      1.3 ~fuzzyORArrays: fuzzy OR (max) of two same-length arrays
//      ------------------------------------------------------------


~fuzzyORArrays = {arg array1, array2;
	Array.fill(array1.size, {arg i; array1[i].max(array2.[i]);});
};


//      1.4 ~map01: map a value from/to 0-1 to/from min-max (lin or log scale)
//      ----------------------------------------------------------------------


~map01 ={arg val, min, max, logScale = false, inverse = false;
	case
	{(logScale == false).and(inverse == false)}    {val.linlin(0,1, min, max)}
	{(logScale == false).and(inverse == true)}     {val.linlin(min, max, 0, 1)}
	{(logScale == true).and(inverse == false)}     {val.linexp(0,1, min, max)}
	{(logScale == true).and(inverse == true)}      {val.explin(min, max, 0, 1)};
};



//   2. GUI factories
//   =================

//      2.1 ~mSlider: Multislider factory with or without label
//      -------------------------------------------------------

~mSlider = {arg parent, x, y, arraySize, sliderSize = 2.0, height= 78, color = Color.green(0.8), filled = true, labelled = false, label = "label";

	var borders = 4;
	var width = arraySize*sliderSize + borders;
	var yOffset = if(labelled,{18;},{0;});
	var compView = CompositeView(parent,Rect(x, y, width, height + yOffset));
	var text = if (labelled, {StaticText(compView, Rect(0, 0, width, 14)).string_(label).align_(\left);});

	MultiSliderView(compView, Rect(0, yOffset, width, height))
	.size_(arraySize)
	.isFilled_(true)
	.indexThumbSize_(sliderSize-1)
	.gap_(1)
	.strokeColor_(color);
};


//      2.2 ~labelledNumBox: Number Box factory with label
//      --------------------------------------------------


~labelledNumBox = {arg parent, x,y, label, initVal = 0, action={};

	var compView = CompositeView(parent,Rect(x, y, 48, 35));
	var text;

	text = StaticText(compView, Rect(0, 0, 48, 14)).string_(label).align_(\center);

	NumberBox(compView, Rect(0, 16, 48, 18))
	.value_(initVal)
	.action_(action)
	.align_(\center);

};

//      2.3 ~labelledMenu: Drop down menu factory with label
//      ----------------------------------------------------


~labelledMenu = {arg parent, x, y, width, height = 36, label, params, initVal = 0, action ={};

	var compView = CompositeView(parent,Rect(x, y,  width, height));
	var text = StaticText(compView, Rect(0, 0, width, 14)).string_(label).align_(\left);

	PopUpMenu(compView, Rect(0, 16, width, 18))
	.items_(params)
	.value_(initVal)
	.action_(action);
};

//      2.4 ~knobWithBox: Factory for knob with box
//      -------------------------------------------

~knobWithBox = {arg parent, x, y, label, initVal = 0, clipLo= 0, clipHi = 1, decimals = 2;

	var compView = CompositeView(parent,Rect(x, y, 54, 90););
	var text, knob, box;

	text = StaticText(compView, Rect(0, 3, 54, 15)).string_(label).align_(\center);

	knob = Knob.new(compView, Rect(7, 20, 40, 40))
	.value_(initVal/clipHi)
	.action_({arg v,x,y,m; box.value = clipHi*(v.value);});

	box = NumberBox(compView, Rect(2, 65, 50, 24))
	.value_(initVal)
	.clipLo_(clipLo)
	.clipHi_(clipHi)
	.decimals_(decimals)
	.action_({arg numb; knob.value = numb.value/clipHi;})
	.align_(\center);

	box;

};

//      2.5 ~bang: buttons to do one thing
//      ----------------------------------


~bang = {arg parent, bounds, label, action = {}, color= Color.rand;

	Button(parent, bounds).states_([[label, Color.black, color]])
		.action_(action);
};

//      2.6 ~toggle: toggle factory
//      ---------------------------


~toggle = {arg parent, bounds, label0, label1, action0 = {}, action1 = {}, color0= Color.rand, color1= Color.rand;

Button(parent, bounds).states_([
		[label0, Color.black, color0],
		[label1, Color.black, color1]
	])
	.action_({arg butt; if(butt.value==0,action0, action1);});
};

//      2.7 ~control2D: makes 2D slider with two numb boxes, label (lin or log scale)
//      -------------------------------------------------------------------------------

~control2D = {arg parent, x=10, y=10, sliderSize=80, min =0, max =1, logScale = false, labelled = false, label = "label", decimals = 2;

	var yOffset = if(labelled,{14;},{0;});
	var boxHeight = 18, boxWidth = (sliderSize/2)-1, boxMargin = 2;
	var boxY = yOffset + sliderSize + boxMargin;

	var compView = CompositeView(parent,Rect(x, y, sliderSize, sliderSize + yOffset + boxHeight + (2*boxMargin)));

	var text = if (labelled, {StaticText(compView, Rect(0, 0, sliderSize, 14))
		.string_(label)
		.align_(\left);});

	var xbox = NumberBox(compView, Rect(0, boxY, boxWidth, boxHeight))
	.align_(\center)
	.value_(min)
	.decimals_(decimals)
	.action_({arg numb; slider.x_(~map01.(numb.value, min, max, logScale, true))});

	var ybox = NumberBox(compView, Rect(boxWidth + boxMargin, boxY, boxWidth, boxHeight))
	.align_(\center)
	.value_(min)
	.decimals_(decimals)
	.action_({arg numb; slider.y_(~map01.(numb.value, min, max, logScale, true))});

	var slider = Slider2D(compView, Rect(0, yOffset, sliderSize, sliderSize))
	.action_({arg sl;
		xbox.value_(~map01.(sl.x, min, max, logScale));
		ybox.value_(~map01.(sl.y, min, max, logScale));
	});

	(
		slider:        slider,
		xbox:          xbox,
		ybox:          ybox,

		getX:            {arg self; self.xbox.value;},
		getY:            {arg self; self.ybox.value;},
		getParams:    {arg self;
			(
				x:   self.xbox.value,
				y:   self.ybox.value
		);},
		setParams:    {arg self, x, y;

			self.xbox.value = x;
			self.slider.x_(~map01.(x, min, max, logScale, true));
			self.ybox.value = y;
			self.slider.y_(~map01.(y, min, max, logScale, true));
		}
	);
};

//      2.8 ~presetControl:
//      -------------------------------------------------------------------------------

~presetControl = {arg parent, x, y, width = 100, height =60, label="presets", presets, mSlider;
	var compView = CompositeView(parent,Rect(x, y, width, height););
	var array = mSlider.value;

	var presetMenu = ~labelledMenu.(compView, 0, 0, width,
		label: label,
		params: presets.collect({arg item, i; item[0];}),
		action: {arg butt;
			array = presets[butt.value].at(1);
			mSlider.value_(array);
		}
	);

	var reverseButton = ~bang.(compView, Rect(0, 38, (width/2)- 1, 18), "rev.",
		{array = mSlider.value.reverse; mSlider.value_(array);},
		Color.red(0.9));

	var	invertButton = ~bang.(compView, Rect(width/2+1, 38, (width/2)- 1, 18), "inv.",
		{array = mSlider.value.collect({arg item, i; 1 - item;}); mSlider.value_(array);},
		Color.green(0.8));

	mSlider;

};

//      2.9 ~labelledTextField: text field with label above
//      ----------------------------------------------------

~labelledTextField = {arg parent, x, y, width = 200, height = 42, label = "label", initString = "<empty>", action = {};

	var compView = CompositeView(parent, Rect(x, y, width, height));

	StaticText(compView, Rect(0, 0, width, 20))
	.string_(label);

	TextField(compView, Rect(0, 20, width, 22))
	.string_(initString)
	.action = action;
};

//      2.10 ~centreWindow:      create a window in the middle of the screen
//      ---------------------------------------------------------------------

~centreWindow = {|label = "window", width = 400, height =400, resizable =false|
	Window.new(
		label,
		Rect((Window.screenBounds.width - width)/2,(Window.screenBounds.height - height)/2, width,height),
		resizable
	);
};

//   3. File Handling
//   =================

//      3.1 ~loadAudio: load audio
//      ---------------------------

~loadAudio ={arg target, path, server = s;
	target.free;
	Buffer.read(server, path);
};

//      3.2 ~writeArchiveFromObjects: save header plus list of objects to SC Archive file
//      ----------------------------------------------------------------------------------

~writeArchiveFromObjects = {arg path, header, objectsToStore;
	(header: header, storedObjects: objectsToStore).writeArchive(path);
};

//      3.3 ~writeArchiveFromObjectParams: save header plus list of
//          parameters from objects to SC Archive file
//      -----------------------------------------------------------

~writeArchiveFromObjectParams = {arg path, header, objectsToStore;
	(
		header:        header,
		storedObjects: objectsToStore.collect({arg item; item.getParams;})
	).writeArchive(path);
};

//      3.4 ~isParamFile: compare AppName in file header with application header
//      --------------------------------------------------------------

~isParamFile = {|objectHeader, appHeader| (objectHeader.appName == appHeader.appName);};

//      3.5 ~readArchiveToObjectParams: read params from file to a list of objects
//      ------------------------------------------------------------------------------------------

~readArchiveToObjectParams = {arg path, targetObjects;

	var objectFromFile = Object.readArchive(path);
	targetObjects.do({arg item, i; item.setParams(objectFromFile.storedObjects[i]);});

};



//   4. 3D Geometry
//   =================


/*      4.1 ~xyzPoint: make a 3D cartesian point with asxyz, asCylindrical and asSpherical methods
        ---------------------------------------------------------------------------------------------

        INPUT:  x, y, z, Cartesian values

        OUTPUT: 3D cartesian point with methods to convert to Cylindrical or Spherical in which
                theta and phi are both in radians (theta: -pi to +pi, phi: -pi/2 to + pi/2)
                theta = 0 is straight ahead, phi = 0 is horizontal.

        NOTE: .asCylindrical method swaps x and y values in asPolar to compensate for speaker azimuth bearing as opposed
        to maths polar co-ordinates. Also wraps by -pi to + pi.

*/

~xyzPoint = {arg x, y, z;
	(
		x:  x,
		y:  y,
		z:  z,

		asCylindrical: {arg self;
			var horiz     = Point(self.y,self.x).asPolar;
			(rHoriz: horiz.rho, theta: (horiz.theta).wrap(-pi, pi), z: self.z);
		},

		asSpherical:  {arg self;
			var location = self.asCylindrical;
			var vert = Point(location.rHoriz, location.z).asPolar;
			(rho: vert.rho, theta: location.theta, phi: vert.theta);
		},

		asxyz: {arg self;
			(x: self.x, y: self.y, z:self.z);
		}
	);
};

/*      4.2 ~cylindricalPoint: make a 3D cylindrical point with asxyz, asCylindrical and asSpherical methods
        ----------------------------------------------------------------------------------------------------

        INPUT:  horizontal distance, speaker azimuth, altitude

        OUTPUT: Cylindrical point with methods to convert to Cartesian or Spherical in which
                theta and phi are both in radians (theta: -pi to +pi, phi: -pi/2 to + pi/2)
                theta = 0 is straight ahead, phi = 0 is horizontal.

        NOTE: .asxyz method swaps x and y values form polar to compensate for speaker azimuth bearing as opposed
        to maths polar co-ordinates.

*/

~cylindricalPoint = {arg rHoriz, theta, z;
	(
		rHoriz: rHoriz,
		theta:  theta,
		z:      z,

		asCylindrical: {arg self;
			(rHoriz: self.rHoriz, theta: self.theta, z: self.z);
		},

		asSpherical: {arg self;
			var vert = Point(self.rHoriz, self.z).asPolar;
			(rho: vert.rho, theta: self.theta, phi: vert.theta);
		},

		asxyz: {arg self;
			var horiz     = Polar(self.rHoriz, self.theta).asPoint;
			(x: horiz.y, y: horiz.x, z: self.z);
		}
	)
};

/*      4.3 ~sphericalPoint: make a 3D spherical point with asxyz, asCylindrical and asSpherical methods
//      ----------------------------------------------------------------------------------------------------


        INPUT:  horizontal distance, speaker azimuth, elevation

        OUTPUT: Spherical point with methods to convert to Cylindrical or Cartesian in which
                theta and phi are both in radians (theta: -pi to +pi, phi: -pi/2 to + pi/2)
                theta = 0 is straight ahead, phi = 0 is horizontal.

        NOTE: .asxyz method swaps x and y values form polar to compensate for speaker azimuth bearing as opposed
        to maths polar co-ordinates.

*/
~sphericalPoint = {arg rho, theta, phi;
	(
		rho:    rho,
		theta:  theta,
		phi:    phi,

		asSpherical: {arg self;
			(rho: self.rho, theta: self.theta, phi: self.phi);
		},

		asCylindrical: {arg self;
			var vert = Polar(self.rho, self.phi).asPoint;
			(rHoriz: vert.x, theta: self.theta, z: vert.y);
		},

		asxyz: {arg self;
			var location = self.asCylindrical;
			var horiz    = Polar(location.rHoriz, location.theta).asPoint;
			(x: horiz.y, y: horiz.x, z: location.z);
		}
	)
};

//      4.4 ~xyzWRT : calculate cartesian 3D location wrt new origin (returns xyzPoint)
//      -------------------------------------------------------------------------------

~xyzWRT = {arg location, newOrigin;
	~xyzPoint.(location.x - newOrigin.x, location.y - newOrigin.y, location.z - newOrigin.z);
};

//   5. Audio Rendering
//   ====================

/*      5.1 ~renderEvent: make audio event from location event
        --------------------------------------------------------

        INPUT:  location    - event (delta, rho, theta, phi, resample, spread, x, y)

        OUTPUT: sound event - event (note type)

        converts location to sound event for given instrument/ speaker format.
*/

~renderEvent=  {arg location, instrument, bufnum, gain = 0.2, delayMode= 0, spread = 0, delay = 1/340, attenuation = -60.0/1000;

	(
		type:       \note,
		instrument: instrument,
		lag:        delayMode*delay*location.rho,
		bufnum:     bufnum,
		amp:        gain*((attenuation*location.rho).dbamp),
		pan:        location.theta/pi,
		phi:        location.phi*2/pi,
		rate:       location.spectral,
		spread:     location.spread
	);
};

//     5.2 ~playEvents: render and play soundEvents (~eventArray)
//     ------------------------------------------------------------

~playEvents = Task({

	~eventArray.do({arg item, i;
		~renderEvent.(item, ~instrument, b, ~masterVol, ~delayMode).play;
		item.delta.wait;
	});
	{~replayButton.value = 0;}.defer;
});

//   6. Graphics
//   ===========

/*      6.1 ~makeDot: plots x,y,spectral elements on graphic display
        -------------------------------------------------------------

        INPUT:  location    - event (delta, rho, theta, phi, resample, spread, x, y)

        OUTPUT: display event ("dot") (x, y, color) to update display screen

        converts location to dot to add to ~displayArray.
*/

~makeDot =  {arg location;

	~rhoMax = ~rhoMax.max(location.rho);
	~phiMin = ~phiMin.min(location.spectral);
	~phiMax = ~phiMax.max(location.spectral);

	(
		x:      location.x,
		y:      location.y.neg,
		phi:    location.spectral,
		width:  location.spread.linexp(0, 100, ~rhoMax/30, ~rhoMax);
	);
};

)


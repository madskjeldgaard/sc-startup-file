// === Audio SprayGun_081.scd ====

/*

Audio Spray Gun 0.8.1


A system to generate and spatialise large groups of sound-events from a single mono soundfile.

ASG constrains otherwise random events within a locus in a four dimensional parameter space whose
axes are:

     radial distance from the listener,
     azimuth w.r.t listener,
     resampling rate and
     inter-onset interval (delta time).

ASG modifies sound-groups over time by transforming the position and extent of this locus using seven
parameters:

    radial, angular and resampling rate co-ordinates of the locus centre
    radial, angular and resampling rate extent of the locus
    range of available inter-onset intervals

For more information, see the acompanying pdf

*************************************************************************************************************
*                                             WARNING                                                       *
* Audio Spray Gun can play very large numbers of samples simultaneously, resulting in high sound pressures. *
* Please protect your ears and your speakers by experimenting at low playback levels.                       *
*                                                                                                           *
*************************************************************************************************************

To run ASG, open ASG81_init.scd in the supercollider IDE and follow the instructions at the top of the page.

Richard Garrett
richard@sundaydance.co.uk
September 10th 2015


*/

(

// ======== Global Variables ========

var duration, events, instrument, masterVol, mode, delayMode, coordinates;
var rhoCentreFunc,thetaCentreFunc, phiCentreFunc;
var spectralCentreFunc, spreadCentreFunc, deltaCentreFunc;
var rhoEventFunc, thetaEventFunc, phiEventFunc;
var spectralEventFunc, spreadEventFunc, deltaEventFunc;

// === function names =====================

var calculateEventLocation;

~appHeader = (appName: "ASG", fileVersion: 0.4);
~groupFileHeader = (appName: "ASG_group", fileVersion: 0.3);
~master =(duration: 30.0, events: 200, mode: 1, filename: "<none>");// defaults

~rhoMax =100;
~phiMin=0.5;
~phiMax=2;


// === #include =====

(PathName(thisProcess.nowExecutingPath).pathOnly ++ "ASG081_synthDefs.scd").loadPaths;
(PathName(thisProcess.nowExecutingPath).pathOnly ++ "ASG081_guiDisplays.scd").loadPaths;

~sliders = 100;
~buildViews.();

/* === ~initTask ====================

Initialise main process, triggered by the GO button in ~launchWindow
Takes values from ~launchWindow and passes them to environmental variables

OUTPUT: null

*/

~initTask = {

	duration     = ~master.duration;
	events       = ~master.events;
	~masterVol   = ~master.gain;
	mode         = ~master.mode;
	~delayMode   = ~master.delay;
	coordinates  = ~master.coords;

	b = ~loadAudio.(b, ~master.filename);

	~dispArray=[]; ~eventArray = [];
	~rhoMax = 0; ~phiMin =1000; ~phiMax =1000.neg;
	~infoText.value_("");

	~funcGens.do({arg item; item.range_([duration, events].at(mode));});

	rhoCentreFunc       = ~rhoXCentreFuncGen.getFunction;
	thetaCentreFunc     = ~thetaYCentreFuncGen.getFunction;
	phiCentreFunc       = ~phiZCentreFuncGen.getFunction;
	spectralCentreFunc  = ~spectralCentreFuncGen.getFunction;
	spreadCentreFunc    = ~spreadCentreFuncGen.getFunction;
	deltaCentreFunc     = ~deltaCentreFuncGen.getFunction;

	rhoEventFunc       = ~rhoXEventFuncGen.getFunction;
	thetaEventFunc     = ~thetaYEventFuncGen.getFunction;
	phiEventFunc       = ~phiZEventFuncGen.getFunction;
	spectralEventFunc  = ~spectralEventFuncGen.getFunction;
	spreadEventFunc    = ~spreadEventFuncGen.getFunction;
	deltaEventFunc     = ~deltaEventFuncGen.getFunction;

};

/* === ~buildGroup (Task) ====================

loop calculates event locations, stores them as an array, converts into sound events, plays and displays on screen.
this is the main loop.

*/


~buildGroup = Task({

	var location, onset =0, eventCount =0;

	{
		~displayPanel.frameRate = 10;
		~displayPanel.animate = true;
	}.defer;


	while([{onset < duration}, {eventCount < events}].at(mode), {

		location = calculateEventLocation.([onset, eventCount].at(mode));

		~renderEvent.(location, ~instrument, b, ~masterVol, ~delayMode).play;
		~eventArray   = ~eventArray.add(location);
		~dispArray    = ~dispArray.add(~makeDot.(location));

		eventCount = eventCount+1;
		onset = onset + location.delta;
		location.delta.wait;
	});

	{
		~displayPanel.animate = false;
		~infoText.value_(format("events: %   duration (onsets): % seconds", eventCount, onset.round(0.01)));
		~goButton.value=0;
		~replayButton.enabled = true;
		~writeButton.enabled = true;
	}.defer
});



/* === calculateEventLocation ===

INPUT

test:       current time since start of sound-group / event count (see mode in ~buildGroup)

OUTPUT

location:  event (delta, rho, theta, phi, x, y) - x,y for display screen

CALLED BY

~buildGroup

Given test value (between 0 and range), the routine generates a 3D locations for the locus centre (w.r.t. origin) and
the new event w.r.t locus centre using the functions supplied by the function generators in paramWindow. It then makes
two polar calculations, first to calculate the listener position w.r.t the Locus Centre and then the event w.r.t the
listener.

*/

calculateEventLocation = {arg test, listener =(x: 0,y: 0, z: 0);

	var position = (rhoX: rhoCentreFunc.(test), thetaY: thetaCentreFunc.(test), altPhi:  phiCentreFunc.(test));
	var offset   = (rhoX: rhoEventFunc.(test),  thetaY: thetaEventFunc.(test),  altPhi:  phiEventFunc.(test));

	var locusCentre = switch(coordinates,
		0, ~xyzPoint.(position.rhoX, position.thetaY, position.altPhi),
		1, ~cylindricalPoint.(position.rhoX, pi*position.thetaY, position.altPhi),
		2, ~sphericalPoint.(position.rhoX, pi*position.thetaY, (pi/2)*position.altPhi)
	);

	var eventWRTCentre = switch(coordinates,
		0, ~xyzPoint.(offset.rhoX, offset.thetaY, offset.altPhi),
		1, ~cylindricalPoint.(offset.rhoX, pi*offset.thetaY, offset.altPhi),
		2, ~sphericalPoint.(offset.rhoX, pi*offset.thetaY, (pi/2)*offset.altPhi)
	);

	var listenerWRTCentre = ~xyzWRT.(listener, locusCentre.asxyz);

	var eventWRTlistener  = ~xyzWRT.(eventWRTCentre.asxyz, listenerWRTCentre);

	var sphericalEvent    = eventWRTlistener.asSpherical;

	(

		rho:       sphericalEvent.rho,
		theta:     sphericalEvent.theta,
		phi:       sphericalEvent.phi,
		spectral:  spectralCentreFunc.(test)+ spectralEventFunc.(test),
		delta:     deltaCentreFunc.(test)+ deltaEventFunc.(test),
		spread:    spreadCentreFunc.(test)+ spreadEventFunc.(test),
		x:         eventWRTlistener.x,
		y:         eventWRTlistener.y
	);
};

)



































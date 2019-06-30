// === ASG081_synthDefs.scd ====

/*

Audio Spray Gun 0.8.1 beta - synthDefs

A system to generate and spatialise large groups of sound-events from a single mono soundfile.

synthDef components

For more information, see the accompanying pdf

*************************************************************************************************************
*                                             WARNING                                                       *
* Audio Spray Gun can play very large numbers of samples simultaneously, resulting in high sound pressures. *
* Please protect your ears and your speakers by experimenting at low playback levels.                       *
*                                                                                                           *
*************************************************************************************************************

To run ASG, open Audio SprayGun_08.scd and follow the instructions

Richard Garrett
richard@sundaydance.co.uk
13th June 2015

*/
(


//minimal sample player- no envelope plays whole sample from start to finish

SynthDef(\oneShot, {
	arg out =0, bufnum = 0, rate = 1, amp =0.5, pan = 0;
	var sample;

	sample=PlayBuf.ar(1, bufnum, rate*BufRateScale.kr(bufnum), doneAction: 2);
	Out.ar(out, Pan2.ar(sample, pan, amp));
}).add;


SynthDef(\oneShotV, {
	arg out =0, bufnum = 0, rate = 1, amp =0.5, pan = 0, phi=0, spread = 0;
	var sample;

	sample=PlayBuf.ar(1, bufnum, rate*BufRateScale.kr(bufnum), doneAction: 2);
	Out.ar(out, VBAP.ar(~vbapChannels, amp*sample, ~vbapBuffer.bufnum, pan*180, 90*phi, spread));
}).add;


// record to the disk
SynthDef(\zonesDiskOut16, {arg bufnum;
	var channels = ~serverOptions.numOutputBusChannels;
    DiskOut.ar(bufnum, In.ar(0,channels));
}).add;

// this will play it back
SynthDef(\zonesDiskIn16, { arg bufnum = 0;
	var channels = ~serverOptions.numOutputBusChannels;
    Out.ar(0, DiskIn.ar(channels, bufnum));
}).send(s);



"synthDefs loaded".postln;
)

/********************************************


VAND 1


********************************************/

// Boot
(
s.options.hardwareBufferSize = 512*2;
s.options.memSize_(65536 * 8);
s.options.memSize;
s.reboot;
s.meter;
)
s.options.outDevice = "supercollider"
(
var bpm = 80;
TempoClock.default.tempo = bpm/60;
)
s.quit;
s.reset;
s.unmute;
/**************************************

             DISKOUT

***************************************/


/**************************************

               SAMPLES

***************************************/
(

~vand = Array.new;// Creat array for sounds
~vandloops = Array.new;// Creat array for sounds

~folder1 =
PathName.new("/Users/madskjeldgaard/Desktop/scripts/sc/vand1/samples/rt");

~folder2 =
PathName.new("/Users/madskjeldgaard/Desktop/scripts/sc/vand1/samples/vandloops");


~folder1.entries.do({ // Iterate over all sound files in folder and load them to buffers
	arg path;
	~vand = ~vand.add(Buffer.read(s, path.fullPath));

});

~folder2.entries.do({ // Iterate over all sound files in folder and load them to buffers
	arg path;
	~vandloops = ~vandloops.add(Buffer.read(s, path.fullPath));

});
~vandloops.size;
)
~vandloops[1].play;

/**************************************

                SYNTHS

***************************************/
(

    SynthDef.new(\gran1, {
	arg out=0, amp=1.25, rate=(1.0), buf, bufnum, position=0.0,
    atk=0, sus=5, rel=8,
    filtermix=0.9, filterfreq=1000,
    trigrate=1, gdur=0.1, inter=0, panFreq=5, mix=0.5,
	gdamp=0, gmodd=0.3, gsize=0.6, gfeed=0.1, gmodf=10, delay=0.5;
    var sig, fil, rev, sig2, sig3, sig4;
    var env = EnvGen.kr(Env.new([0,1,1,0], [atk,sus, rel]), doneAction:2);
    sig = TGrains.ar(2,
		trigger: Dust.kr(trigrate),
		bufnum:buf,
		dur:gdur,
		centerPos: position,//Latch.kr(WhiteNoise.kr,Dust.kr(trigrate)).range(0.0,0.90),
		pan: SinOsc.kr(panFreq).range(-1.0,1.0),
		rate:rate,
		interp:inter);
    sig2 = TGrains.ar(2,
		trigger: Dust.kr(trigrate*2),
		bufnum:buf,
		dur:gdur/2,
		centerPos: position+0.2,//Latch.kr(WhiteNoise.kr,Dust.kr(trigrate)).range(0.0,0.90),
		pan: SinOsc.kr(panFreq).range(-1.0,1.0),
		rate:rate*2,
		interp:inter);
    sig3 = TGrains.ar(2,
		trigger: Dust.kr(trigrate*3),
		bufnum:buf,
		dur:gdur/3,
		centerPos: position+0.4,//Latch.kr(WhiteNoise.kr,Dust.kr(trigrate)).range(0.0,0.90),
		pan: SinOsc.kr(panFreq).range(-1.0,1.0),
		rate:rate*3,
		interp:inter);
    sig4 = BufGrain.ar(2,
        trigger: Dust.kr(trigrate*3),
		sndbuf:buf,
		dur:gdur*2,
		pos: position+0.4,//Latch.kr(WhiteNoise.kr,Dust.kr(trigrate)).range(0.0,0.90),
		rate:rate/2,
		interp:inter);
    sig4 = SMS.ar(sig4);
    sig = (
        (sig * Latch.kr(SinOsc.kr(IRand(0.1, trigrate)/4).range(0.3,0.6),Dust.kr(trigrate)))
        + (sig2 * Latch.kr(LFSaw.kr(IRand(0.1, trigrate)/4).range(0.3,0.7), Dust.kr(trigrate)))
        + (sig3 * LFTri.kr(IRand(0.1, trigrate)/8).range(0.3,0.8))
        + (sig4 * LFSaw.kr(IRand(0.1, trigrate)/8).range(0.3,0.9)))/4;
	rev = Greyhole.ar(sig, delayTime: delay, damp:gdamp, feedback:gfeed, modDepth:gmodd, size:gsize, modFreq:gmodf);
    sig = Splay.ar([sig, rev*mix]);
	sig = sig * env;

	Out.ar(out,sig*amp);
    }).add;

SynthDef.new(\SamplePlayer, {
	arg out=0,
	amp=0.9,
	rate=1.0,
	atk=1,
	sus=1,
	rel=1,
	pan=0,
	buf;
	var env = EnvGen.kr(Env.new([0,1,1,0], [atk,sus, rel]), doneAction:2);
	var sig = PlayBuf.ar(1, buf, rate);
	sig = Pan2.ar(sig, env.range(-1.0,1.0));
	sig = sig * env;
	Out.ar(out,sig*amp);
}).add;

SynthDef.new(\StereoSamplePlayer, {
	arg out=0,
	amp=0.5,
	rate=1.0,
	atk=1,
	sus=1,
	rel=1,
	pan=0,
	buf;
	var env = EnvGen.kr(Env.new([0,1,1,0], [atk,sus, rel]), doneAction:2);
	var sig = PlayBuf.ar(2, buf, rate);
	sig = Pan2.ar(sig, env.range(-1.0,1.0));
	sig = sig * env;
	Out.ar(out,sig*amp);
}).add;

SynthDef(\concat1, {
    arg bufnum,
    bufnum2,
    matchlength=0.3, // Match length in seconds
    seektime=1.0, // Time in seconds into the past to start searching for matches
    zcr=0.1, // Weight for zero crossing rate feature
    lms=1.0, // Weight for log mean square amplitude feature
    sc=0.1, // Weight for spectral centroid feature
    st=0.1, // Weight for spectral tilt feature
    freeze=0, // Stop collecting novel source input, keep database fixed
    storesize=1.0, // size of source store sample buffer in seconds
    seekdur=1.0, // Time in seconds from seektime towards the present to test matches
    rate=1.0,
    amp=1.00,
    pan=0.0,
    out=0,
    atk=1,
    sus=1,
    rel=1,
    revamount=0.3, gdamp=0, gmodd=0.3, gsize=0.6, gfeed=0.1, gmodf=10, delay=0.5;
    var control, // audio rate input, acts as control
    input, // audio rate input, source for cross-synthesis
    concat, env, rev,sms,sig;

    env = EnvGen.kr(Env.new([0,1,1,0], [atk,sus, rel]), doneAction:2);
    control = PlayBuf.ar(2,bufnum2,BufRateScale.kr(bufnum)*rate, loop:1);
    input = PlayBuf.ar(2,bufnum,BufRateScale.kr(bufnum)*rate, loop:1);
    concat = Concat.ar(control,input,storesize,seektime,seekdur, matchlength,freeze,zcr,lms,sc,st);
    sms = SMS.ar(concat, freqmult: 3, maxpeaks:160, freqadd:1);
    sig = Splay.ar([sms,concat]);
    rev = Greyhole.ar(sig, damp: gdamp, size: gsize, delayTime: delay);

    Out.ar(out,Pan2.ar(Splay.ar([sig,rev*revamount]),pan)*(env*amp))
}).add;
)

a=Synth(\concat1,[\bufnum, ~vandloops[1], \bufnum2, ~vandloops[0], \atk, 8, \sus, 4, \rel, 4]);
i = Synth(\StereoSamplePlayer, [\buf, ~vandloops[0]]);
a.free;
~vand[0].play;
~vand.size;

(
~grain1 = Pbind(\instrument, \gran1,
	\grain, Pxrand(~vand),
    \atk, Pseq([1.5,2,0],inf),
	\rate,2.50,
	\gdur, Pwhite(0.01,0.25),
	\rel,Pseq([2,4,2.5],inf),
	\gsize, Pwhite(0.3,2.0),
	\gfeed, Pwhite(0.01,0.8),
	\gmodd, Pwhite(0.2,1.0),
    \mix, 0.4,
    \amp, 0.8,
	\panFreq, Pgeom(5, 5),
    \inter,Pxrand([0,2,0],inf),
    \gmodf, Pwhite(2,20),
    \trigrate, Pseq([3,2,1,5],inf),
    \dur, Pseq([10,10,5],2)
);

~grain2 = Pbind(\instrument, \gran1,
	\grain, ~vand[0],
	\rate, Pseq([Pn(2.0,3),1.0,0.5, 0.25]),
    \gdur, 0.3,
	\trigrate, Pseq([40,5,1,1,3,0.3]),
    \atk, 0.01,
    \amp, 0.3,
    \mix, Pseq([0.0,Pn(0.5,5)]),
    \delay, 0.4,
    \gsize, 0.9,
    \rel,Pseq([Pn(1.11,5),8]),
    \dur, Pseq([5,3,2,10,5],1),
	\inter,Prand([0,2,4],inf),
	\gfeed, Pseq([0.1,0.2,0.9,0.01,0.99])
);

~vandsample1 = Pbind(\instrument, \StereoSamplePlayer,
	\rate, 1.0,
    \amp, 1.0,
	\dur, Pseq([10],1),
    \atk, 0,
	\sus, 8,
    \rel, 0,
	\buf, ~vandloops[1]
);
~vandsample2 = Pbind(\instrument, \StereoSamplePlayer,
	\rate, 1.0,
    \amp, 1.0,
	\dur, Pseq([10],1),
    \atk, 4,
	\sus, 8,
    \rel, 0,
	\buf, ~vandloops[0]
);
~vandsample3 = Pbind(\instrument, \StereoSamplePlayer,
	\rate, 1.0,
    \amp, 1.0,
	\dur, Pseq([10],1),
    \atk, 0,
	\sus, 8,
    \rel, 0,
	\buf, ~vandloops[2]
);
~concatpat1 = Pbind(\instrument, \concat1,
	\matchlength, 0.1,
	\pan, Pwhite((-1.0),1.0),
    \atk, 1.0,
	\dur, Pseq([5,3,5,2],1),
    \revamount, 0.01,
	\sus, 3,
	\bufnum, ~vandloops[2],
	\bufnum2, ~vandloops[1]

);

~concatpat2 = Pbind(\instrument, \concat1,
	\matchlength, 0.1,
	\pan, Pwhite((-1.0),1.0),
    \amp, 1.1,
	\atk, 1.0,
	\dur, Pseq([5,5,5,5],1),
	\sc, 1.0,
	\st, 0.5,
	\lms, 0.0,
	\zcr, 0.0,
	\sus, 3,
    \revamount, 0.01,
	\bufnum, ~vandloops[1],
	\bufnum2, ~vandloops[2]
);

~concatpat3 = Pbind(\instrument, \concat1,
	\matchlength, Pwhite(0.01,0.3),
	\pan, Pwhite((-1.0),1.0),
	\atk, 1.0,
    \gsize, 0.2,
    \gfeed, 0.1,
    \gdamp, 0.8,
	\dur, Pseq([5,3,5,2],1),
    \revamount, 0.01,
	\sc, 0.0,
    \delay, 0.1,
	\st, 0.5,
	\lms, Pwhite(0.0,1.0),
	\seektime, 0.7,
	\zcr, 1.0,
	\sus, 3,
	\bufnum, ~vandloops[2],
	\bufnum2, ~vandloops[0]
);
~concatpat4 = Pbind(\instrument, \concat1,
	\matchlength, 0.01,
    \seektime, 3.0,
    \rate, 2.0,
	\pan, Pwhite((-1.0),1.0),
	\atk, 1 ,
	\dur, Pseq([5,3,5,3],1),
    \rel,1.0,
    \amp, 0.35,
	\sc, 0.5,
	\st, 0.5,
    \revamount, 0.01,
	\lms, Pwhite(0.0,1.0),
	\seektime, 0.7,
	\zcr, 1.0,
	\sus, 3,
	\bufnum, Pseq([~vandloops[2],~vandloops[0],~vandloops[1]]),
	\bufnum2, ~vandloops[0]
);
~concatpat5 = Pbind(\instrument, \concat1,
	\matchlength, 0.02,
	\pan, Pwhite((-1.0),1.0),
	\atk, 0.1,
	\dur, Pseq([5,3,5,2],1),
	\sc, 0.8,
	\st, 0.5,
	\lms, 0.2,
	\seektime, 1.0,
	\zcr, 0.2,
	\sus, 3,
    \revamount, 0.0,
	\bufnum, ~vandloops[0],
	\bufnum2, ~vandloops[2]
);
~concatpat6 = Pbind(\instrument, \concat1,
	\matchlength, Pwhite(0.01,0.3),
	\pan, Pwhite((-1.0),1.0),
	\atk, 1.0,
	\dur, Pseq([5,3,5,2],1),
	\sc, 0.3,
	\st, 1.0,
	\lms, 0.9,
    \revamount, 0.01,
	\seektime, 1.0,
	\zcr, 1.0,
	\sus, 3,
	\bufnum, ~vandloops[1],
	\bufnum2, ~vandloops[2]
);
~pause = Pfindur(1,Pseq([1]));
)
~concatpat3.play;

~vandsample.play;
~grain2.play;

/**************************************

             MAIN SEQUENCE

***************************************/
(
    ~pauselength = 5;
Pseq([
    Pseq([
    Pn(~concatpat3,2),
    Pseq([~grain2, Pn(~grain1,2)],1)],1),
    ~concatpat4,Pn(~concatpat6,2),
    Ppar([Pn(~vandsample2,4), Pn(~concatpat6,2)]),
    ~concatpat3,
    Pfindur(12, Pseq([~grain2, ~grain1],1)),
    ~concatpat5,
    Pn(~concatpat3,1),Pn(~pause,0),
    Ppar([Pn(~grain2,2), ~concatpat2,
    Pn(~concatpat6,1),Pn(~pause,~pauselength)
    ])],
1).play;
)
Ppar([~grain2, ~concatpat2]).play;
~concatpat4.play;

/// Recording

s.recChannels(10);
s.recChannels;
s.prepareForRecord;
s.stopRecording;
s.record;

~grain2.play;
~vandsample2.play;
500.do{" grains of sound/water".post;}
Ppar([~concatpat3, Pn(Pfindur(4, ~grain1),4)],2).play;

(
   s.reset; 
s.options.hardwareBufferSize = 512*1;
s.options.memSize_(65536 * 8);
s.options.memSize;
s.reboot;
)
(

~sounds = Array.new;// Creat array for sounds
 

~folder =
PathName.new("/Users/madskjeldgaard/Desktop/scripts/sc/soundpalaces1/samples");

~folder.entries.do({ // Iterate over all sound files in folder and load them to buffers
	arg path;
	~sounds = ~sounds.add(Buffer.read(s, path.fullPath));

});
)
~sounds[1].play;
(
// Audio busses
// Delay
~delayline = Bus.audio(s, 2);

SynthDef.new(\delay, {
    |feedback=0.55, damp=0.36, size=0.75, delaytime=0.5, inbus, outbus|

   var sig = Greyhole.ar(
   In.ar(inbus), 
   damp: In.kr(~ft5x), //damp, 
   delayTime: In.kr(~ft3z), //delaytime, 
   //diff: In.kr(~lpalmy), //0.5, 
   feedback: In.kr(~ft1y),//feedback, 
   //modDepth: In.kr(~lwristz), 
   //modFreq: In.kr(~rradius), //2, 
   size: In.kr(~ft2z));
   sig = Pan2.ar(sig, Saw.kr(In.kr(~lpalmx)*10));
   Out.ar(outbus, sig);
}).add;
)
(
d = Synth.new(\delay, [\inbus, ~delayline, \outbus, 0]);
d.free;
)

/*** SYNTHS ***/
(
SynthDef.new(\twohandgrain, {
    |samplebuf, out, rate=1.0, gdur=0.5, effectbus, effectamount=0.2
    atk=1.0, sus=1.0, rel=2.0, dur=1.0, decay=2.0|
    var grain1, grain2, grain3, grain4, grain5, grain6, grain7,
    grain8, grain9, grain10, sig;

    var env = EnvGen.kr(Env.adsr, gate:dur, doneAction:2);
    var trigrate = In.kr(~rradius);
    var righttrigger = Dust.kr(trigrate);

    /*** finger 1 ***/
    grain1 = GrainBuf.ar(2, 
        trigger: TDelay.kr(righttrigger,0.1), 
        sndbuf: samplebuf, 
        rate: rate * 0.1, //rate, 
        pos: In.kr(~ft1x), 
        dur: In.kr(~ft1y)*gdur*2, 
        pan: In.kr(~ft3z), 
        mul: LFNoise0.kr(trigrate).range(0.11, 0.2), 
        interp: 4); 


    /*** finger 2 ***/
    grain2 = GrainBuf.ar(2, 
        trigger: TDelay.kr(righttrigger,0.1), 
        sndbuf: samplebuf, 
        rate: rate * 0.9, //rate, 
        pos: In.kr(~ft2x), 
        dur: In.kr(~ft2y)*gdur, 
        pan: In.kr(~rpalmx) - 0.45, 
        mul: LFNoise0.kr(trigrate).range(0.11, 0.25), 
        interp: 4); 

    /*** finger 3 ***/
    grain3 = GrainBuf.ar(2, 
        trigger: TDelay.kr(righttrigger,0.2), 
        sndbuf: samplebuf, 
        rate: rate * 0.8, //rate, 
        pos: In.kr(~ft3x), 
        dur: In.kr(~ft3y)*gdur, 
        pan: In.kr(~rpalmx) - 0.45, 
        mul: LFTri.kr(trigrate).range(0.11, 0.3), 
        interp: 4); 

    /*** finger 4 ***/
    grain4 = GrainBuf.ar(2, 
        trigger: TDelay.kr(righttrigger,0.3), 
        sndbuf: samplebuf, 
        rate: rate * 0.7, //rate, 
        pos: In.kr(~ft4x), 
        dur: In.kr(~ft4y)*gdur, 
        pan: In.kr(~rpalmx) - 0.45, 
        mul: SinOsc.kr(trigrate).range(0.11, 0.33), 
        interp: 2); 

    /*** finger 5 ***/
    grain5 = GrainBuf.ar(2, 
        trigger: TDelay.kr(righttrigger,0.4), 
        sndbuf: samplebuf, 
        rate: rate*1.25, 
        pos: In.kr(~ft5x), 
        dur: In.kr(~ft5y)*gdur, 
        pan: In.kr(~ft5x), 
        mul: Saw.kr(trigrate).range(0.11, 0.4), 
        interp: 0); 

    sig = Splay.ar([grain1, grain2, grain3, grain4, grain5]);
    sig = Pan2.ar(sig, In.kr(~lpalmz));
    //sig = sig * env;
    Out.ar(effectbus, sig*effectamount);
    Out.ar(out, sig);


}).add;

)
y = Synth.new(\twohandgrain, [\effectbus, ~delayline, \samplebuf, ~sounds[1], \out, 0,\dur, 1.25, \rate, 1.25]);
y.free;
(
~pattern = Pbind(
    \instrument, \twohandgrain,
    \effectbus, ~delayline, 
    \samplebuf, ~sounds[1], 
    \out, 0,
    \gdur, 1.25, 
    \dur, 2,
    \sus, Pseq([20,20,20,20],5),
    \rate, Pseq([1.25,1.1,1.33,1.5])
).play;
)
~pattern.stop;


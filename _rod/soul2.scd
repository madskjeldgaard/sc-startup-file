(
g = ServerOptionsGui(s);
s.reboot;

)

/**************************************

               SAMPLES 

***************************************/
(

~stereoSamples = Array.new;// Creat array for sounds

~folder =
PathName.new("/Users/madskjeldgaard/Desktop/Projekter/SOUL/samples/stereo/brown");

~folder.entries.do({ // Iterate over all sound files in folder and load them to buffers
	arg path;
	~stereoSamples = ~stereoSamples.add(Buffer.read(s, path.fullPath));

});

)

(
SynthDef(\sample1, { 
    arg buffer, out = 0, amp = 1.0, 
    rate = 1.0, start = 0.0, channels = 2, loop = 0,
    sort =100, warpfreq=4;    

    var sig, trig = 1;

    // Set up buffer to be played
    sig = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer) * rate, trig, start, loop, doneAction:2);

    Out.ar(out, sig * amp);
}).add;

SynthDef(\sampleWarp, { 
    arg buffer, out = 0, amp = 1.0, 
    warpFreq=4, freqScale = 0.5, grainSize = 0.25,
    overlaps = 8, ran = 0.1, 
    dur=4, rel=2;    

    var sig, pointer, env;

    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.5, 0.0], [dur/8, dur/4, dur/4, dur/rel]), doneAction:2);

    // This oscillator will browse through the buffer
    pointer = Saw.kr(warpFreq).range(0,1);

    // This is the warping algorithm
    sig = Warp1.ar(2, buffer, pointer, freqScale, grainSize, -1, overlaps, ran);
    
    Out.ar(out, sig*amp*env);
}).add;

// First pattern 

~p1 = Pbind(\instrument, \sampleWarp,
    \out, 2,
    \freqScale, Pseq([1.0, 0.75],4),
    \buffer,  ~stereoSamples[2],
    \warpFreq, 0.25,
    \grainSize, Pseq([0.25, 0.1, 0.25], inf),
    \overlaps, Pseq([8, 4, 2], inf),
    \ran, Pwhite(0.1, 0.33),
    \amp, 1.0,
    \dur, 8
    );

~hovedstrygere = Pbindf(~p1, \out, 4, \buffer, ~stereoSamples[4]);

~overgang1 = Pfindur(48, Pbindf(~hovedstrygere, \out, 6, \buffer, ~stereoSamples[4], \overlaps, 1,
\grainSize, 0.1, \warpFreq, 5, \ran, Pseq([0.0, 0.5], inf)));

~overgang2 = Pbindf(~hovedstrygere, \out, 8, \buffer, ~stereoSamples[4], \overlaps, Pseries(1,1), \grainSize, 0.1, \warpFreq, 5, \ran, Pseq([0.0, 0.5], inf));

// Second pattern
~voice = Pbind(\instrument, \sampleWarp,
    \out, 10,
    \freqScale, Pseq([1.0, 0.75],16),
    \buffer,  ~stereoSamples[5],
    \warpFreq, Prand([2.25, 2.0], inf),
    \grainSize, Prand([0.25, 0.3], inf),
    \overlaps, Pseries(2,1),
    \ran, Pwhite(0.2, 0.33),
    \amp, 1.0,
    \dur, 7
    );

 // Støj 
~noise = Pbind(\instrument, \sampleWarp,
    \out, 10,
    \freqScale, 1.0,
    \buffer,  ~stereoSamples[2],
    \warpFreq, 4,
    \grainSize, Prand([0.25, 0.3], inf),
    \overlaps, 4,
    \ran, Pwhite(0.2, 0.33),
    \amp, 1.0,
    \dur, 7
    );

  // Støj 
~noise2 = Pbind(\instrument, \sampleWarp,
    \out, 12,
    \freqScale, 0.1,
    \buffer,  ~stereoSamples[0],
    \warpFreq, 4,
    \grainSize, Prand([0.25, 0.3], inf),
    \overlaps, 4,
    \ran, Pwhite(0.2, 0.33),
    \amp, 1.0,
    \dur, 7
    );

   // Støj 
~noise3 = Pbind(\instrument, \sampleWarp,
    \out, 14,
    \freqScale, 0.05,
    \buffer,  ~stereoSamples[1],
    \warpFreq, 0.01,
    \grainSize, Prand([0.1,0.2,0.3]),
    \overlaps, 32,
    \ran, Pwhite(0.2, 0.53),
    \amp, 1.0,
    \dur, 7
    );
   
// Blocks
~plist = [~overgang1, ~hovedstrygere, ~overgang1, ~overgang2];
~plist2 = [~overgang1, ~overgang2];

~pblock1 = Pseq(~plist, 1);
~pblock2 = Ppar([~voice, Pseq(~plist.reverse, 1)]);
~pblock3 = Ppar([Pn(~hovedstrygere,4), Pseq(~plist2, 1), ~voice], 8);

// Main
~main = Pseq([
    ~overgang1,
    Pfindur(128, ~pblock2),
    ~pblock3
    ],1);
)


// Play composition
~main.play;

~noise.play;


(
// DRUM SAMPLES
// Creat array for sounds
~drums = Array.new;

// Set up path name to folder containing samples
~folder = PathName.new("/Users/madskjeldgaard/Desktop/Samples/DRUMS/Rhythmace");

// Iterate over all sound files in folder and load them to buffers
~folder.entries.do({
	arg path;
	~drums = ~drums.add(Buffer.read(s, path.fullPath));

});

)
(

   ~bd = ~drums[4];
~bigdrumIntro = Pmono(\monoSamplePlay,
    \buf, ~bd,
    \position, -1.0,
    \rate, Pseq([1.5,1.2,1.0,0.5, 0.75, 0.75, 0.75],inf),
    \start,0,// Pwhite(0, ~fje5.numFrames,inf),
    \dur, Prand([1/8,1/4,1/16, 1, 1/8, 3], 5),
    \trig, Pseq([1,0, 1, 0, 1, 0], inf)
);
~bd2 = ~drums[5];
~bigdrumMain = Pmono(\monoSamplePlay,
    \buf, ~bd2,
    \mix, 1.0,
    \position, 0,
    \wet, 0.5,
    \rate,0.9,
    \start,0,// Pwhite(0, ~fje5.numFrames,inf),
    \dur, Pseq([1/8,1/4,1/16, 1/32, 1/8, 3, 1/16, 1/16, 1/16],6),
    \trig, Pseq([1,0, 1, 0, 1, 0], inf)
);

~sd = ~drums[13];
~snaredrumMain = Pmono(\monoSamplePlay,
    \buf, ~sd,
    \rate,0.9,
    \start,0,// Pwhite(0, ~fje5.numFrames,inf),
    \dur, Pseq([1/8,1/4,1/16, 1/32, 1/8, 3, 1/16, 1/16, 1/16],10),
    \trig, Pseq([1,0, 1, 0, 1, 0], inf)
);

~hh = ~drums[1];
~hhMain = Pmono(\monoSamplePlay,
    \buf, ~hh,
    \mix, 0.5,
    \wet, Pseq([0.0,0.25,0.5,0.75,0.9],inf),
    \rate,1.2,
    \start,0,// Pwhite(0, ~fje5.numFrames,inf),
    \dur, Pseq([1/8,1/4,1/16, 3, 1 , 1/16],10),
    \trig, Pseq([1,0, 1, 0, 1, 0], inf)
);
~ohh = ~drums[2];
~ohhMain = Pmono(\monoSamplePlay,
    \buf, ~ohh,
    \spread, 0,
    \center, 1,
    \rate,1.2,
    \start,0,// Pwhite(0, ~fje5.numFrames,inf),
    \dur, Pseq([1/4,1/4],20),
    \trig, Pseq([0, 1,0, 1, 0, 1], inf)
);

~perc = ~drums[6];
~percMain = Pmono(\monoSamplePlay,
    \buf, ~perc,
    \rate,0.5,
    \start,0,// Pwhite(0, ~fje5.numFrames,inf),
    \dur, Pseq([5/3],20),
    \trig, Pseq([0, 1,0, 1, 0, 1], inf)
);

~hun = Pbind(\instrument, \hunSaws, \dur, Pseq([8],4));
)

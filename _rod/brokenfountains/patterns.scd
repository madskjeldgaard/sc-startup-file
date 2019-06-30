
/********************************************

                PATTERNS

"The fountains were broken up by the tuning-fork"

********************************************/
~fje1.play;
~fjeder1.play;
~fjeder1.stop;

~fje2.play;
~fjeder2 = ~fjeder2.play(quant:1);
~fjeder2.stop;

~fje3.play;
~fjeder3 = ~fjeder3.play(quant:1);
~fjeder3.stop;


~fje4.play;
~fjeder4 = ~fjeder4.play(quant:1);
~fjeder4.stop;

~fje5.play;
~fjeder5 = ~fjeder5.play(quant:0);
~fjeder5.stop;

~fje6.play;
~fjeder6 = ~fjeder6.play(quant:1);
~fjeder6.stop;


// CONCRETE SOUND PATTERNS 
(
    ~fje1 = ~sounds[26];
~fjeder1 = 
    Pfindur(~pd,
    Pmono(\monoSamplePlay,
    \buf, ~fje1,
    \position, Pwhite(-1.0,1.0,inf),
    \rate, Pwhite(0.2,1.5),
    \wet, Pwhite(0.1, 1.0),
    \mix, 0.6,
    \loop, 1,
    \start, Pwhite(0, ~fje1.numFrames,inf),
    \dur, 1,
    \trig, Pseq([1,0], 10)
)
);

    ~fjebd = ~sounds[26];
    
~fjederBd = Pmono(\monoSamplePlay,
    \buf, ~fjebd,
    \rate, Pwhite(0.2,1.5,inf),
    \loop, 1,

    //\start, Pwhite(0, ~fje1.numFrames-1000,inf),
    \dur, Pseq([1/8, 1/8, 1/16, Rest(1), 1/16, 1/16],inf),
    \trig, Pseq([1,0,1], 8)
);
    ~fje2 = ~sounds[28];
~fjeder2 = 
Pfindur(12,Pmono(\monoSamplePlay,
    \buf, ~fje2,
    \rate, 2.2,
    \start, Pwhite(0, ~fje2.numFrames,inf),
    \dur, 1,
    \trig, Pseq([1,0], 8)
));
   ~fje3 = ~sounds[38];
   //~fje3.play; 
~fjeder3 = Pmono(\monoSamplePlay,
    \buf, ~fje3,
    \rate, 2.2,
    \position, Pbrown(-0.75,0.0, 0.1),
    \start, Pwhite(0, ~fje3.numFrames,inf),
    \dur, Prand([1/4, 1/8, 1/16,1],inf),
    \trig, Pseq([1,0], 19)
);
   ~fje4 = ~sounds[6];
~fjeder4 = Pmono(\monoSamplePlay,
    \buf, ~fje4,
    \rate, Pseq([1.5,0.4, 2.0],inf),
    \start, Pwhite(0, ~fje4.numFrames,inf),
    \dur, Pseq([1/32,1/32],48),
    \trig, Pseq([1,0], inf)
);


   ~fje5 = ~sounds[44];
~fjeder5 = Pmono(\monoSamplePlay,
    \buf, ~fje5,
    \wet, Pseq([0.0,0.25,0.5,0.75],inf),
    \position, Pbrown(0.0,1.0,0.1),
    \rate, Pwhite(0.4, 1.5,inf),
    \start,1000,// Pwhite(0, ~fje5.numFrames,inf),
    \dur, Prand([4,1, 4, 1, 1/8],8),
    \trig, Pseq([1,0, 1, 0, 1, 0], inf)
);

   ~fje6 = ~sounds[63];
~fjeder6 = Pmono(\monoSamplePlay,
    \buf, ~fje6,
    \spread, 0,
    \center, 1,
    \rate, Pwhite(0.4, 1.5,inf),
    \start,0,// Pwhite(0, ~fje5.numFrames,inf),
    \dur, Prand([4,1, 4, 1, 1/8],9),
    \trig, Pseq([1,0, 1, 0, 1, 0], inf)
);
)

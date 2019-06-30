// Load sound object archive
Task({
    "Loading folders with sound files ".postln;
    3.wait;
    o = Dictionary.new;
    o.add(\foldernames -> PathName("/Users/madskjeldgaard/Desktop/SOUNDCENTRAL/ALGOFODDER").entries);
        for (0, o[\foldernames].size-1,
        {arg i; o.add(o[\foldernames][i].folderName ->
        o[\foldernames][i].entries.collect({
            arg sf;
            Buffer.read(s,sf.fullPath);
            });
    );
    "Loaded %".format(o[\foldernames][i].folderName.quote).postln;
    });
    //wait, because otherwise it won't work for some reason
    3.wait;
    "Done loading sound files to buffers".postln;
}).start;

(
~pat1 = Pbind(
    \instrument, \bufferConvolve2, 
    \buffer1, Pseq(o["emf"], inf), 
    \rate1, Pseq([1,1,1.2,0.5, 1.5, 1.257, 0.25],inf),
    \buffer2, Pxrand(o["fb201"],inf) , 
    \autopan, Pkey(\rate1)/6,
    \rate2, Pkey(\rate1)/Pseq((1..4),inf)* [0.5, 1, 1.5],
    \loop, 1,
    \amp, 0.5,
    \dur, Pxrand([4, 8, 6], inf) * 4,
    \atk, Pkey(\dur)/3,
    \out, 0
);

~pat2 = Pbind(
    \instrument, \bufferConvolve2, 
    \buffer1, Pxrand(o["fb201"],inf), 
    \buffer2, Pxrand(o["emf"],inf), 
    \rate1, Pseq((1..5),inf) / Pxrand((2..7),inf),
    \autopan, Pkey(\rate1)/100,
    \loop, 1,
    \amp, 0.25,
    \dur, Pseq([4, 2, 6], inf)*2,
    \atk, 2,
    \out, 0
);

~pat3 = Pbindf(~pat2,
    \buffer2, Pxrand(o["hydro"],inf),
    \dur, Pseq((1..8),inf),
    \rate2, Pkey(\rate1)/5
);
~pat1.play;
)

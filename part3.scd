/**************************** 
        PART 3  
*****************************/
/*
~l2r1 = Pbind(
    \instrument, \warp2, 
    \amp, 0.3,
    \buffer, o["emf"][5],
    \overlaps, 8,
    \dur, 2.0/20,
    \pointRate, 1.25,
    \gdur, 0.01 + Pseries(0, Pkey(\dur)/20, inf),
    \rel, Pkey(\dur),
    \atk, 0, //Pkey(\dur),
    \pan, Pseries(-1,0.1, 20),
    \send, 1.0,
    \effectBus, ~grainbus,
    \out, 0
);

~r2l1= Pbind(
    \buffer, o["emf"][0],
    \overlaps, 64,
    \dur, 2.0/20,
    \gdur, 0.01 + Pseries(0, Pkey(\dur)/10, inf),
    \pointRate, 1 + Pseries(0, Pkey(\dur), inf),
    \pan, Pseries(1,-0.1, 20),
    \out, 0
);
~r2l1 = ~r2l1 <> ~l2r1;

~b1 = Plambda(Ptpar([0.0, ~l2r1, 1.0,~r2l1]));

//~bevaegelse1.play;

//fork{loop{"CPU usage: % ".format(s.avgCPU).postln ; 1.wait}};

~b2 = Pbind(
    \instrument, \samplePlayer2,
    \buffer, o["emf"][6], 
    \rate, 3*Pseq([1,-1],inf)*[0.25, 0.5, 0.75] * [1, 1.1], 
    \dur, Pseq([1,1/2],1),
    \rel, 0.1,
    \loop, 1,
    \atk, 0,
    \amp, 0.1,
    \out,0
    );

~b4 = Pbind(\buffer, o["emf"][1], \rate, Pseq([1,-1],inf)*[0.25, 0.5, 0.75]) <> ~b2;

~b5 = Pbind(\buffer, o["emf"][8]) <> ~l2r1;
**/

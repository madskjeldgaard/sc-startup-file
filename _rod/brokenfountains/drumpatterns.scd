~drums[\bd][1].postln;
~drums.index;
(
    // Load drum samples
~bd1 = Buffer.read(s, "/Users/madskjeldgaard/Desktop/scripts/sc/brokenfountains/909/bd/909BD_T1A3D6V1_X.wav");
~bd1.play;
~bd2 =  Buffer.read(s,"/Users/madskjeldgaard/Desktop/scripts/sc/brokenfountains/909/bd/909BD_T1A1D6V1_Tape.wav");
~bd2.play;
~bd3 =  Buffer.read(s,"/Users/madskjeldgaard/Desktop/scripts/sc/brokenfountains/909/bd/909BD_T1A1D11V1_Tape.wav");
~bd3.play;

~sd1 = Buffer.read(s, "/Users/madskjeldgaard/Desktop/scripts/sc/brokenfountains/909/sd/909SD_T6T3S3V1_Tape.wav");
~sd1.play;
~hh1 = Buffer.read(s, "/Users/madskjeldgaard/Desktop/scripts/sc/brokenfountains/909/hh/909HH_D3V1_Tape.wav");
~hh1.play;

~cp1 = Buffer.read(s, "/Users/madskjeldgaard/Desktop/scripts/sc/brokenfountains/909/perc/909ClapV2_Tape.wav");
~cp1.play;

)

(
~pd = 8; // Sets pattern duration of drums
~pd2 = 8;
// Big drum pattern 1

~bdrytm1 = [1/8,1/4,1/2,1/3,5/3,1,2].scramble;
~bdrytm2 = [1/8,1,1/4,1/2,1/16].scramble;
~bdpat1 = 
    Pfindur(~pd,
        Pbind(\instrument, \drumPlayerDry,
        \buf, ~bd3,
        \position,0,
        \rate,1.05,
        \atk, 0.000,
        \rel, 1.550,
        \wet, 0,
        \mix, 0.0,
        \loop, 0,
        \start, 0,
        \trig, Pseq([1,0], 10),
        \dur, Pseq(~bdrytm1,2)
        );
    );
~bdpat2  = 
    Pfindur(~pd,
        Pbind(\instrument, \drumPlayerDry,
        \buf, ~bd3,
        \position,0,
        \rate,1.05,
        \atk, 0.000,
        \rel, 2.050,
        \wet, 0,
        \mix, 0.0,
        \loop, 0,
        \start, 0,
        \trig, Pseq([1,0], 20),
        \dur, Prand(~bdrytm2,32)
        );
    );
    ~bdpat3 = 
    Pfindur(~pd,
        Pmono(\drumPlayer,
        \buf, ~bd3,
        \position,0,
        \rate,1,
        \wet,0,
        \mix, 0.0,
        \loop, 0,
        \start, 0,
        \dur, Pxrand(~bdrytm1,20),
        \trig, Pseq([1,0], 20)
        );
    );
// Snare drum pattern 1
~sdrytm1 = [5/3,1,2,3,4].scramble;

~sdpat1 = 
    Pfindur(~pd,
        Pmono(\drumPlayer,
        \buf, ~sd1,
        \position,0,
        \rate,2,
        \wet, Pwhite(0.1, 0.5),
        \mix, 0.2,
        \loop, 0,
        \start, 0,
        \dur, Pseq(~sdrytm1,2),
        \trig, Pseq([1,0], 10)
        );
    );


// Hihat pattern 1

~hhrytm1 = [5/3,1/8,1/2,3/5,1/4].scramble;
~hhrytm2 = [5/3,1/4,2/3,3,4].scramble;

~hhpat1 = 
    Pfindur(~pd,
        Pmono(\drumPlayer,
        \buf, ~hh1,
        \position,Pwhite(-1.0,1.0),
        \rate,1,
        \wet, Pwhite(0.1, 0.5),
        \mix, 0.2,
        \loop, 0,
        \start, 0,
        \dur, Prand(~hhrytm2,22),
        \trig, Pseq([1,0], 10)
        );
    );

    ~hhpat2 = 
    Pfindur(~pd,
        Pmono(\drumPlayer,
        \buf, ~hh1,
        \position,Pwhite(-1.0,1.0),
        \rate,Pseq([0.75,1,1.5,0.6]),
        \wet, Pwhite(0.1, 0.5),
        \mix, 0.2,
        \loop, 0,
        \start, 0,
        \dur, Prand(~hhrytm2,20),
        \trig, Pseq([1,0], 10)
        );
    );
    ~saw1 =
    Pfindur(~pd2,
    Pbind(\instrument, \hunSaws,
        \atk,1,
        \dur, Pseq([Rest(5),3],1)
    ));
    ~saw2 =
    Pfindur(~pd2,
    Pbind(\instrument, \hunSaws,
        \rel, 4,
        \dur, Pseq([2,Rest(6)],1)
    ));
    ~saw3 =
    Pfindur(~pd2,
    Pbind(\instrument, \hunSaws,
        \rel, 0.01,
        \atk, 4, 
        \dur, Pseq([2,Rest(6)],1)
    ));
// Clap Pattern
~cprytm1 = [1/8,1/4,1/2,1/3].scramble;
~cppat1 = 
    Pfindur(~pd,
        Pbind(\instrument, \drumPlayerDry,
        \buf, ~cp1,
        \position,Pbrown(-0.5,0.5,0.1, inf),
        \rate,1.22,
        \atk, 0.000,
        \rel, 1.550,
        \wet, 0,
        \mix, 0.0,
        \loop, 0,
        \start, 0,
        \trig, Pseq([1,0], 10),
        \dur, Pseq(~cprytm1,2)
        );
    );
~atmos1 = 
    Pfindur(64,
        Pbind(\instrument, \atmos1,
            \atk, 8,
            \rate, Pseq([0.1,0.3,0.3,0.5],inf),
            \panFreq, Pseq([9,18,36,72],inf),
            \gdur, Pseq([0.7,0.2,0.1,0.1],inf),
            \trigrate, Pseq([120,90,60,10],inf),
           \dur, Pseq([16,12,20,16],inf) 
));
~atmos2 = 
    Pfindur(64,
        Pbind(\instrument, \atmos1,
            \atk, 8,
            \rate, Pseq([0.11,0.25],inf),
            \inter, 4,
            \panFreq, Pseq([5,4,3,9],inf),
            \trigrate, Pseq([2,9,8,1],inf),
            \gdur, Pseq([0.6,0.6,0.6,0.5],inf),
           \dur, Pseq([16,12,20,16],inf) 
));
)
~cppat1.play;
~bdpat3.play(quant:4);
~bdpat1.stop;
~sdpat1.play(quant:4);
~bdpat3.play;
~hhpat1.play;
~drumSeq1.stop;
Pn(~atmos1,4).play;
~atmos2.play;
    

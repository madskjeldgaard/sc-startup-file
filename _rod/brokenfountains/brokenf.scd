/********************************************


                MAIN

"The fountains were broken up by the tuning-fork"


********************************************/

// Boot
s.boot;
s.reboot;
s.reset;
s.unmute;
s.meter;
// Set project tempo
(
var bpm = 100;
TempoClock.default.tempo = bpm/60;
)

(
    ~flood = {arg string, repetitions; repetitions.do{ string.postln;};};
    ~flood.value("The fountains were broken up by the tuning-fork. ",30);
)
/**************************************

               SAMPLES 

***************************************/
(

~sounds = Array.new;// Creat array for sounds

~folder = PathName.new("/Users/madskjeldgaard/Desktop/scripts/sc/brokenfountains/fjeder");

~folder.entries.do({ // Iterate over all sound files in folder and load them to buffers
	arg path;
	~sounds = ~sounds.add(Buffer.read(s, path.fullPath));
});

)
/**************************************

                SYNTHS

***************************************/
( 
    // ATMOSPHERE

    ~g1 = Buffer.read(s, "/Users/madskjeldgaard/Desktop/scripts/sc/brokenfountains/stretchatmos1.wav");
    SynthDef.new(\atmos1, {
    arg out=0,rate=0.3,lvl=0.5, position=0,atk=8,rel=8,grain=~g1,trigrate=120, gdur=0.2,inter=0, panFreq=5;
    var sig;
    var env = EnvGen.kr(Env.new([0,1,0], [atk,rel]), doneAction:2);
    sig = TGrains.ar(2,Dust.kr(trigrate),grain,dur:gdur, centerPos:0.5, pan: SinOsc.kr(panFreq).range(-1.0,1.0),rate:rate, interp:inter);
    sig = Splay.ar(sig);
    sig = sig * lvl;
    //sig = FreeVerb.ar(sig, 0.7,1.0,0.1,0.7);
    sig = sig * env;
    Out.ar(out,sig);
    }).add;

// HUNSAWS Left to right 

SynthDef.new(\hunSawsLR, {
    arg out=0, 
    atk = 0.05, rel=2, envlvl=0.9, curve=0.90, //Envelope parameters 
    maxL=(-0.95), maxR=0.95, pantime=rel/2; // Pan parameters
    var sig, freq;
    // Make array with x number of frequencies
    freq = Array.fill(10, { arg counter; (counter+10)*exprand(10, 100);});
    // Make x number of oscillators and mix them down with Splay, randomize spread
    sig = Splay.ar(
            Saw.ar(
                freq,// set frequency of osc 
                EnvGen.ar(Env.perc(atk, rel, envlvl, curve), doneAction:2);
                ), 
            spread: Saw.kr(exprand(1,5))*exprand(0.1, 0.9)
            );
    //sig = HPF.ar(sig, freq);
    sig = BPF.ar(sig, XLine.kr(10000, 500, rel)); 
    sig = RLPF.ar(sig, XLine.kr(20000, 500, rel-1), rq:1.1);

    sig = Balance2.ar(sig, sig, Line.kr(-1, 1,rel), 0.5);
    sig = Splay.ar(sig, spread: XLine.kr(maxR, maxL, pantime));
    Out.ar(out, sig);
}).add;

// HUNSAWS RIGHT to Left

SynthDef.new(\hunSawsRL, {
    arg out=0, 
    atk = 0.05, rel=2, envlvl=0.9, curve=0.90, //Envelope parameters 
    maxL=(-0.95), maxR=0.95, pantime=rel/2; // Pan parameters
    var sig, freq;
    // Make array with x number of frequencies
    freq = Array.fill(10, { arg counter; (counter+10)*exprand(10, 100);});
    // Make x number of oscillators and mix them down with Splay, randomize spread
    sig = Splay.ar( Saw.ar( freq, EnvGen.ar(Env.perc(atk, rel, envlvl, curve), doneAction:2);), spread: Saw.kr(exprand(1,5))*exprand(0.1, 0.9));
    sig = BPF.ar(sig, XLine.kr(10000, 500, rel)); 
    sig = RLPF.ar(sig, XLine.kr(20000, 500, rel-1), rq:1.1);

    sig = Balance2.ar(sig, sig, Line.kr(1, -1,rel), 0.5);
    sig = Splay.ar(sig, spread: XLine.kr(maxL, maxR, pantime));
    Out.ar(out, sig);
}).add;

// DRY SAMPLE PLAYER

SynthDef.new(\sampleDry, {
    arg buf, position=0, trig=0, out = 0, 
    start=0, rate=1.0, 
    atk=0.00, rel=0.225, amp = 1, 
    panrate=1.0, loop = 0, 
    channels = 1;
	var sig;
    var env = EnvGen.kr(Env.new([0,1,0], [atk,rel]),gate:trig, doneAction:2);
	sig = PlayBuf.ar(1, buf, rate*BufRateScale.ir(buf), loop,trigger:trig, startPos: start);
    sig = Balance2.ar(sig,sig, position,amp);
    sig = sig*env;
	Out.ar(out, sig);
}).add;
)
/**************************************

              PATTERNS 

***************************************/

(
    ~atmos1 = 
    Pfindur(64,
        Pbind(\instrument, \atmos1,
            \atk, 8,
            \rate, Pseq([0.1,0.3,0.3,0.5],inf),
            \panFreq, Pseq([9,18,36,72],inf),
            \gdur, Pseq([0.3,0.2,0.1,0.1],inf),
            \trigrate, Pseq([120,90,60,99],inf),
           \dur, Pseq([16,12,20,10],inf) 
));
    ~atmos2 = 
    Pfindur(64,
        Pbind(\instrument, \atmos1,
            \atk, 8,
            \rate,0.25,
            \lvl,2.4,
            \inter, 4,
            \panFreq, Pseq([5,4,3,9],inf),
            \trigrate, Pseq([2,9,8,1],inf),
            \gdur, Pseq([0.3,0.3,0.4,0.6],inf),
           \dur, Pseq([16,12,20,16],inf) 
));
    ~saw1 =
    Pbind(\instrument, \hunSawsRL,
        \atk, Pseq([4,8,8,8,8,8],inf),
        \rel, Pseq([4,8,8,8,8,12],inf),
        \dur, Pseq([8,12,12,12],1)
    );
    ~saw2 =
    Pbind(\instrument, \hunSawsLR,
        \atk, Pseq([4,8,8,8,8,8],inf),
        \rel, Pseq([4,8,8,8,8,12],inf),
        \dur, Pseq([8,12,12,12],1)
    );
    ~tgrain = 
    Pfindur(64,
        Pbind(\instrument, \atmos1,
            \atk, 8,
           \lvl, 1.5,
            \grain, ~sounds[48], 
            \rate,Pseq([2.0,1.5,2.5,2.75],inf),
            \inter, 4,
            \panFreq, Pseq([5,4,3,9],inf),
            \trigrate, Pseq([2,9,25,20],inf),
            \gdur, Pseq([0.3,0.4,0.5,0.5],inf),
            \dur, Pseq([16,12,20,16],inf) 
));
    ~tunefork1 = 
    Pbind(\instrument, \sampleDry,
        \buf, ~sounds[44], 
        \amp, Pwhite(0.7,1.1), 
        \rate, 0.5,
        \position, Pseq([-0.5,-0.3,0.0,1],inf),
        \atk, 0.3,
        \rel, Pseq([4,4,4],1),
        \dur, Pseq([6,6,6],1)
    );

    ~tunefork2 = 
    Pbind(\instrument, \sampleDry,
        \buf, ~sounds[46], 
        \rate, 1.5,
        \amp, Pwhite(0.4,1.1), 
        \position, Pwhite(0.0,0.7),
        \atk, 0.3,
        \rel, Pseq([2,2,2],1),
        \dur, Pseq([6,6,6],1)
    );

    ~tunefork3 = 
    Pbind(\instrument, \sampleDry,
        \buf, ~sounds[48], 
        \rate,[2.0,1.25,1.75],
        \amp, Pwhite(0.5,1.1), 
        \position, Pwhite(-0.5,0.7),
        \atk, 0.1,
        \rel, Pseq([2,2,2,2],1),
        \dur,Pxrand([2,8/5,2/3,1/8,5/3,3,1,1/2],8)
    );
    ~tunefork4 = 
    Pbind(\instrument, \sampleDry,
        \buf, ~sounds[48], 
        \rate,2.5,
        \amp, Pwhite(0.8,1.1), 
        \position, Pwhite(-0.5,0.7),
        \atk, 0.1,
        \rel, Pseq([2,2,2,2],1),
        \dur,Pxrand([2,5/3,8/5,3,1,1/8,1/2],8)
    );
    ~tunefork5 = 
    Pbind(\instrument, \sampleDry,
        \buf, ~sounds[48], 
        \rate,Pseq([2.5,2.0,1.5,1.0],inf),
        \amp, Pwhite(0.8,1.1), 
        \position, Pwhite(-0.5,0.7),
        \atk, 0.1,
        \rel, Pseq([2,2,2,2],1),
        \dur,Pseq([2,3,1/2,1/4],1)
    );
)
/**************************************

             MAIN SEQUENCE 

***************************************/
(
    s.prepareForRecord;
)
(
~intro = 
Pseq([
    Ppar([~tunefork3, ~tunefork3],1),
    Ppar([~tunefork1, ~tunefork2],1)
], 4);

~mainSeq = 
Pseq([
    ~saw1,
    Ppar([~saw2,~atmos1]),
    Ppar([~atmos1, Pn(~tunefork1,4), ~saw2],1),
    Ppar([Pn(~tunefork1,1),~atmos1],1),
    Ppar([Pn(~tunefork1,5,),~saw1,~saw2, ~atmos1],1),
    Pfindur(32, Ppar([~tunefork1]))
    ], 1 // Repeats

);
)
~atmos1.play;
~mainSeq.play;
    Pseq([~saw1,~saw2,~atmos1,~tunefork1],1).play;
    ~saw1.play;
// Recording
s.prepareForRecord;
(
s.record;
~tunefork1.play;
)
s.stopRecording;

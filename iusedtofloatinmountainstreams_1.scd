(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
//Record
//s.record;
)
/*
(
var phraselength = 256;
o = 4; //Pstutter(phraselength/2, Pseq([4,5],inf)); //Pstutter(256, Pseq([4,5],inf));
x = Pstutter(phraselength, Pseq([0,2,1,3,1,2,3,4],inf));
~s = {SinOsc.kr(0.0001)};

~p1 = Pbind(
    //\instrument, \pmPerc, 
    \degree, x+Pseq([0,0,0,5,4,5,6],inf),
    \root, 3,
    \octave, o,
    \scale, Scale.major,
    \pan, 1,
    \stretch, 0.90,
    \dur, Pbjorklund2(x+12, 5, inf)/(o*2),
    \atk, 0,
    \out, 0
);

~p2 = Pbindf(~p1.source,
    \degree, x+Pseq([1,3,5,7],inf),
    \octave, o,
    \pan, -1, 
    \dur, Pbjorklund2(5, x-3, inf)/(o*2)
);

~p3 = Pbindf(~p1.source,
    \degree, x + Pseq([0,5],inf), //Pseq([0,2,0,2,4,0,2,4,6],inf),
    \octave, o-1,
    \amp, 0.3,
    \pan, 0, 
    \dur, Pbjorklund2(11, x+7, inf)/(o*2)
);

~p4 = Pbindf(~p1.source,
        \degree, Pser([0,4,3,2], 2)
)
*/

(
var psteve= {|values, phraserepetitions, repeats=inf|

    var pat = Pfunc({
            p = Array.fill(values.size, { |i| 
                Pstutter(phraserepetitions, Pseq(values[..i]));
                i.postln;
            });
        ^Pseq(p, repeats)
    });

    ^pat;
};

var steps = [0,2,5];
/*
var transp = Pstutter(100, Pseq([
        0,
        0,
        Pseq([0,2,5,6], 1),
        Pseq([4,1,3,0], 1)
    ], inf));

// Pslide melodies
~p4 = Pbind(
    \transp, transp,
    \degree, Pslide(steps, inf, 3, 2) + Pkey(\transp),
    \scale, Scale.major,
    \dur,  Pbjorklund2(10, 3, inf)/8
).trace(\degree);

~p5 = Pbind(
    \transp, transp,
    \degree, Pslide(steps, inf, 2, 3),
    \scale, Scale.major,
    \octave, 4,
    \amp, 0.4,
    \dur,  Pbjorklund2(11, 3, inf)/8
).trace(\degree);

~p6 = Pbind(
    \transp, transp, 
    \degree, Pslide(steps, inf, 2, 3, 2),
    \scale, Scale.major,
    \octave, 3,
    \amp, 0.4,
    \dur,  Pbjorklund2(11, 9, inf)/8
).trace(\degree);
*/

var inc = Pfunc{

// The final melody. Should play through 0 first, then [0,4] then [0,4,5], etc. 
// and repeat each of these melody sizes in the number of times defined in repeatsMelodySize

var melody = [0,4,5,6,2,3,5]; 
var repeatsMelodySize = 4; 

/*

var a = Array.fill(melody.size, {|i|
	Pn(Pser(melody, i), repeatsMelodySize)
});*/

^Pser(melody, Pstutter(repeatsMelodySize, Pseq((0..melody.size),inf)));

};

// Pser
~p5 = Pbind(
    /* \degree, Pfunc({ var repetitions=4;
        a=Array.fill(10, {|i|
            Pn(Pser(steps, i), repetitions)
        });
        Pseq(a, inf);
    }),*/
    //\degree, Pser([1,5,2,7], Pseq((1..4),inf)),
    \degree, Pn(Pser((0..7), Pstutter(4, Pseq((0..4), inf))), inf),
    \scale, Scale.major,
    \octave, 4,
    \amp, 0.4,
    \dur,  0.25, //Pbjorklund2(11, 3, inf)/8
).trace(\degree);

)

s.meter;



(

var mel = [0,2,5,7];

~p1[0] = Pbind(
    \degree,  Pslide(mel, repeats: 1, len: 3, step: 1, start: 0, wrapAtEnd:
        true),
    \dur, 0.25
);

~p1.play(fadeTime:8);





)

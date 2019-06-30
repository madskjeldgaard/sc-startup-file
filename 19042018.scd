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

(

o = Pstutter(256, Pseq([4,5],inf)));

~s = {SinOsc.kr(0.0001)};

~p1[0] = Pbind(
    \instrument, \pmPerc, 
    \degree, Pseq([0,0,0,5,4,5,6],inf),
    \root, 3,
    \octave, o,
    \scale, Scale.major,
    \pan, 1,
    \stretch, Pkrlive(~s, 0.5, 1.0),
    \dur, Pbjorklund2(12, 5, inf)/(o*2),
    \atk, 0,
    \out, 0
);

~p2 = Pbindf(~p1.source,
    \degree, Pseq([1,3,5,7],inf),
    \octave, o,
    \pan, -1, 
    \dur, Pbjorklund2(5, 3, inf)/(o*2)
);

~p3 = Pbindf(~p1.source,
    \degree, Pseq([0,2,0,2,4,0,2,4,6],inf),
    \octave, o,
    \pan, 0, 
    \dur, Pbjorklund2(11, 7, inf)/(o*2)
);

)

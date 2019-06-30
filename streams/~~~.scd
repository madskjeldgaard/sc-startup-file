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
~p1[0] = Pmono(
    \es3mono,
    \degree, Pseq([0,4,5].pyramid,inf) ,
    \octave, 5,
    \scale, Scale.minor,
    \dur, Pbjorklund2(Pseq([7,8,5],inf), Pseq((9..30),inf), inf)/8,
    \atk, 0.02, //Pkey(\dur), 
    \rel, 0.9,
    \out, 10
);
~p1.fadeTime = 0;
~p1.play(fadeTime:0, out: 10, numChannels:2);
)

~p2[0] = Pmono(
    \es3mono,
    \degree, Pseq((0..7).pyramid(2),inf) ,
    \dur, Pbjorklund2(7, 10, inf)/8,
    \stretch, Pstutter(10, Pseq([1,2,3],inf)),
    \scale, Scale.minor,
    \atk, 0.01, //Pkey(\dur), 
    \rel, 1.0, 
    \out, 12
);
~p2.fadeTime = 0;
~p2.play(fadeTime:0, out: 12, numChannels:2);


(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
//StageLimiter.activate;
//Record
//s.record;
)
                        
(
~p1 = Pbind(\dur, Pseq([0.25,1,0.5],inf), \degree, Pseq([1,2,5],inf));

Preich(~p1.source, rate:0.13, repeats:inf ).play;
)

Pfsmmorph(~p1.source, 
        [ #[3,1], // entry states (chosen randomly)
            Pbind(\dur, 12, \degree, Pseq([10,12],3)), #[ 1, 1, 2], // 0
            Pbind(\dur, Pseq((0.25, 0.5 .. 2), 1), \degree, Pwrand([1,5,10], [0.8,0.1,0.1], repeats: 1)), #[1, 2], // 1
            Pbind(\degree, Pxrand((1..10),10)), #[0, 2], // 2
            Pbind( \dur, Pxrand([1/4, 1/2, 1/8])), #[1,3,4], // 3
            // terminal state:
            nil, nil // 4 (if the machine reaches this state, it stops)
        ]
).trace(\degree);


)

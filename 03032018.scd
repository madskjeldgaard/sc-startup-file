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
~p1[0] = Pbind(
    \instrument, \rawsaw, 
    \amp, 0.3,
    \freq, 110,
    \dur, Pseq([Proly(100, 'log'), Proly(100, 'lin')],inf),
    \loop, 1,
    \atk, 0, 
    \rel, 0.25, 
    \sus, 0,
    \out, 0
).trace(\dur);

~p1.play(fadeTime:0);
)
1.log(10)
(

~p = Ppatlace([
            Pn(p {: x / x.pow(2), x <- (1..100)}, inf),
            Pn(p {: Rest(x / x.pow(2)), x <- (1..100)}, inf)
            ],inf);

)



f = {|inval| if (inval.isNumber, {"oh yeah".postln}, {"no".post})};

s.meter;

10.(2)

l = Rest(all {: x, x <- (1..10), x.odd })

Platform.systemExtensionDir

10/10.pow(2)

~p1[0] = Pbind(
        \instrument, \samplePlayer2, 
        \buffer, o["percemerge"][4], 
        \amp, 0.3,
        \rate, 1.0, 
        \stretch, 0.5,
        \dur, Proly(50, 'log'),
        \loop, 0,
        \atk, 0, 
        \rel, 0.125, 
        \envcurve, \exp,
        \out, 0
    );

~p1.play(fadeTime:0);

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

~s = {SinOsc.kr(0.01)};

~p1[0] = Pbind(
    \instrument, \singrain, 
    \amp, 0.3,
    \scaler, Pwhite(0.5,5,inf),
    \detune, 1.005,
    \foldLo, -1 * Pkey(\scaler).wrap(0,1),
    \foldHi, 0.15,
    \freq, Pseq([400, 800, 2500, 100],inf),
    \stretch, Pkrlive(~s) * Pseq([1,2, 0.25, 0.5], inf, 0),
    \dur, Pkey(\scaler)* 0.04 * Pseq([1,Rest(1),1,2, Rest(3)],inf),
    \atk, 0 * Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

~p1.play(fadeTime:8);
~p1.scope;

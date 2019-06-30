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

~p1[0] = Pbind(
    //\instrument, \sampleplayer2_phaseSync_vox3,
    \instrument, \sampleplayer2_unison_vox3,
    \buffer, o["zeng"][0],
    \detune, Pwhite(0.0,0.5,inf),
    \amp, 0.3,
    \rate, 0.5 ,// Pseq([0,3,6],inf)/12, 
    \grainsize, 0.1,
    \dur, 2.25, 
    \loop, 0,
    \atk, 0 * Pkey(\dur), 
    \rel, 0, //Pkey(\dur), 
    \out, 0
).trace(\detune);

~p1.fadeTime=0;
~p1.play(fadeTime:0);

o.keys

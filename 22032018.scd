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

~p1[0] = Pbind(
        \instrument, Pseq([
            \oneShotSamplePlayer2, 
            \unisonSamplePlayer2_vox3,
            \loopingSamplePlayer2],
            inf),
        \buffer, Pseq(o["fbatmos"],inf), 
        \amp, 0.3,
        \stretch, 0.25*Pseq([3,0.25,3,4], inf, 0),
        \pitchenv, Pwrand([1,0], [0.1,0.9], repeats: inf),
        \start, Pseq([0.25, 0, 0.125],inf),
        \rate, 2*Pseq([1,1,1,-1],inf) * Pseq([1,3,2, 0.25],inf), 
        \dur, Pseq([0.5, 1/3, 1/4, 7], inf),
        \atk, Pkey(\dur), 
        \rel, Pkey(\dur) , 
        \envcurve, \exp,
        \out, 0
    );

~p1.play(fadeTime:1);

~p2[0] = Pbindf(~p1.source,
    \buffer, Pxrand(o["fbable"],inf), 
    \cutoff, 1500, 
    \loOrHi,1,
    \amp, 0.05,
    \rate, Pkey(\rate) * 2, 
    \dur, Pseq([8, 12, 16], inf),
    \loop, 1,
    \atk, 0 * Pkey(\dur), 
    \rel, Pkey(\dur), 
    \out, 0
);

(
~p2[1] = \filter -> {|in| 
    0.5*(in + FreqShift.ar(in, freq: [88,99,111] * [1, 1.05], phase: 0).sum )
}
)

~p2.play(fadeTime:8);


(
~p3[0] = {|freq=88, dt=0.1, fold=0.5| 
    var d = 1+dt;
    var i = Saw.kr(freq/1000).linlin(-1,1,0.75, 1.25) * 
    SinOsc.ar([freq,freq*d,freq*(d.pow(2))] * [1, d]).fold2(fold).sum / 15!2;
    i = i + FreqShift.ar(i, freq: (freq/2)*d.pow(3), phase: 2pi);
    i;
};

~p3.mold(2);

~p3[1] = \xset ->
   Pbind(\freq, Pseq([88, 99],inf), 
   \fold, Pseq([1.0, 0.5, 0.75],inf), 
   \dt, 0.05+Pwhite(0.01, 0.15,inf), 
   \stretch, 3,
   \dur, Pseq([5,10],inf)) 
)

1.1.pow(2)

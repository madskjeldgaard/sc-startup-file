/*
TODO: 
    - FIX ENVELOPES ON SAMPLERS (RELATIVE TO DUR)
    - LAMBDA LIVE
    - Priley (Ppar + Pbindf (STRETCH))

*/

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

~p2.play(fadeTime:0);

~s = {SinOsc.kr(0.01 * SinOsc.kr(0.0001))};

// MAN GRAIN 1
~p2[0] = Pbind(
    \instrument, \loopingSamplePlayer2, 
    \amp, 0.3,
    \loop, 1,
    \rate, 2*Pstutter(26, Pseq([2.0, 4, 0.5],inf)), 
    \stretch,(Pkrlive(~s, 0.05, 1) *4) ,
    \dur,Pn(Proly(steps: 100, curve: 'log', repeats:100), inf, \rol) / 10,
    \start, Pgate(Pseq([0.5, 0.3, 0.47, 0.4]), repeats: inf, key: \rol),
	\end, Pn(Pseries(0, 0.11, 100), inf) + Pkey(\start),
    \buffer, Pgate(Pseq(o["fbsc"]), inf, key:\rol), 
    \envcurve, Pseq([\lin, \exp, \sin, \wel, \sqr, \cub], inf, 0),
    \pan, Pwhite(-1,1,inf),
    \atk, 0.1*Pkey(\dur), 
    \rel, Pkey(\dur)*2, 
    \out, 0
);

// MAN GRAIN 2
~p3 = Pbindf(~p2.source, \buffer, Pgate(Pseq(o["percgong"]), inf, key:\rol),
\rate, Pkey(\rate) * 0.5, \pitchenv,0,\stretch, Pkey(\stretch) * 3);

// FB TEXTURES
~p4[0] = Pbindf(~p2.source,
    \instrument, \loopingSamplePlayer2, 
    \buffer, Pxrand(o["fbsc"],inf), 
    \amp, 0.15,
    \rate, 1.75, 
    \start, Pwhite(0, 0.75,inf),
    \end, Pkey(\start) + 0.1,
    \cutoff, 2500,
    \panfreq ,0.001,
    \loOrHi,1,
    \autopan, 1,
    \dur, Pseq([8, Rest(7), 12, 16], inf),
    \loop, 1,
    \out, 0
);

// REVERB N SHIT
(
~p2[1] = \filter -> {|in| in + ~p3 + (JPverb.ar(in + ~p4 + ~p3 , t60: 2,    damp: 0, size: 3, 
    earlyDiff: 0.707, modDepth: 0.9, modFreq: 1, 
    lowcut: 500, highcut: 2000)/2)};
)

/* ------------------------------------------ */


~p1[0] = Pbind(
    \instrument, \loopingSamplePlayer2, 
    \buffer, o["909bd"][14], 
    \amp, 0.3,
    \rate, Pseq([0.2, 0.5, 0.33],inf) * Pseq([1.0,-1],inf), 
    \start, Pn(Pseries(0.25, 0.1, 4), inf),
    \end, Pkey(\start) + 0.01,
    \dur, 0.1*Pseq([8, 12, 16], inf),
    \loop, 1,
    \atk, 0, 
    \rel, 0, 
    \out, 0
);

~p1.play(fadeTime:8);

s.meter;



/* ---------------------- */

(
~p1[0] = Pbind(
    \instrument, \oneShotSamplePlayer2,
    \buffer, o["909bd"][1],
    \rate, Pseq([0.55, 0.25, 0.59],inf),
    \start, 0.25, 
    \end, 0.66,
    \amp, 0.3,
    \dur, 0.1,
    \atk, 0 * Pkey(\dur), 
    \rel, 0.25*Pkey(\dur), 
    \out, 0
);
~p1 = Preich(~p1.source, 0.1, inf);
)
~p1.play(fadeTime:8);
(0.1..5)



ChaosGen.allSubclasses.do(_.postln);









(

var bubblesort = {arg array;
        array.size.do{|x|
            for(0, array.size-1-x, {|i| j = i+1; 
                    if (j != (array.size) and: {array[i] > array[j]}, 
                        {array.swap(i,j)}
                    );
            })
        }
    };

a = (1..10000).scramble;

bubblesort.(a);
a;
)

a.bubble

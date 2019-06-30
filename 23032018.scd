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


~output = Bus.audio(s,2);

(
    ~r ={ |dw=1|
        var i = ~output;
        i + (dw*JPverb.ar(i, t60: 1,    damp: 0, size: 3, 
            earlyDiff: 0.707, modDepth: 0.1, modFreq: 2, 
            lowcut: 500, highcut: 2000));

        };

        ~r.get(\dw);
        ~r.set(\dw, 0.5);
        ~r.mold(2);
        ~r.play(out: 0);
    )


~p1[0] = Pbind( \instrument, \oneShotSamplePlayer2, \buffer, Pseq(o["buffer"],inf), \amp, 0.3, \rate, 1.0, \dur, Pseq([8, 12, 16], inf), \loop, 1, \atk, 0 * Pkey(\dur), \rel, Pkey(\dur), \out, 0);

~p1.play(fadeTime:8);



max = 10

print "Starting"

for i in range(max):
    print "Counter:", i

print "Done"

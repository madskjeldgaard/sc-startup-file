/************************************

    SuperCollider meetup Oslo

    March 2019 !

    On today's menu:
    0. Not too bad coffee (could be worse)
    1. The round
    2. Class of the month ? 
    -- BREAK --
    3. Live coding
    4. Help eachother/look at specific projects
    5. Something else? 

    Contact: 
    mail@madskjeldgaard.dk


*************************************/


a = Collatz.new;

Collatz.calculate(800)
(
    ~playAtFreq = {arg freq, duration = 10, amp = 1.0;
        var theCollatz = Collatz.calculate(freq);
        var maxFrames = 300;
        var ampProfile = theCollatz.normalize;

        SynthDef(\sines, {arg rate = 1.0, amp = 1.0, pan = 0.0;
            var ampRate = duration / maxFrames;
            var envTimes = (ampRate ! ampProfile.size);
            var tailDuration = duration - envTimes.sum;
            var sig;
            var panEnv;
            var ampEnv = EnvGen.kr(
                Env(
                    ampProfile ++ 0.0,
                    envTimes ++ tailDuration * rate.reciprocal
                ),
                doneAction: 2
            );
            panEnv = ampEnv.linlin(0.0, 1.0, -1.0, 1.0);
            sig = SinOsc.ar(freq) * ampEnv * amp;
            Out.ar(0, Pan2.ar(sig, panEnv));
        }).play(args: [\rate, 1.0, \amp, amp])
    };
)
s.boot;
~playAtFreq.value(800, 60)
(
    var num = 10;
    num.do({
        var freq = rrand(40, 4000);
        ~playAtFreq.value(freq, 60, num.reciprocal)
    });
)

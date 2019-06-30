//Use headphones for these examples!

(


SynthDef(\warp, {arg dur = 1, buffer = 0, warp=0.5, amp = 0.5, size=0.1;

    var out, buflength, env;

    env = EnvGen.kr(Env([0.0001, 1, 0.0001], [0.1, 0.9], [4, -4]), timeScale: dur, doneAction: 2);

    buflength = BufDur.kr(buffer);

    // read in stereo ... can be any number of channels BUT these must match the 

    // number of channels in the buffer

    out = WarpIn.ar(SoundIn.ar([0,1]), buffer, warp, 2, size, -1, interp: 4);

    Out.ar(0, out * env * amp);

}).send(s);

)

(

~bufs = [];

r = Routine.run({

    var buf, synth, cond, thisnotedur;

    cond = Condition.new;

    30.do({

        thisnotedur = 4.rrand(12);

        // stretching by 0.5, need buffer for half the duration

        buf = Buffer.alloc(s, thisnotedur * s.sampleRate * 14.5, 2); 

        ~bufs = ~bufs.add(buf);

        s.sync(cond);

        a = Synth(\warp, [\dur, thisnotedur.postln, \buffer, buf, \warp, 0.25 +
            2.rand, \amp, 0.1, \size, thisnotedur/101]);

        1.wait;

        })

    });

)

// clean up

~bufs.do({arg me; me.free});

b.free;

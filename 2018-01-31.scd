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
)

(

~g = {arg grainsize=0.7, start=0.0, rate=0.51, life=0.11; 

    var buffer, sig, phasor, end, samplerate, grainend, env, curves; 


    grainend = grainsize * SampleRate.ir * LFNoise1.kr(10).linlin(0,1,1.0,1 + life);
    
    buffer = o["guitarobj"][0];

    end = (start * BufFrames.kr(buffer)) + grainend;

    phasor = Phasor.ar(1, 
            rate:BufRateScale.kr(buffer) * rate *
            LFNoise1.kr(110).linlin(0,1,1.0,1 + life) , 
            start:start*BufFrames.kr(buffer),
            end:end, 
            resetPos:0);

    env = EnvGen.kr(
        //Env.sine(grainsize), 
        Env.new([0,1,0], [grainsize/2, grainsize/2], curve: 'sin'),
        Impulse.kr(rate), doneAction: Done.none); 


    sig = BufRd.ar(2, 
            bufnum: buffer, 
            phase: phasor, 
            loop: 1, 
            interpolation: 4);

    Splay.ar(sig) * env;

};


)

~kbus = Bus.control(s, 1); // 1 channel control bus 

~d = {SinOsc.kr(0.701)};
~e = {SinOsc.kr(0.301).linlin(-1,1,0,1)};
~f = {SinOsc.kr(0.001,0,1,1.1)};


~p1 = Pbind(
    \instrument, \unisonSamplePlayer2_vox3, 
    \buffer, Pxrand(o["fbable"], inf), 
    \amp, 0.5,
    \rate, 0.5*Pkr(~d),    
    \detune, Pseq([0.1,0.25, 0.1875],inf),
    \start, Pwhite(0,0.75, inf),
    \dur, Pseq((2,4..12), inf)*Pkr(~f), 
    \atk, Pkr(~e), //Pkr(~kbus), //Pkey(\dur), 
    \rel, 4+Pkr(~e), 
    \pan, Pwhite(-1,1,inf),
    \out, 0
);

~p1.play(fadeTime:1);

~p2 = Pbind(
    \instrument, \phaseSyncSamplePlayer2_vox3, 
    \buffer, Pxrand(o["fbsc"], inf), 
    \amp, 0.5,
    \rate, 1.0+Pkr(~d),    
    \detune, Pseq([0.05,0.125, 0.15].reverse,inf),
    \start, Pwhite(0,0.75, inf),
    \dur, 2*Pseq((2,4..12), inf)*Pkr(~f), 
    \atk, Pkr(~e), //Pkr(~kbus), //Pkey(\dur), 
    \rel, Pkey(\dur) * Pkr(~e), 
    \pan, Pwhite(-1,1,inf),
    \out, 0
);

~p2.play(fadeTime:1);

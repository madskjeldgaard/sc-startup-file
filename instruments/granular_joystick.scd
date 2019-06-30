/************************************

            MAPPING

*************************************/
j = MKtl('p2', "arrogant_bastard");

p = Particular.new;

Pdefn(\instr, p.def);

Pdef(\g,
    Pbind(
        \instrument, Pdefn(\instr),
        \dur, Pdefn(\gdur, 0.1), 
        \freq, Pdefn(\gfreq, 444),
        \amp, Pdefn(\gamp, 1)
    )
).play;

/************************************

            SYNTHS

*************************************/
Ndef(\grain).gui;
(
    Ndef(\grain).mold(2, 'audio');

    Ndef(\grain, 
        {|dur=0.01, buffer, delay=1,rate=1, trig=1, gsustain=0.5, start=0.0, loop=1, atk=0.001, rel=0.999, g=1, grate=0.5, pan=1|
            var trigger = Impulse.kr(grate);

            var genv = EnvGen.kr(
                Env.perc(
                    atk, 
                    rel), 
                    trigger,  
                    levelScale: gsustain,  
                    levelBias: 0.0,  
                    timeScale: 1/grate,  
                    doneAction: 0
                );

                var buf = PlayBuf.ar(
                    2, 
                    buffer, 
                    grate * rate * BufRateScale.ir(buffer), 
                    1-trigger, 
                    start * BufFrames.ir(buffer), 
                    loop,  
                    doneAction: 0
                );

                buf = genv * buf;

                buf
            }
    ).fadeTime_(0.0001).set(\buffer, ~defaultbuf.bufnum).play;

    // Ndef(\grain)[1] = \filter -> {|in, delay=1| };
)

~defaultbuf = Buffer.read(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_real/metallic objects/metallic objects in oslo november 2018 rode nt55 cardio mono-001.wav",  startFrame: 0,  numFrames: -1,  action: nil,  bufnum: nil)



(
    var numgrains = 1250;
    { 
        numgrains.do{|i|
            // var gdur = ( sin(i) * 0.05 ).max(0.001);
            var gdur = i.linexp(0, numgrains, 0.001, 0.09);
            var amp = i.linexp(0, numgrains, 0.00001, 0.5);
            var rate = gauss(1.0,0.1) * gdur.reciprocal;

            Synth(p.def("expodec", "buf2"), [\buffer, ~defaultbuf, \amp, amp, \dur, gdur, \rate, rate, \atk, 0.001, \rel, 0.999]); 

            gdur.wait;
        } 
    }.fork

)

/*

noisy_fucker.scd
2019-05-09
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/

/************************************

PROCESSES

*************************************/
(
    var vsaw = {|f=0.25, offset=0.5, w=0.25, amp=0.1|
        VarSaw.ar( offset.linexp(0.0,1.0,0.1,10000.0) + ( f.linexp(0.0,1.0,40.0, 10000.0) - [1,0] ),  iphase: 0.0,  width: w * [1, 0.99],  mul: amp,  add: 0.0)
    };

    var fbsin = {|f=0.25, offset=0.5, fb=0.25, amp=0.1| SinOscFB.ar(f - [0, 1], fb * [0.99, 1.0],  mul: amp,  add: 0.0)};

    Ndef(\varsaw1, vsaw).play;
    Ndef(\varsaw2, vsaw).play;
    Ndef(\varsaw3, vsaw).play;

    Ndef(\fbs1, fbsin).play;
)

/************************************

MODULATION

*************************************/
(
    var fenv = {|t=0.10, a=0.05, s=0.2, r=0.75, c=0.9|
        var trigz = ( Dust.kr(t * 10.0,  mul: 1.0,  add: 0.0) > 0 ); 
        var dur = 1/( t * 10.0);

        EnvGen.kr(
            Env.linen(a, s, r, 1, c.linlin(0.0,1.0,-10.0,10.0)), 
            trigz,  
            levelScale: 1.0,  
            levelBias: 0.0,  
            timeScale: dur,  
            doneAction: 0
        );
    };

    var normalEnv = {|g=1, a=0.1,d=0.1,s=0.95,r=0.65,c=10|
        EnvGen.kr(Env.adsr(a,d,s,r,1,c), g,  levelScale: 1.0,  levelBias: 0.0,  timeScale: 1.0,  doneAction: 0).poll;
    };

    var trigsilent = {

    };

    Ndef(\fenv1, fenv).set(\t, 0.1, \a, 0.25, \s, 0.5, \r, 0.25);
    Ndef(\fenv2, fenv).set(\t, 0.5, \a, 0.01, \s, 0.25, \r, 0.74);
    Ndef(\fenv3, fenv).set(\t, 0.10, \a, 0.65, \s, 0.25, \r, 0.10);

    Ndef(\nenv1, normalEnv).set(\a, 0.05, \s, 0.95, \r, 0.20);
    Ndef(\nenv2, normalEnv).set(\a, 0.25, \d, 0.5, \s, 0.45, \r, 0.20, \c, 10);


    // Ndef(\lfo1, {|freq=1| LFNoise2.kr(freq)});
    // Ndef(\lfo2, {|freq=1| LFNoise1.kr(freq)});
    // Ndef(\lfo3, {|freq=1| LFNoise0.kr(freq)});
    // Ndef(\noise1).map(\atk, Ndef(\lfo1), \rel, Ndef(\lfo2), \c, Ndef(\lfo3));

    // Ndef(\noise2).map(\fb, Ndef(\fuckedenv), \freq, Ndef(\fuckedenv));
)
/************************************

PATCHING

*************************************/
(
    Ndef(\varsaw1).set(\offset, 0.2).map(\f, Ndef(\nenv1), \w, Ndef(\fenv3));
    Ndef(\varsaw2).set(\offset, 0.5).map(\f, Ndef(\fenv1), \w, Ndef(\fenv2));
    Ndef(\varsaw3).set(\offset, 0.656).map(\f, Ndef(\fenv3), \w, Ndef(\fenv1));

    Ndef(\fbsin1).set(\offset, 0.256).map(\f, Ndef(\fenv3), \fb, Ndef(\fenv1));

    Ndef(\fenv1).map(\t, Ndef( \nenv2 ));
    Ndef(\fenv3).map(\t, Ndef( \nenv1 ));

)


/************************************

MASTER FX

*************************************/
( 
    ProxyChain.add3(
        \leakDC,  \filter -> { |in, leak=0.99| LeakDC.ar(in, leak) },
        1,
        (\leak: [0.5, 0.999, \exp])
    ); 
    ProxyChain.add3(
        \delay,  \filter -> { |in, delay=0.5| 
            Greyhole.ar(in, delay.linlin(0.0,1.0,0.1,10.0),  damp: 0.0,  size: 1.0,  diff: 0.707,  feedback: 0.9,  modDepth: 0.1,  modFreq: 2.0)
        }, 
        2,
        (\delay: [0.0,1.0,\lin])
    );

    m = MasterFX.new(server: s,
        numChannels: 2,
        slotNames: [\leakDC, \delay],
        busIndex: 0
    );

    m.add(\leakDC, 0.99)

    // g = m.gui;
)

m.add(\delay, 1)
m.map(\rev, Ndef(\fenv1))
m.set(\rev, 0)

s.plotTree

MasterFX.clear('localhost')

MasterFX.all

/************************************

CONTROLLER

*************************************/

(
    j = MKtl('p1', "arrogant_bastard");
)

j.elAt(\bt_a).action = {|el| Ndef(\nenv1).set(\g, el.value.postln)}
j.elAt(\bt_b).action = {|el| Ndef(\nenv2).set(\g, el.value.postln)}

j.elAt(\joy_l_x).action = {|el| m.set(\wet1, el.value, \delay, el.value.postln)}
j.elAt(\joy_l_y).action = {|el| 3.do{|i| i=i+1; Ndef(( "varsaw" ++ i ).asSymbol).set(\offset, el.value)}}

Ndef(\nenv1).set(\g, 1);

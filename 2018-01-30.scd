~out = { SinOsc.ar([220, 330], ~out.ar(2).reverse * LFNoise2.kr(0.5, 4pi), 0.4)
};

// there is no immediacy: hear the buffer size cycle
~out = { Impulse.ar(1 ! 2) + (~out.ar(2) * 0.99) };

(
~verb= { arg modfreq = 0.03, decay=11.1; 
    var sig, ap1, ap2, ap3, ap4, ap5, lfo, in = ~out;

    lfo = Array.fill(4, {|i| x = 1+i; SinOsc.kr(modfreq / x, Rand(0, 2pi)).linlin(0,1,0,decay)}); 

    in = DelayC.ar(in: in, maxdelaytime: 0.2, delaytime: 10.2 + lfo[0]); 
    
    in = DelayC.ar(in: in, maxdelaytime: 0.2, delaytime: 10.2 + lfo[1]); 

    in = DelayC.ar(in: in, maxdelaytime: 0.2, delaytime: 10.2 + lfo[2]); 

    in = DelayC.ar(in: in, maxdelaytime: 0.2, delaytime: 10.2 + lfo[3]); 

    ap1 = AllpassC.ar(in: in + LocalIn.ar(1), maxdelaytime: 100, delaytime: lfo[0]+0.28675481329,
        decaytime: 30);
    ap2 = AllpassC.ar(in: in, maxdelaytime: 100, delaytime: lfo[1]+0.12613243421,
        decaytime: 30);
    ap3 = AllpassC.ar(in: in, maxdelaytime: 100, delaytime: lfo[2]+0.3261324,
        decaytime: 30);
    ap4 = AllpassC.ar(in: in, maxdelaytime: 100, delaytime: lfo[3]+0.5312212346,
        decaytime: 30); 

    LocalOut.ar(ap4); 

    sig = ap1+ap2+ap3+ap4;

    sig!2;
    }

)

~verb.play;

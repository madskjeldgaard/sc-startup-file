/***************** setup *****************/
MKtl.find('midi');
// l = MKtl('l', "akai-lpd888");
l = MKtl('nano', "korg-nanokontrol2");

l.trace(false);
l.trace(true);

Ndef.clear;

b = Buffer.read(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_field/BIRDS/Autumn birds getting chased in a garden in horsens nt55 omni (CLEAN).wav");
/***************** Audio *****************/
( 
    Ndef(\sampleplayer1, {|buffer, rate=1, trig=1, start=0, loop=1|
        var sig = PlayBuf.ar(1, 
            buffer, 
        [1,1.01] * ( 1-Ndef(\sampleplayer1).kr[0].lag3  )* rate * BufRateScale.kr(buffer), 
            trig, 
            start, 
            loop,  
            doneAction: 0
        );

        LeakDC.ar(sig,  coef: 0.995,  mul: 1.0,  add: 0.0)

    }).mold(2, 'audio').set(\buffer, b).map(\rate, Ndef(\lfomixer)).play;

/***************** Control *****************/

    Ndef(\lfomixer, {|in1, in2, in3, in4, scale=1|        
        // var sig = [ in1, in2, in3, in4 ];
        // sig = sig.sum / sig.size;
        var sig = in1*in2*in3*in4;
        sig * scale; 
    });

    Ndef(\lfo1,{|freq=0.4, amp=1|
        amp * LFSaw.kr( freq.linexp(0.0,1.0,0.001,30.0) )
    });

    Ndef(\lfo2,{|freq=0.25, amp=1|
        amp * LFCub.kr(
            freq.linexp(0.0,1.0,0.001,30.0), 0.12384
        )
    });

    Ndef(\lfo3,{|freq=0.321, amp=1|
        amp * LFPar.kr(
            freq.linexp(0.0,1.0,0.001,30.0), 0.8512
        )
    });

    Ndef(\lfo4,{|freq=1, amp=1|
        amp * LFNoise2.kr(
            freq.linexp(0.0,1.0,0.001,30.0),1.1234
        )
    });

    Ndef(\lfomixer).map(
        \in1, Ndef(\lfo1),
        \in2, Ndef(\lfo2),
        \in3, Ndef(\lfo3),
        \in4, Ndef(\lfo4)
    ); 

/***************** Map *****************/

    ~map = (
        actions:(
            freq1: {|el|Ndef(\lfo1).set(\freq, el.value.postln)},
            freq2: {|el|Ndef(\lfo2).set(\freq, el.value)},
            freq3: {|el|Ndef(\lfo3).set(\freq, el.value)},
            freq4: {|el|Ndef(\lfo4).set(\freq, el.value)},

            amp1: {|el|Ndef(\lfo1).set(\amp, el.value.postln)},
            amp2: {|el|Ndef(\lfo2).set(\amp, el.value)},
            amp3: {|el|Ndef(\lfo3).set(\amp, el.value)},
            amp4: {|el|Ndef(\lfo4).set(\amp, el.value)},

            scale: {|el|Ndef(\lfomixer).set(\scale, el.value)},

        )
    );

    l.elAt(\sl,0).action = ~map.actions[ \freq1 ];
    l.elAt(\sl,1).action = ~map.actions[ \freq2 ];
    l.elAt(\sl,2).action = ~map.actions[ \freq3 ];
    l.elAt(\sl,3).action = ~map.actions[ \freq4 ];

    l.elAt(\kn,0).action = ~map.actions[ \amp1 ];
    l.elAt(\kn,1).action = ~map.actions[ \amp2 ];
    l.elAt(\kn,2).action = ~map.actions[ \amp3 ];
    l.elAt(\kn,3).action = ~map.actions[ \amp4 ];

    l.elAt(\kn,4).action = ~map.actions[ \scale];
)

Ndef(\sine, {|f=0.1| SinOsc.ar(f.linexp(0.0,1.0,80,5000) !2,  phase: 0.0,  mul: 0.5,  add: 0.0)}).map(\f, Ndef(\lfomixer)).play

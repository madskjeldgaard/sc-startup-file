Ndef(\soundsource1, {|freq=0.25, numharm=0.5, freqoffset=0.2, amp=1, fbdelay=0.1, fbdecay=0.1, fbAmount=0|
    var minfreq=20, maxfreq=5000;
    var oldSig = fbAmount*AllpassC.ar(Ndef(\soundsource1).ar, 1.0, fbdelay.exprange(0.001, 0.2).lag, fbdecay.exprange(0.01, 2));
    var sig = 
    (oldSig+Blip.ar(
        freqoffset.linexp(0.0,1.0,minfreq,maxfreq) + freq.linexp(0.0,1.0,minfreq,maxfreq) + [0, - 1], 
        numharm.linexp(0.0,1.0,1,500) - [1, 0],
        mul: 0.25*amp,
        add: 0.0
    )).tanh;

    sig
});

Ndef(\soundsource1)[4] = \filter -> {|in, fs=0.1|  
    FreqShift.ar(in, fs.range(0.0,1.0),  phase: 0.0,  mul: 1.0,  add: 0.0)
};

Ndef(\soundsource1)[5] = \filter -> {|in, fs=0.1, ps=1.01, pd=0, td=0|  
    PitchShift.ar(in, 0.5, ps.range(0.1,4.0), pd, td,  mul: 1.0,  add: 0.0)
};

~soundsource1params = ~soundsource1params.add(\ps, \pd, \td, \wet5)
~soundsource1params = ~soundsource1params.add(\fbdelay, \fbdecay, \fs, \wet4)

Tdef('guillotineslikker').reset.play;

Tdef('guillotineslikker').play;

Ndef(\soundsource1).gui

Ndef(\soundsource1).fadeTime

Ndef('lfo4').fadeTime

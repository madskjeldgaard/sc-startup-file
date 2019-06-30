( 
    OSCdef.new(\un, {|...args| 
        var vals = args[0][1..].postln;
        Ndef(\harshnoise).set(\f, vals[0], \h, vals[1], \a, vals[2], 
        \wet1, vals[1].linlin(-1.0,1.0,1.0,0.0), \wet2, 1-vals[0].linlin(-1.0,1.0,1.0,0.0));
    }, '/fromUnity', recvPort:6666);
    OSCdef(\un).enable;
)
( 
    Ndef(\harshnoise, {|f=0.1, h=0.25, a=1.0| 
        Blip.ar(LFNoise2.kr * [0.5, 1.0, 2.0] * f.linexp(-1.0,1.0,80, 5000), h.linexp(-1.0,1.0,1,200), a.linlin(-1.0,1.0,0.0,1.5),  add: 0.0).sum!2
    }).mold(2);

    Ndef(\harshnoise)[2] = \filter -> {|in|  CrossoverDistortion.ar(in,  amp: 1.0,  smooth: 0.01,  mul: 1.0,  add: 0)};
    Ndef(\harshnoise)[1] = \filter -> {|in| GVerb.ar(in,  roomsize: 10,  revtime: 5,  damping: 0.1,  inputbw: 0.1,  spread: 35,  drylevel: 1,  earlyreflevel: 0.7,  taillevel: 0.5,  maxroomsize: 300,  mul: 1,  add: 0)};
)

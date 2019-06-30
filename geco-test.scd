n = NetAddr.new("127.0.0.1", 1592);
( 
    OSCdef.new('l1', {|...args| 
        var val = args[0][1];
        Ndef(\s1).set(\freq, val);
    }, '/right/open/posx', recvPort: 1592);
)

(
    Ndef(\s1, {|freq=0.4|
        SinOsc.ar(freq.linexp(0.0,1.0,20,12000).lag - [1, 0],  phase: 0.0,  mul: 1.0,  add: 0.0)
    }).play;
)

(
    l = MKtl('lpd', "akai-lpd8");
)

l.trace

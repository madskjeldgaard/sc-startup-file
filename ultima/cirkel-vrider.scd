~updateFreq=10;
n = NetAddr.new("127.0.0.1",  1212);

( 
    Ndef(\lfo).fadeTime=0.05;
    Ndef(\lfo, { 
        var sig = Array.fill(8, 
            { |i|
                SinOsc.kr(( (i+1)/8 ) / 100).linlin(-1.0,1.0,-180.0,180.0)
            }
        );
        
        Array.fill(8, {|x|
            SendReply.kr(Impulse.kr(~updateFreq), "/lfo/src" ++ x.asString, sig[x]);
        });
    });
)
(
 
    Ndef(\lfo2).fadeTime=0.05;
    Ndef(\lfo2, { 
        var sig = Array.fill(8, 
            { |i|
                SinOsc.kr(( (i+1)/8 ) / 99).linlin(-1.0,1.0,-180.0,180.0)
            }
        );
        
        Array.fill(8, {|x|
            SendReply.kr(Impulse.kr(~updateFreq), "/lfo/ele" ++ x.asString, sig[x]);
        });
    });

)
( 

    a = {|sourcenum|"/MultiEncoder/azimuth%".format(sourcenum)};

    (0..7).do{|src|
        OSCFunc({|msg, time, addr, port|
            var val = msg[3];
            n.sendMsg(a.(src), val);
        }, "/lfo/src" ++ src.asString );

    };

    c = {|sourcenum|"/MultiEncoder/elevation%".format(sourcenum)};

    (0..7).do{|src|
        OSCFunc({|msg, time, addr, port|
            var val = msg[3];
            n.sendMsg(c.(src), val);
        }, "/lfo/ele" ++ src.asString );

    };

)


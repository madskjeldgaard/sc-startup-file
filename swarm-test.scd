/*

swarm-test.scd
2019-03-19
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/

~targetIP="127.0.0.1";
~port1=8888;
n = NetAddr.new(~targetIP, ~port1);

// ~voice={|LFOTYPE, targetPort, numSources|}

(
    ~numSources=8;

    ~numSources.do{|i| 
        Ndef("sine" ++ i, {|freq=1| 
            OSCvarsaw.kr(freq*0.01, width: SinOsc.kr(0.1).abs, internalAddress: ( "/lfo" ++ i ).asSymbol )}
        ).fadeTime_(0.1).set(\freq, (i+1)/~numSources);

        OSCdef("lfo" ++ i, {|msg ... args| 
            n.sendMsg("/MultiEncoder/azimuth" ++ i, msg[3]); 
            n.sendMsg("/MultiEncoder/elevation" ++ (~numSources-1-i), msg[3]);
        }, "/lfo" ++ i);
    };
)

s.plotTree;



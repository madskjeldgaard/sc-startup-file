b = Buffer.read(s, "/Users/madskjeldgaard/Projekter/User\ Library/Sounds/SYNTHS/Full/Serge-DIEM-22-08-2017.wav");

p = ProxySpace.push(s);


(
~serge[0] = {|r=1.05, buffer, trig=1, start=0, l=1, pan=0| 
    var sig = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * r, trig, start * BufFrames.kr(buffer), l, doneAction:0);

    Pan2.ar(sig);
}
)

(
p = ProxySpace.push(s);
p.fadeTime = 2;
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
)


(
var b = Buffer.alloc(s, 2048, 1);

~fft = {
    var in, chain, sig,cutoff=3400, coffset=250, rate=1.0, trig=1, start=0, loop=1;

    //in = Saw.ar(SinOsc.kr(0.022).range(0.25,1.0) * [210, 215, 333, LFPar.kr(0.25).range(222,555)] + Saw.ar(0.01)).sum * 0.1;
    in = PlayBuf.ar(1, o["emf"][5], BufRateScale.kr(o["emf"][5]) * rate, trig, start, loop, doneAction:2);

    // Do calculations on the FFT data

    chain = FFT(LocalBuf(1024), in);
     
    chain = chain.pvcollect(b.numFrames, {|mag, phase, index|
        [mag * LFTri.kr(0.5).range(0.05,2), 
        phase * LFCub.kr(0.1 ).range(0.5, 30)] ;
    }, frombin: 0, tobin: 512, zeroothers:0);

    sig = LeakDC.ar(IFFT(chain));

    sig;
    /*
    DFM1.ar(sig, freq: 20 + coffset + (cutoff * LFPar.kr([0.112, 0.112 +
        LFPar.kr(0.01).range(0.001, 0.05)])), res: LFTri.kr(0.21).range(0.1,0.4), 
        inputgain: 1, type:0, noiselevel: 0.0003)*/$

};

~fft.play;

)

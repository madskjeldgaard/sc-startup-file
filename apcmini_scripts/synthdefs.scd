(
var lagTime = 0.1;

SynthDef(\apcwarp, {|bus, x, y, buffer, freqSlider, shimmerSlider, 
    grainsizeSlider, overlapSlider, randgrainSlider, loopLengthSlider, hpf, q,  envbuf=(-1), amp=0.75|

    var xy = ((x+y) / 64).linlin(0,1,0.0001,1.0);

    var wobble = WhiteNoise.ar(xy * shimmerSlider * 0.1); 
    var loopLength = (1/64) * loopLengthSlider;
    var pointer = LFSaw.ar(BufDur.ir(buffer).reciprocal).range(xy,
        xy+loopLength);

    var sig = 
        Warp1.ar(2, 
        bufnum: buffer, 
        pointer: pointer ,
        freqScale: wobble+(0.5*freqSlider), 
        windowSize: grainsizeSlider.clip(0.01,2.0) * xy, 
        envbufnum: -1, 
        overlaps: overlapSlider.linlin(0,1,0.001,4) * xy, 
        windowRandRatio: randgrainSlider, 
        interp: 4);

    //sig = BPF.ar(sig, 400 + (14000 * xy * bpf * wobble), q * 4 );
    sig = HPF.ar(sig, 80 + (20000 * hpf) );

    Out.ar(bus, sig * amp)

}, lagTime.dup(9)).add
)

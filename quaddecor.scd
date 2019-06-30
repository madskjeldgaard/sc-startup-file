/* --- EFFECT AUX: quadDecor --- */

~quadDecorBus = Bus.audio(s, 1); // 1 channel audio bus 

SynthDef(\quadDecor, {
    arg out=0, amp=1.0, inBus = ~quadDecorBus;

    var sig, in, chain;

    // Signal
    in = In.ar(inBus, 1);
    chain = FFT(LocalBuf(2048), in);
    chain = PV_Decorrelate()
    sig = ov;
    
    sig = sig * amp;
    Out.ar(out, sig)
}).add;




// Modulation function
( 
    f = {|freq=1, amp=1, which=0.0|
        var sigs = [
            SinOsc.kr(freq,  phase: 0.0, mul: amp,  add: 0.0),
            LFTri.kr(freq, mul: amp),
            SinOsc.kr(freq,  phase: 0.0, mul: amp,  add: 0.0).fold2(0.5),
            LFNoise2.kr(freq, mul: amp),
            LFCub.kr(freq, mul: amp),
            LFSaw.kr(freq,  iphase: 0.0, mul: amp,  add: 0.0),
            LFPar.kr(freq, mul: amp),
            LFPulse.kr(freq,  iphase: 0.0,  width: 0.5, mul: amp,  add: 0.0)
        ];

        SelectX.kr(which * sigs.size, sigs,  wrap: 1).linlin(-1.0,1.0,0.0,1.0);
    };

    Ndef(\ctrl, f).fadeTime_(0.1);
)
Ndef(\mouse, {MouseX.kr()});
Ndef(\ctrl).map(\which, Ndef(\mouse));
Ndef(\ctrl).gui.scope;
// Controller mapping

// OSC

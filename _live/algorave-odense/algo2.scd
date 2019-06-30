~warp.play;

~warp.set(\rate, 0.125, \grainsize, 0.35);

~warp[1] = \xset -> Pbind(\dur, 16, \pitchscale, Pseq([0.5, 1.0, 0.125],inf), \rate, Pseq([0.001, 0.0025, 0.0051234, 0.091234],inf), \grainsize, Pseq([0.5, 0.025, 0.001],inf));

~warp.fadeTime;

(
~warp.fadeTime = 16;
~warp[0] = {|buffer, rate=1, grainsize=0.125, pitchscale=0.5| 

    0.05 * Warp1.ar(2, bufnum: buffer, pointer: LFCub.kr(rate), freqScale: pitchscale,
        windowSize: grainsize, envbufnum: -1, overlaps: 32, windowRandRatio: 0.1, interp: 4);
    };
)

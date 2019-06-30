/* f = "~/Desktop/scripts/sc/apcmini_scripts/snd/bird.wav".standardizePath; */
f = "~/Desktop/scripts/sc/apcmini_scripts/snd/bach.wav".standardizePath;
b = Buffer.read(s, f, startFrame: 0, numFrames: -1);

(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
//Record
//s.record;
)



(
~w = { |overlaps=4, stretch=1, windowsize=2, wwinsize=0.1, wwinoverlap=8, wwinran=0.1, harm=1|
WarpOverlap.ar(2, b, overlaps: 16, starttime: 90, stretch: 8, harm: 2.5,
    windowsize: 3, step: 0.25, warpwindowsize: 0.91, warpwindowoverlaps: 16,
    warpwindowran: 0.2, mul: 1, add: 0) 
};
~w.play;
)

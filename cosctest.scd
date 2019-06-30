SynthDef(\fm7apc, {
    arg out=0, buffer, amp=1.0, freq=440, effectBus, send=0,
    atk=1, sus=1, rel=1, pan=0;
    var env, sig, ctrls, mods;

    a = ~apcmidicc.kr(128);
    // Envelope
    env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, sus, rel]), doneAction:2);

    ctrls = [
        // Freq, phase, amp
        [freq * 1.44 * a[48], 0, 1],
        [100+freq.rand * a[49], 0, 1],
        [freq* a[50], 0, 1],
        [freq*5 * (1-a[51]), 0, 1],
        [153+freq*a[52], 0, 1],
        [43+freq.rand * a[53], 0, 1]
    ];
    mods = Array.fill(6, {|x| var i=a[48+x]/10;
        [LFTri.kr(i).range(0,1), LFPar.kr(i).range(0,1), LFSaw.kr(i).range(0,1), 
        LFGauss.kr(i).range(0,1), LFNoise1.kr(i).range(0,1),
        LFNoise2.kr(i).range(0,1)].scramble});

    // Signal
    sig = FM7.ar(ctrls, mods);
    sig = sig +
        WaveLoss.ar(in:sig, drop: a[53]*20, outof: 40, mode: 2) + 
        (0.5*FreqShift.ar(sig, freq: freq * 1.7523* a[53], phase: 0));

    sig = PitchShift.ar(in: sig, windowSize: a[54], pitchRatio: 2*a[55],
    pitchDispersion: a[56], timeDispersion: 0);

    sig = Splay.ar(sig, a[56]); 
    sig = Pan2.ar(sig, pan);

    sig = sig * env * amp * 0.1;
    Out.ar(effectBus, sig*send);
    Out.ar(out, sig )
}).add;

Synth(\fm7apc, [\atk, 9, \sus, 8, \freq, 444])


(
var datetime = Date.getDate.format("%d%m%Y_%H:%M:%S"), 
path = "/Users/madskjeldgaard/Desktop/ableton/User\ Library/Sounds/SUPERCOLLIDER_RECORDINGS";

fork{loop{var dur =64, freq = [140, 177, 320, 93,293]; "boom".postln;Synth(\fm7apc, [\atk, dur/5, \sus, dur,
    \freq, freq.choose]); dur.wait;}};
s.record(path ++ "/" ++ "sc_" ++ datetime ++ "." ++ s.recHeaderFormat);

//s.stopRecording
)


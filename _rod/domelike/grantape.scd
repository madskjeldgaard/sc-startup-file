s.reboot;
s.reset;
s.quit;

(
SynthDef.new(\graintape, {
    arg buf, out, pos=0.1, amp,
    pulsefreq, rate=0.1, dur=1.0, envbuf;
    var klank, sig, env;
    var durate = Rand(0.01,0.3);
    env = EnvGen.kr(Env.new(
         [0.01, 0.3, 0.6, 0.9, 0.3, 0.01], 
         [0.01, 3, 5, 3, 2],
         curve: 'exp'
     ), doneAction:2);
    sig = GrainBuf.ar(2, 

        trigger: Dust.ar(pulsefreq), 
        dur: dur, 
        sndbuf:buf, 
        rate: rate,
        pos: pos,
        pan: SinOsc.kr(0.25).range(-0.7, 0.7),
        envbufnum: envbuf,
        interp:4

    );
    //klank = Klank.ar(`[[400, 800,1600], nil, [dur, dur, dur]], sig) * (amp);
    sig = BPF.ar(sig, freq: SinOsc.kr(0.125).range(100, 10000));
    sig = CombC.ar(sig, maxdelaytime: 0.5, delaytime:0.2, decaytime:1);
    //sig = Mix.new([klank, sig]);
    sig = sig * env;
    Out.ar(0, sig*amp);


}).add;
)
(
SynthDef.new(\warper, {
    arg buf, out, amp, envbuf=(-1);
    var sig;
    sig = Warp1.ar(1, 
        bufnum: buf,
        freqScale: 1.050,
        windowSize: 0.5,
        windowRandRatio:0.5,
        envbufnum: envbuf,
        
        overlaps: 1,
        interp: 4
        );
     sig = Pan2.ar(sig,
         pos: 0,
         level: 1
     );
     Out.ar(0, sig*amp);
}).add;
)
~buff = Buffer.read(s, "/Users/madskjeldgaard/Desktop/grn2.wav"); 
~buff2 = Buffer.read(s, "/Users/madskjeldgaard/Desktop/grn4.wav"); 
~s = Synth.new(\graintape, [\buf, ~sounds[9]]);
~s.free;
~i = Synth.new(\graintape, [\buf, ~sounds[50], \rate, 5.0, \pulsefreq, 1000, \pos, 0.5, \envbuf, ~grainenvs.value('tri', 0.01), \dur,0.01, \amp,0.8]);
~i.free;
~f = Synth.new(\warper, [\buf, ~sounds[7], \amp, 0.5]);
~f.free;
~sounds.size;

s.options.memSize = 8192*16;

s.reboot;
s.record

p = ProxySpace.push(s);

~z.play;
~z.fadeTime = 4;
b = Buffer.read(path: "/Users/madskjeldgaard/ableton/User\ Library/Sounds/_FIELD/_LOCATIONS/POLEN/Train\ mazurian\ lakes\ piezo\ on\ door.WAV");

~m1 = {MouseX.kr};
~m2 = {MouseY.kr};


~l1.fadeTime = 8;
~l1 = {Saw.kr(~m1, mul:2, add: 0.25)};

~l2.fadeTime = 8;
~l2 = {(~l1+1)* LFCub.kr(~m2, phase: 0, mul:1, add: 0.25)};


~z[0] = {|rate=1| PlayBuf.ar(2, b, BufRateScale.kr(b) * rate * ~l1, 1, 0, 1, doneAction:0);};
~z[1] = \filter -> { |in| FreqShift.ar(~z, freq: ~l2 * 1, phase: 0)};
~z[2] = \filter -> { |in, w=0.5| PitchShift.ar(in: in, windowSize: w, pitchRatio: 2, pitchDispersion: w, timeDispersion: ~l2)};

~z.xset(\wet1, 0.25);
~z.xset(\wet2, 0.75);

~z[3] = \set -> Pbind(
        \dur, Pseq([5,2,7],inf),
        \w, Pwhite(0.01, 1.0,inf)
    );

~z[4] = \filter -> { |in, w=0.5| PitchShift.ar(in: in, windowSize: w.reciprocal + 0.01, pitchRatio: 0.5, pitchDispersion: ~l1, timeDispersion: ~l2)};

~z.xset(\wet4, 0.75);
~z[5] = \filter -> {|in| balance2.ar(in[0], in[1], pos: ~l1)};

~z[6] = \filter -> { |in, w=0.5| PitchShift.ar(in: in, windowSize: w.reciprocal + 0.21, pitchRatio: 1.5, pitchDispersion: ~l2, timeDispersion: ~l1)};

~z[7] = \filter -> {|in| Balance2.ar(in[0], in[1], pos: ~m1)};

~z[8] = \filter -> {|in| MembraneCircle.ar(in, tension: (~l2 * 0.05) * 0.001, loss: 0.99999) * 0.1};
~z.xset(\wet8, 0.5);


~y.play
~z.stop;

s.record

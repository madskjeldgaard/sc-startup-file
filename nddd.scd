
Ndef(\h, {|f=110|SinOsc.ar(f)}).play;
Ndef(\h, {|f=110|SinOsc.ar(f)}).fadeTime_(15);
Ndef(\h)[1] = \filter -> {|in| in*0.9};
Ndef(\h).xset(\f, rrand(90, 300));

Ndef(\u, {LFSaw.kr(0.1).exprange(70, 500)});

Ndef(\h).xmap(\f, Ndef(\u))

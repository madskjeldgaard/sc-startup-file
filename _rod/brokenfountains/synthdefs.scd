
(// SAMPLE SYNTH
SynthDef.new(\monoSamplePlay, {
    arg buf, position=0, trig=0, start=0, amp = 1, out = 1, panrate=1.0, loop = 0, rate, channels = 1;
	var sig, mix=0.5, room=0.6, damp=0.2, wet=1.0; // Signal
    var env = EnvGen.kr(Env.new([0,1,0], [0.1,1]));
	sig = PlayBuf.ar(1, buf, rate*BufRateScale.ir(buf), loop,trigger:trig, startPos: start);
    sig = Pan2.ar(sig, position);
    sig = sig + FreeVerb.ar(sig,mix,room,damp,wet);
	Out.ar(out, sig);

}).add;
)

(// DRUM SYNTH
SynthDef.new(\drumPlayer, {
    arg buf, position=0, trig=0, start=0, amp = 1, out = 1, panrate=1.0, loop = 0, rate, channels = 1;
	var sig, mix=0.5, room=0.6, damp=0.2, wet=1.0; // Signal
    var env = EnvGen.kr(Env.new([0,1,0], [0.1,1]));
	sig = PlayBuf.ar(1, buf, rate*BufRateScale.ir(buf), loop,trigger:trig, startPos: start);
    sig = Pan2.ar(sig, position);
    sig = sig + FreeVerb.ar(sig,mix,room,damp,wet);
	Out.ar(out, sig);

}).add;
)
(// DRY DRUM SYNTH
SynthDef.new(\drumPlayerDry, {
    arg buf, position=0, trig=0, start=0,atk=0.00,rel=0.225,ts=1.0, amp = 1, out = 1, panrate=1.0, loop = 0, rate, channels = 1;
	var sig, mix=0.5, room=0.6, damp=0.2, wet=1.0; // Signal
    var env = EnvGen.kr(Env.new([0,1,0], [atk,rel]),gate:trig);
	sig = PlayBuf.ar(1, buf, rate*BufRateScale.ir(buf), loop,trigger:trig, startPos: start);
    sig = Pan2.ar(sig, position);
    sig = sig*env;
	Out.ar(out, sig);
}).add;
)
( // ATMOSPHERE
    ~g1 = Buffer.read(s, "/Users/madskjeldgaard/Desktop/scripts/sc/brokenfountains/stretchatmos1.wav");
    SynthDef.new(\atmos1, {
    arg out=0,rate=0.3, position=0,atk=8,rel=8,trigrate=120, gdur=0.2,inter=0, panFreq=5;
    var sig;
    var env = EnvGen.kr(Env.new([0,1,0], [atk,rel]));
    sig = TGrains.ar(2,Dust.kr(trigrate),~g1,dur:gdur, centerPos:0.5, pan: SinOsc.kr(panFreq).range(-1.0,1.0),rate:rate, interp:inter);
    sig = Splay.ar(sig);
    sig = sig * 0.2;
    sig = FreeVerb.ar(sig, 0.7,1.0,0.1,0.7);
    sig = sig * env;
    Out.ar(out,sig);
    }).add;

)
Synth(\atmos1);

p = ProxySpace.push(s);

p.fadeTime=10;
ProxyMixer.new;

(
~i = { arg maxdelay=1, delaytime=0.1;
	//var in = Impulse.ar(0.1)*5;
	var in = Dust2.kr(1)*PinkNoise.ar(5)*Saw.kr(0.1).range(0,1);
	var node = FbNode(2, 60, 2);
	var sig = FreqShift.ar(LeakDC.ar(node.delay(0.0001 + SinOsc.kr(0.1).range(0.001, delaytime))) + in, 100 + Saw.kr(0.1, 11));
	sig = sig + PitchShift.ar(node.delay(SinOsc.kr(0.1).range(0.001, delaytime)), 0.2, SinOsc.kr(0.01).range(0.1,2));
	sig = sig + Pan2.ar(BPF.ar(sig, Saw.kr(1).range(80, 5000)), SinOsc.kr(1));
	sig = Limiter.ar(sig.sum*10);
	node.write(sig);
	sig;
};

)
(

~g.play;
~g = {
	var sig = ~i!2;
	sig = FreqShift.ar(sig, 110 + Saw.kr(0.001,5));
	Out.ar(0, sig );
};

)

////////// bussssssss //////////

~feedbackbus = Bus.audio(s,2);
~saw1 = {LFSaw.kr(5,0, 2, 1)};
~saw2 = {LFSaw.kr(0.01 * ~saw1, 0, 0.5, 1)};
~fbin = { InFeedback.ar(~feedbackbus, 2)};


(
~f2.play(0,2);
~f2 = { arg delaytime=0.05, decaytime=2.5;
	var in = Dust2.kr(1)*WhiteNoise.ar(4);
    var fb = ~fbin;
	var sig = AllpassL.ar(fb + in,30,delaytime * SinOsc.kr(~saw1).range(0.1,1), decaytime);
	sig = FreqShift.ar(LeakDC.ar(sig) + in, 300-[333,444,521]+LFNoise0.kr(~saw1).range(-55,55).lag(1));
	sig = sig + PitchShift.ar(sig, 0.2, 1-~saw2, 0.5, 0.57);
	sig = sig
	+ (MouseY.kr*Compander.ar(JPverb.ar(sig, MouseX.kr(0.1,1), 0.0, 1, 0.6, ~saw2, ~saw1), sig, 0.5, 1, 1, 0.01, 0.02))
	+	(MembraneHexagon.ar(Median.ar(3, sig), 0.0001 + (~saw1/331)) * 0.01);
	sig = Splay.ar(sig*2, ~saw2);
	sig = Limiter.ar(LeakDC.ar(sig), 0.95);
	Out.ar(~feedbackbus, sig);
	Out.ar(0, sig*0.5);
};

)
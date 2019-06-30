(

OSCdef(\ring1x, {|msg, time, addr, recvPort| Ndef('rob').set(\f1, msg[1].linexp(0.0,1.0,40,5000).lag3)}, '/Container/RingArea1/x');
OSCdef(\ring1y, {|msg, time, addr, recvPort| Ndef('rob').set(\w1, msg[1], \amp, msg[1])}, '/Container/RingArea1/y');
OSCdef(\ring1z, {|msg, time, addr, recvPort| Ndef('rob').set(\g, msg[1]); msg[1].postln}, '/Container/RingArea1/z');

OSCdef(\ring2x, {|msg, time, addr, recvPort| Ndef('rob').set(\f2, msg[1].linexp(0.0,1.0,40,5000).lag3)}, '/Container/RingArea2/x');
OSCdef(\ring2y, {|msg, time, addr, recvPort| Ndef('rob').set(\w2, msg[1]); }, '/Container/RingArea2/y');

OSCdef(\ring3x, {|msg, time, addr, recvPort| }, '/Container/RingArea3/x');
OSCdef(\ring3y, {|msg, time, addr, recvPort| }, '/Container/RingArea3/y');

OSCdef(\ring4x, {|msg, time, addr, recvPort| }, '/Container/RingArea4/x');
OSCdef(\ring4y, {|msg, time, addr, recvPort| }, '/Container/RingArea4/y');
Ndef('rob', {|f1=110, f2=111, w1=0.5, w2=0.5| VarSaw.ar([f1, f2], 0, [w1, w2]) * 0.5});
Ndef('rob')[1] = \filter -> {|in, g=0, amp=1|
	in * g.lag3 * amp
};
Ndef('rob').play;
)
Ndef('rob').gui;

Ndef('rob').fadeTime = 0.1;

k = KModules.asEvent;

(
Ndef('balls').clear;
Ndef('balls', {|f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10|

	var sig = DPW4Saw.ar([f1, f2, f3, f4, f5, f6, f7, f8, f9, f10],
			[a1, a2, a3, a4, a5, a6, a7, a8, a9, a10]);

	Splay.ar(
		DFM1.ar(sig, [a1, a2, a3, a4, a5, a6, a7, a8, a9, a10].linexp(0.0,1.0,40, 1200).poll)
		, 1, 0.01)

}).play;

OSCdef(\multiballx, {|msg, time, addr, recvPort|
	msg[1..].do{|m, n|

		Ndef('balls').set('f' ++ (n+1).asSymbol, m.linexp(0.0,1.0,60,320))

	}
}, '/balls/MultiBall/x');

OSCdef(\multibally, {|msg, time, addr, recvPort|
	msg[1..].do{|m, n|

		Ndef('balls').set('a' ++ (n+1).asSymbol, m)

	}
}, '/balls/MultiBall/y');
)


OSCdef(\multibally, {|msg, time, addr, recvPort| msg.do{|m| m.postln} }, '/balls/MultiBall/y');
OSCdef.trace(true, true)
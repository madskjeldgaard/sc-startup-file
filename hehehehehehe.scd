b = BufFiles.new(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_real/metallic objects")
(
	~numchans=25;
	~numchans.do{|i|
		var ndefname = ("warp" ++ (i+1)).asSymbol;

		Ndef(ndefname).source = { 
			|buffer, rate=0.1, freqscale=0.5, grainsize=0.25, overlaps=1, random=0.0, amp=0.15, trigrate=100|
			var pointer = LFSaw.kr(rate).range(0.0,1.0);

			SendReply.kr(Impulse.kr(trigrate), "/%".format(ndefname).asSymbol, pointer);

			(1-pointer).lag * Warp1.ar(1, buffer, pointer, freqscale, grainsize, -1, overlaps, random, 4, amp);
		};

		Ndef(ndefname).play(out: i.postln, numChannels: 1);
	};
)
(
	~numchans.do{|i|
		OSCdef.new("/warp%".format(i+1).asSymbol, {|msg, time, addr, recvPort| 
			var threshold = 0.95;

			if(msg[3] > threshold, {
				var ndefname = ("warp" ++ (i+1)).asSymbol; 
				"Done with warp%!".format(i+1).postln;

				Ndef(ndefname).set(
					\buffer, b.choose,
					\grainsize, rrand(0.01, 0.5),
					\random, 0.1,
					\overlaps, rrand(4, 128),
					\freqscale, rrand(0.125, 0.5), 
					\rate, rrand(0.01, 1.0)
				);

			})
		}, "/warp%".format(i+1).asSymbol);
	};
)
s.meter;
(
	~numchans.do{|i|
		var ndefname = ("warp" ++ (i+1)).asSymbol; 
		Ndef(ndefname).set(
			\buffer, b.choose,
			\freqscale, rrand(0.25, 1.4), 
			\rate, rrand(0.1, 1.0)
		)
	};
)
(
	Tdef(\balint, {
		loop {
			4.wait;

			~numchans.do{|i|
				var ndefname = ("warp" ++ (i+1)).asSymbol; 
				Ndef(ndefname).xset(
					\buffer, b.choose,
					\grainsize, rrand(0.05,0.26),
					\freqscale, rrand(0.125, 2.0), 
					\rate, rrand(3.001, 12.5)
				)
			};

		}
	}	
).play;
)

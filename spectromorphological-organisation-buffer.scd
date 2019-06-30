/*

spectromorphological-organisation-buffer.scd
2019-02-20
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/
/*

Features:
- Routine to loop through buffers each time a new recording is made
- ability to crossfade between surrogacy orders


*/
(
	Buffer.freeAll;

	s.waitForBoot{
		~bufdur = 1;

		~makeBufs = {|orders=10|
			Array.fill(orders, {
				Buffer.alloc(s, ~bufdur * s.sampleRate)
			})
		};

		~createObj = {|orders=10|
			var bufs = ~makeBufs.value(orders);
			(
				bufs: bufs,
				restart: {|objself| objself.rout.reset},
				setSrc: {|objself, srcBuf| objself.bufs[0]=srcBuf},
				recordNext: {|objself, in, numchans=1|
					var recordbuf = objself.rout.value.next;
					recordbuf.notNil.if(
						{ Synth.tail(
							1,
							\bufrecorder ++ numchans,
							[\in, in, \buffer, recordbuf]
						)
					}, {"Reached max amount of orders.".postt} );
				},
				rout: Routine({
					orders.do{|i|
						"Surrogacy order no %".format(i).postt;
						bufs[i].yield;
					}
				})
			)
		};

	};

	o = ~createObj.value;
)

// Src
Ndef(\src, {|f=400| SinOsc.ar(150+( 2*f * LFNoise2.kr.lag )) * 0.15}).play;

o.recordNext.(in: Ndef(\src))

// Morphology player
Ndef(\morphologyplayer,{|buffers, rate=1, loop=1|
	var sig = Array.fill(buffers.size,{
		PlayBuf.ar(1, buffers[i], rate,  trigger: 1.0,  startPos: 0.0,  loop: loop,  doneAction: 0)
	});

	sig;
})


// Morphology mixer
Ndef(\morphologymixer, {|buffers, select=0.0|
	SelectX.ar(select * buffers.size, buffers);
});

// Morphology distributor
Ndef(\morphologydistribute, {|buffers, select=0.0|
	Splay.ar()
});


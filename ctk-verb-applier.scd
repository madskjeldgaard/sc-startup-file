/*

ctk-verb-applier.scd
2019-03-01
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/
(
	f = CtkFx.new;

	~revAdder = {|path|
		var numchans = 1;
		var score  = CtkScore.new;
		var bus = CtkAudio.new( numChans: 1, bus: nil, server: nil );
		var buffer = CtkBuffer.playbuf( path.asAbsolutePath ).addTo( score );

		var direction = [1, ( -1 )].choose;
		var scaleSpeed = {0.75.rrand(0.95)}.value;
		var bufferdur = buffer.duration * scaleSpeed.reciprocal;

		var modfreq = bufferdur.reciprocal/2.61;

		var group = CtkGroup.new( starttime: 0.0, duration: nil, addAction: \addToHead, target: 1 ).addTo( score );

		var fx, mod;
		var mod1 = CtkControl.lfo(LFSaw, 1, 0.0, 1.0, 0, 0);
		var mod2 = CtkControl.lfo(LFNoise2, 100, 0.0, 1.0, 0, 0);
		var mod3 = CtkControl.lfo(LFCub, 1, 0.0, 1.0, 0, 0);
		var mod4 = CtkControl.lfo(LFTri, 1, 0.0, 1.0, 0, 0);
		var gummi = CtkControl.lfo(LFCub, 1, scaleSpeed, scaleSpeed*1.5, 0, 0);

		var mods = Array.fill(5, {
				[mod1, mod2, mod3, mod4].choose;
			});

		var thisnote;


		// Add a buffer player as sound source
		buffer = buffer.normalize;

		thisnote = ~ctkSynths[\bufplayer1]
		.note(0.0, bufferdur, addAction: \head, target: group)
		.dur_( bufferdur )
		.loop_( 1 )
		.atk_( 0.05 )
		.sus_( 0.95 )
		.rel_( 0.05 )
		.curve_( 1 )
		.rate_( gummi )
		.buffer_( buffer )
		.amp_(0.5)
		.out_( 0 );
		score.add( thisnote );

		// Filter
		thisnote = f.hpf(time: 0, dur: bufferdur, group: group, param1: 0.1, out: 0);
		score.add(thisnote);

		// spectral enhance
		thisnote = f.enhance(time: 0, dur: bufferdur, group: group, param1: 0.1, param2: 0.1, param3: 0.15, wet: 0.01, out: 0);
		score.add(thisnote);

		// Then a random reverb / delay fx
		fx = {
			[
				f.greyhole(0, bufferdur, group, 0.0.rrand(1.0), 0.0.rrand(1.0), mod3, 0.5, 0),
				f.gverb(0, bufferdur, group, mod1, mod2, mod3, 0.5, 0),
				f.jpverb(0, bufferdur, group, mod1, mod3, mod2, 0.7, 0)
			].wchoose([0.3,0.2,0.5])
		};

		thisnote = fx.value;
		score.add( thisnote);

		// thisnote = f.lpf(time: 0, dur: bufferdur, group: group, param1: mod1, out: 0);
		// score.add(thisnote);

		// "Limiter"
		thisnote = f.tanh(time:0, dur:bufferdur, group: group, out: 0);
		score.add( thisnote);

		// a dc filter
		thisnote = f.leakdc(time:0, dur:bufferdur, group: group, out: 0);
		score.add( thisnote);

		score;
	};
)
(
	// This function is run on every file being processed
	var procedureFunc = {|old, new, index, action|
		var numchans=1;
		var opts = ServerOptions.new.numOutputBusChannels_(numchans);
		var notes = ~revAdder.value(old);

		notes.write( new, options: opts, sampleRate: s.sampleRate, action: { action.value });
	};

	// TODO: new/old dirs not the same dir? Flop?
	s.waitForBoot{
		CtkProcedure.new(
			iterations: 20,
			firstFilePath: "/Volumes/MK_BLUE/Generative sounds/scaffold4/scaffold4_.wav",
			targetFolder: "/Volumes/MK_BLUE/Generative sounds/scaffold4/",
			procedureFunc: procedureFunc
		).run;
	}
)

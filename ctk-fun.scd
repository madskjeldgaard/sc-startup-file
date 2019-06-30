/*

ctk - fun.scd
2019 - 02 - 22
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/
(
	var score, protonotes, particlefunc, freqs, note, grain, numOuts = 2, outs, numParts = 200, durs, totaldur = 10, now = 0, ampmap, durmap, double;

	thisThread.randSeed_( 666 );

	// Particle synths
	p = Particular.new;
	grain = p.ctkdefs['sin'].expodec;

	score = CtkScore.new;

	freqs = Array.interpolation( numParts, 100, 12000 );
	durs = Array.exprand( numParts, 0.01, 0.1 );
	outs = ( 0 .. ( numOuts - 1 ) );

	// Create a random particle phrase and add it to score
	freqs.do( { arg thisfreq, inc;
		var thisdur, thisnote;

		thisdur = durs[inc];

		thisnote =
		grain.note( now, thisdur )
		.freq_( thisfreq )
		.amp_( inc / ( freqs.size + 1 ) )
		.sustain_( thisdur )
		.out_( outs.choose );

		score.add( thisnote );
		now = now + thisdur;
	} );

	ampmap = { arg aScore, env;
		env.times = env.times * aScore.endtime;
		aScore.notes.do( { arg thisNote;
			var curtime;
			curtime = thisNote.starttime;
			thisNote.amp_( env[curtime] );
		} );
	};

	durmap = { arg aScore, env;
		env.times = 0.001 + ( env.times * aScore.endtime );
		aScore.notes.do( { arg thisNote;
			var curtime = thisNote.starttime;
			thisNote.sustain_( env[curtime] );
		} );
	};

	// returns a new copy of the CtkScore with notes
	// double an octave higher
	double = { arg aScore, shift = 2;
		var thisScore;
		thisScore = aScore.copy;
		thisScore.notes.do( { arg thisNote;
			thisNote.freq_( thisNote.freq * shift )
		} );
		thisScore;
	};


	// ampmap.value( score, Env( [0, 0.25, 0], [0.6, 0.4], [4, - 2] ) );
	// ampmap.value( score, Env.perc( 0.9, 0.1, 1, 1.rrand( 10 ) ) );
	// durmap.value( score, Env.perc( 0.9, 0.1, 1, 10 ) );

	Routine.run( {
		var doublescore;
		score.play;
		score.endtime.wait;

		1.wait;
		durmap.value( score, Env.perc( 0.9, 0.1, 1, 10 ) );
		score.play;
		score.endtime.wait;

		1.wait;
		ampmap.value( score, Env.perc( 0.9, 0.1, 1, 10 ) );
		score.play;
		score.endtime.wait;

		1.wait;
		"double".postt;
		doublescore = double.value( score );
		score.add( doublescore );
		score.play;

	} )
)

(
	// Eksempel: Læs en lyd ind i en buffer, og manipuler den, gem den og gentag
	~speedyBoy = {|inpath, outpath, actionfunc|
		~score  = CtkScore.new;
		~bus    = CtkAudio.new( numChans: 1, bus: nil, server: nil );
		~buffer = CtkBuffer.playbuf( inpath ).addTo( ~score );
		~verb = CtkSynthDef.new( \verb, { |in, out = 0| Out.ar( out, FreeVerb1.ar( In.ar( in ).tanh * 0.15 ) ) } );

		~time = 0;

		~addRise = { |dur = 10, rate=1|
			var thisnote;
			var rateenv = CtkControl.env( Env( [0.1, 1, 0.0001] * rate, [dur, 0.1], \exp )  );

			~group  = CtkGroup.new( starttime: 0.0, duration: nil, addAction: \addToHead, target: 1 ).addTo(~score);

			~score.add(
				~verb.note( ~time, dur*4, addAction: \tail, target: ~group )
				.in_( ~bus )
				.out_(0)
			);

			thisnote = ~ctkSynths[\bufplayer1]
			.note( ~time, dur, addAction: \head, target: ~group )
			.dur_( dur )
			.loop_( 1 )
			.atk_( 0.7 )
			.sus_( 0.15 )
			.rel_( 0.15 )
			.curve_( 1 )
			.rate_( rateenv )
			.buffer_( ~buffer )
			.out_( ~bus );

			~time = ~time + dur;

			~score.add( thisnote );
		};

		~addRise.value(1,5);
		~addRise.value(10,0.25);
		~addRise.value(20,0.125);

		~score.write( outpath, action: actionfunc);
	};


	// Make 5 versions of the original object

	// Version 1
	~path1 = "~/Desktop/speedboy1.aiff".absolutePath;
	~path2 = "~/Desktop/speedboy2.aiff".absolutePath;
	~path3 = "~/Desktop/speedboy3.aiff".absolutePath;

	~fileCheck = {|path|
		PathName(path).isFile.not.if({"% not ready yet".format(path).postt; 1;})
	};

	Routine.run({
		"rm %".format(~path1).unixCmd.postln;
		"rm %".format(~path2).unixCmd.postln;
		"rm %".format(~path3).unixCmd.postln;

		1.wait;

		~speedyBoy.value(
			inpath: Platform.resourceDir +/+ "sounds/a11wlk01.wav",
			outpath: ~path1,
			actionfunc: { "1 done!".postt }
		);

		~fileCheck.value(~path1).wait;
		1.wait;

		~speedyBoy.value(
			inpath: ~path1,
			outpath: ~path2,
			actionfunc: { "2 done!".postt }
		);

		~fileCheck.value(~path2).wait;
		1.wait;

		~speedyBoy.value(
			inpath: ~path2,
			outpath: ~path3,
			actionfunc: { "3 done!".postt }
		);

	});
	// Version 2
	// ~path1 = "~/Desktop/speedboy1.aiff".absolutePath;
	// ~speedyBoy.value(
	//	inpath: Platform.resourceDir +/+ "sounds/a11wlk01.wav",
	//	outpath: ~path1
	// );


)

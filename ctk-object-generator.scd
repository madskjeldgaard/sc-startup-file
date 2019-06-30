/*

ctk - object - generator.scd
2019 - 02 - 24
By: Mads Kjeldgaard, mail@madskjeldgaard.dk


This is a factory that produces sound objects in many different varieties


*/
s.reboot;
(
	f = CtkFx.new;

	~noteMachine1 = { |bufpath = "/Users/madskjeldgaard/Dropbox/scripts/sc/magi/magi1/Lyde\ fra\ Rasmus/1/MAGI1.wav", speed = 1, maxLength=300|
		var numchans = 1;
		var score  = CtkScore.new;
		var bus    = CtkAudio.new( numChans: 1, bus: nil, server: nil );
		var buffer = CtkBuffer.playbuf( bufpath ).load(sync: true).addTo( score );
		var inFileName = PathName( bufpath ).fileName;

		var time = 0;

		var bufferDur, bufPlay, fxPlay, groupFunc, makeNote;

        PathName(bufpath).isFile.postln;

		buffer = buffer.normalize;
		bufferDur = buffer.duration;
		speed = speed.value;

		( bufferDur > maxLength ).if({
			speed = speed * 10;
		});


		speed.isNegative.if(
			{bufferDur = speed.neg.reciprocal * bufferDur},
			{bufferDur = speed.reciprocal * bufferDur}
		);


		bufPlay = { |time, dur, group|
			var ctrls = [
				speed,
				CtkControl.env(Env.perc(0.9,0.1,1,10.0), starttime: 0.0, target: group, levelScale: speed, levelBias: 1, timeScale: dur, doneAction: 0),
				CtkControl.lfo(LFNoise2, freq: speed, low: 0.1, high: 1.0, phase: 0, starttime: 0.0, duration: dur, target: 1),
				CtkControl.lfo(LFPar, freq: speed, low: 0.1, high: 1.0, phase: 0, starttime: 0.0, duration: dur, target: 1),
				CtkControl.lfo(LFSaw, freq: speed, low: 0.1, high: 1.0, phase: 0, starttime: 0.0, duration: dur, target: 1),
				CtkControl.lfo(LFCub, freq: speed, low: 0.1, high: 1.0, phase: 0, starttime: 0.0, duration: dur, target: 1)
			];
			var thisnote = ~ctkSynths[\bufplayer1]
			.note( time, dur, addAction: \head, target: group )
			.dur_( dur )
			.loop_( 1 )
			.atk_( 0.05 )
			.sus_( 0.95 )
			.rel_( 0.05 )
			.curve_( 1 )
			.rate_( ctrls.choose)
			.buffer_( buffer )
			.amp_(0.5)
			.out_( 0 );

			score.add( thisnote );
		};

		fxPlay = { |time, dur, group|
			var lfo = CtkControl.lfo(LFNoise2, 10, 0.0, 1.0, 0, 0, dur, \addToHead);
			var thisnote, fxnote, verbnote;

			var p = {|paramVal=0.5|
				CtkControl.env(
					Env([paramVal*0.9, paramVal, paramVal*0.85], [dur/2, dur/2], 10),
					starttime: 0.0,
					target: 1,
					timeScale: dur,
					levelScale: 1
				)
			};

//			fxnote = { |param1=0.5, param2=0.5, param3=0.5, wet=0.75|
//				[
//					f.diffuse(0, dur, group, param1, param2, param3, wet, 0),
//					f.comb(0, dur, group, param1, param2, param3, wet, 0),
//					f.spectraldelay(0, dur, group, param1, param2, param3, wet, 0),
//					f.pitchshift(0, dur, group, param1, param2, param3, wet, 0)
//					// f.warpin(0, dur, group, param1, param2, param3, wet, 0)
//				].wchoose([0.3,0.1,0.5,0.2].normalizeSum)
//			};

//			 thisnote = fxnote.value(*{ p.value(0.0.rrand(1.0)) }.value!3);
//			 score.add( thisnote );

			verbnote = {|param1=0.5, param2=0.5, param3=0.5, wet=0.95|
				[
					f.greyhole(0, dur, group, param1, param2, param3, wet, 0),
					f.jpverb(0, dur, group, param1, param2, param3, wet, 0)
			].choose
		};

			thisnote = verbnote.value(*{ p.value(0.5.rrand(1.0)) }.value!3);
			score.add(thisnote);

			thisnote = f.leakdc(time:0, dur:dur, group: group, out: 0);
			score.add( thisnote);

		};

		makeNote = { |time, dur|
			var group = CtkGroup.new( time, dur, \addToHead, target: 1).addTo( score );
			bufPlay.value( time, dur, group );
			fxPlay.value( time, dur, group );

			time = time + dur;
		};

		makeNote.value( 0.0, bufferDur );

		"Manipulated % of dur % seconds".format( inFileName, bufferDur ).postt;

		score;

	};
)

// Mutations
(
	// This function is run on every file being processed
	var procedureFunc = {|old, new, index, action|
		var numchans=1;
		var opts = ServerOptions.new.numOutputBusChannels_(numchans);
		var notes = ~noteMachine1.value(old, speed: {[1,(-1)].choose * ( 0.01.rrand(1.1))});

		notes.write(
			new,
			options: opts,
			sampleRate: s.sampleRate,
			action: { action.value }
		);
	};


	// TODO: new/old dirs not the same dir? Flop?
	s.waitForBoot{
		CtkProcedure.new(
			iterations: 10,
			// firstFilePath: Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff",
			firstFilePath: "/Users/madskjeldgaard/Dropbox/scripts/sc/magi/magi1/Lyde\ fra\ Rasmus/1/MAGI1.wav",
			targetFolder: "/Users/madskjeldgaard/Dropbox/scripts/sc/magi/magi1/Lyde\ fra\ Rasmus/1",
			procedureFunc: procedureFunc
		).run;
	}
)

// Play back / cross fade between mutations

s.plotTree

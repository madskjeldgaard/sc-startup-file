/*

phonogene-main.scd
2019-02-06
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/
(
s.waitForBoot{

	// Sound modules
	k = KModules.new;

	// Korg NanoKontrol2
	n = MKtl('nano', "korg-nanokontrol2");

	// Settings

	// Base name of ndefs
	~nd = \concrete;

	// Cleanup
	Buffer.freeAll;
	Pdef.all.clear;
	Ndef.all.clear;
	Ndef.all.do{|a| a.pop};

	// Load buffers
	b = ();
	b.flocks = BufFiles(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_processed/flocks");

	// Load files
	~thisDir = "/Users/madskjeldgaard/Dropbox/scripts/sc/_tools/phonogene";
	(~thisDir ++ "phonogene-controller.scd").load;


};
)
/************************************

			CONTROLLER

*************************************/
(
~actions = (
	play: {|el| "play".postt; Ndef(~nd).play},
	stop: {|el| "stop".postt; Ndef(~nd).stop},
	changeRate: {|el|
		var rate = el.value;
		"rate: %".format(rate).postt;
		Ndef(~nd).set(\rate, rate);
	},
	changeAmp: {|el|
	},
	toggleLoop: {|el|
	},
	changePitchshift: {|el| Ndef(~nd).set(\pitch, el.value, \pd, el.value/10, \grain, el.value.reciprocal)},
	changeCarF: {|el| Ndef(~nd).set(\carfreq, el.value)},
	changeDelay: {|el| Ndef(~nd).set(\delay, el.value)},
	changeRoom: {|el| Ndef(~nd).set(\size, el.value*5.0)},
	changeFS: {|el| Ndef(~nd).set(\freq, el.value)},
	changeConform: {|el| Ndef(~nd).set(\areal, el.value, \aimag, el.value.reciprocal)},
	changeEnhance: {|el| Ndef(~nd).set(\numPartials, el.value, \ratio, el.value.reciprocal, \strength, el.value)},


	changeWet1: {|el| Ndef(~nd).set(\wet1, el.value)},
	changeWet2: {|el| Ndef(~nd).set(\wet2, el.value)},
	changeWet3: {|el| Ndef(~nd).set(\wet3, el.value)},
	changeWet4: {|el| Ndef(~nd).set(\wet4, el.value)},
	changeWet5: {|el| Ndef(~nd).set(\wet5, el.value)},
	changeWet6: {|el| Ndef(~nd).set(\wet6, el.value)},
	changeWet7: {|el| Ndef(~nd).set(\wet7, el.value)},
	changeWet8: {|el| Ndef(~nd).set(\wet8, el.value)},);

~patches = (
	patch1: (
		modules: [
			k['fx']['spectral']['conformer'],
			k['fx']['time']['reverb1'],
			k['fx']['time']['delay'],
			k['fx']['spectral']['enhance'],
			k['fx']['destruction']['waveloss'],
			k['fx']['pitch']['pitchshift'],
			k['fx']['time']['freqshift']
			],

			ctrlmap1: (
				\tr_play: \play,
				\tr_stop: \stop,
				\sl_1: \changeRate,
				\sl_2: \changePitchshift,
				\sl_3: \changeDelay,
				\sl_4: \changeRoom,
				\sl_5: \changeEnhance,
				\sl_6: \changeConform,
				\sl_7: \changeFS,
				\sl_8: \changeRate,

				\kn_1: \changeWet1,
				\kn_2: \changeWet2,
				\kn_3: \changeWet3,
				\kn_4: \changeWet4,
				\kn_5: \changeWet5,
				\kn_6: \changeWet6,
				\kn_7: \changeWet7,
				\kn_8: \changeWet8,
			)
		)
	);

~patches[\patch1][\ctrlmap1].keysValuesDo{|elemName, actionName|
		n.dictAt(elemName).action = ~actions[actionName]
};

~patches[\patch1][\modules].do{|module, index|
	Ndef(~nd)[index+1] = \filter -> module;
};

)

/************************************

				PATCH

*************************************/
Ndef(~nd).mold(2, 'audio');

// Source
Ndef(~nd).source = k['src']['bufplayer2'];

Ndef(~nd).set(\buffer, b.flocks[0], \rate, 1.0, \loop, 1);
Ndef(~nd).play;

KModules.postModuleList

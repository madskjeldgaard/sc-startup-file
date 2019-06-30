/*

phonogene-controller.scd
2019-02-06
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/
(
// Korg NanoKontrol2
n = MKtl('nano', "korg-nanokontrol2");

~actions = (
playComp: {
	"Playing composition".postt;
	Pdef(\rips_composition).play;
},
stopComp: {
	"Stopping composition".postt;
	Pdef(\rips_composition).stop;
},
changeThresh: {|el|
	"silence threshold: %".format(el.value).postt;
	Ndef(\rips_a1_silence).set(\silenceThresh, el.value);
},
changeRate: {|el|
	var rate = el.value * 100;

	~setAllNdefsWithPrefix.value("rips_a1", \updaterate, rate);

	"Analysis osc updaterate : %hz".format(rate).postt;
},
);

~mappings = (
ctlMap1:
	(
		\tr_play: \playComp,
		\tr_stop: \stopComp,
		\sl_1: \changeThresh,
		\kn_1: \changeRate,
	),);


~mappings[\ctlMap1].keysValuesDo{|elemName, actionName|
n.dictAt(elemName).action = ~actions[actionName]
};

)

(
{ arg dur=8, modBool=1, modfreq=9.1;

var sig = PinkNoise.ar(0.3)!2;
var env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [dur, dur, dur], \lin), gate: 1, doneAction:2);

var modmod = Select.kr(modBool > 0, [0, Line.kr(1, 0.0001, dur*3) ]);

var mod = SinOsc.kr(modfreq * modmod, mul:env);

var movements = [
    [0,1,-1,0], // Center to right to left to center
    [0,-1,1,0], // Center to left to right to center
    [0,1,0,-1], // Center to right to center to left
    [0,0.5,0,1], // Center to halfway right to center all the way right 
    [0,-0.5,0,-1] // Center to halfway left to center all the way left 
    ];

var panenv = EnvGen.kr(Env(movements.choose, [dur-0.1, dur-0.1, dur-0.01], \sin), gate: 1, doneAction:0);

var pan = Balance2.ar(sig[0], sig[1], pos: mod*panenv);

panenv.poll(label:[\env1, \env2]);

Out.ar(0, pan * env);
}.play;
)



(
var aList = [0,1,-1,0]; 
var numberOfChoices = 4;
var doHowManyTimes = numberOfChoices.factorial ;
doHowManyTimes.asInt.do({|i| aList.permute(i).postln});
)

(
var aList = [0,-1,1,0];

var doDerangement = { |array , n|
	Routine {
		n = n ?? { array.size.factorial };
		n.do { |i|
			var permuted = array.permute(i);
			if(array.every { |each, i| permuted[i] != each }) {
				permuted.yield
			};
		}
	};
};

//doDerangement.((0..3)).all.do({|order| aList[order].postln});
doDerangement.(aList).all.do(_.postln);

//x = f.(4);
//x.all.do(_.postln); "";
)

[0,3,1,4].order

(



(
z = { |n|
	case
	{ n <= 0 } { 1 }
	{ n == 1 } { 0 }
	{ (n - 1) * (z.(n - 1) + z.(n - 2)) }
};
p = { |i| i.asPaddedString(10, " ") };
"n    derangements    subfactorial".postln;
(0..9).do { |i|
	var derangements = f.(i).all;
	var subfactorial = z.(i);
	"%    %    %\n".postf(i, p.(derangements.size), p.(subfactorial));
};
)
)

[1,2,3,4].powerset

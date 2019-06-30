(
Pdef(\hej, Pbind(\freq, Pwhite(100, 10000), \dur, Pseq([1,5,2,1],inf)));

Pdeff(\hej2, \hej, \dur, Pseq([0.01, 0.25, 10], inf)).play.trace;
)


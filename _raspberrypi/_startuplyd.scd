(
Pbind(
	\dur, 0.25 * Pseq([0.25, Rest(1.125), 0.125,  Rest(0.5), 4]),
	\octave, 5,
	\scale, Scale.major,
	\stretch, 1.25,
	\degree, Pseq([0, Rest(), 0, Rest(), [0,2,4,7]])
).play;
)
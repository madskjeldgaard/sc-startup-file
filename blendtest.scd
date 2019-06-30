/*

blendtest.scd
2019-05-19
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/

Pdef(\going_up, Pbind(\dur, 0.25, \degree, Pseq((0..5),inf).blend(Pseq([1,3],inf))).trace(\degree)).play;


(
Pbind(
    \scale, Scale.minor,
    \degree,  Pseg( Pseq([1, 5], inf), Pseq([0, 8],inf), Pseq([\linear, \exp],inf)).round,
    \dur, 0.2
).trace(\degree).play;
)

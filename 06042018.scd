(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
//Record
//s.record;
)

~sin = {SinOsc.kr(9.901)};

(
var osc = NetAddr("127.0.0.1", 8020);

~p1[0] = Pbind(
    //\instrument, \rawsaw, 
    \amp, 0.8,
    \chord, Pstutter(Pseq([1,3,1,1,7,1,1,5,2,3],inf), Pseq([
           0,3,4,3,6,5, 
           0,5,7,3,7,4
        ], inf)) + [Pstutter(13, Pseq([0,0,14,-2,8],inf)),2,4,6],
    \degree, Pkey(\chord), 
    //\scale, Pstutter(49, Pseq([Scale.major, Scale.minor],inf)),
    \root, -4,
    \scale, Pstutter(138, Pseq([Scale.minor, Scale.major],inf)),
    \octave,4,
    \dur, Pkrlive(~sin) + Pseq([0.25, 0.5, 0.75],inf),
    \cutoff, 1000,
    \res, 0.8,
    \stretch, 0.25, //Pkrlive(~sin, 0.25, 1) * Pseq([0.25, 0.5, 0.25, 0.25, 0.75],inf), //+Pwrand([0.5, 0.25, 0.125], [0.1, 0.2, 0.7], repeats: inf), //+Pstutter(7, Pseq([0.25, 0.5, 1.0, 2.0],inf)),
    \atk, 0.1 * Pkey(\dur) * Pkey(\stretch), 
    \rel, Pkey(\dur) * Pkey(\stretch), 
    \dest, osc,
	\msg, "/fromTidal/1",
    \play, { ~dest.sendBundle(~latency, [~msg, \cps, 1, \dur, ~dur, \delta,
        ~delta, \velocity, 1, \midinote, ~midinote]) }
).trace(\midinote);

~p1.play(fadeTime:1);
)


(
var osc = NetAddr("127.0.0.1", 8020);
~p1 = Pbind(
	\dest, osc,
	\msg, "/fromTidal/1",
	\midinote, Pseq([50, 70, 55],inf),
	\cps, 1,
	\dur, Pseq([1,0.5, 0.25],inf),
	\play, { ~dest.sendBundle(~latency, [~msg, \cps, 1, \dur, ~dur, \delta, ~delta, \velocity, 1, \midinote, ~midinote]) }
).trace.play;
)

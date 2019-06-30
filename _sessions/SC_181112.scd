s.reboot;

MIDIClient.init;

m = MIDIOut.newByName("Fireface UC Mac (23741446)", "Port 1").latency_(Server.default.latency)


(type: 'midi', midicmd: 'noteOff', degree: (0..10), midiout: m).play;

p = ProxySpace.push(s)

p.quant = 2;

~s = {|f=1| SinOsc.ar(f).range(0.25, 2.0)}
(

~p1 = Pbind(\type, \midi, 
    \midicmd, \noteOn, 
    \midiout, m, 
    \scale, Scale.major,
    \octave, Pstutter(36, Pseq([6,7,5],inf)),
    \degree, Pstutter(16, Pseq([1,4,5],inf)) + Pseq([0,2,5,6,7,1,2,1,0,3,4].pyramid(7),inf), 
    /* \stretch, Pstutter(128, Pseq((1.0,1.25..5.0),inf)), */
    \legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
    \dur, 1
    /* \dur, Pseq([Pstutter(12, 0.075), 1.00,0.5,0.5],inf) */
);

~p2 = Pbind(\type, \midi, 
    \midicmd, \noteOn, 
    \midiout, m, 
    \scale, Scale.major,
    \octave, Pstutter(36, Pseq([6,7,5],inf)),
    \degree, Pseq([0,1,2],inf), 
    \legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
    \stretch, 2,
    \dur, 0.125/5
);

~p3 = Pbind(\type, \midi, 
    \midicmd, \noteOn, 
    \midiout, m, 
    \scale, Scale.major,
    \octave, 2 + Pstutter(36, Pseq([6,7,5],inf)),
    \degree, Pseq([0,1,2],inf), 
    \legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
    \stretch, 2,
    \dur, 0.125/2
);
~p3.stop;
)

~p1 = Pbind(
    \type, \midi, 
    \midicmd, \noteOn, 
    \midiout, m, 
    \scale, Scale.major,
    \octave, Pstutter(36, Pseq([6,7,5],inf)),
    \degree, Pseq([0,7,6],inf), 
    /* \stretch, Pstutter(128, Pseq((1.0,1.25..5.0),inf)), */
    \stretch, 1,
    \legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
    \dur, Pbjorklund2(13,5, inf) / 8,
    /* \dur, Pseq([Pstutter(12, 0.075), 1.00,0.5,0.5],inf) */
);

~p2 = Pbind(
    \type, \midi, 
    \midicmd, \noteOn, 
    \midiout, m, 
    \scale, Scale.major,
    \octave, 2-Pstutter(36, Pseq([6,7,5],inf)),
    \degree, Pseq([0,1,2,7,6],inf), 
    \dur, Pbjorklund2(13,9, inf) / 8
    /* \dur, Pseq([Pstutter(12, 0.075), 1.00,0.5,0.5],inf) */
);


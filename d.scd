"_synthdefs/drums-etc.scd".load

p = ProxySpace.push(s);

p.clock = TempoClock.new(1, 0, 0);

p.makeTempoClock;
p.clock.tempo=120/60;

( 
    ~a = Pbind(\instrument, \default, \scale, Scale.minor, \octave, 5, \dur, Prand([2, 0.5, 0.125, 0.25, Rest(1), Rest(0.5)], inf)/3, \degree, Pwhite(0, 10));
   
    ~b = Pbind(\instrument, \SOStom,
            \freq, 305,
            \dur, Prand([1, 0.5, 0.125, 0.25, Rest(1), Rest(0.5)], inf) * Pseq([1,3,2],inf)
        );
   
    ~c = Pbind(\instrument, \SOSsnare,
            \freq, 120,
            \dur, 1
        );

    ~d = Pbind(\instrument, \SOShats, \freq, 888, \dur, Pseq([Rest(0.5), 0.5],inf), \freq, 300, \drum_mode_level, 0.17);
)

~a.play;~b.play;~c.play;~d.play;

/*

    a VINK patch

*/

s.record;

s.reboot

p.pop;

p = p ?? ProxySpace.push;

p.fadeTime = 4;

s.meter;

~v1.play
~v1.set(\f, 220)

~v4.play
~v4.set(\f, 110)

s.plotTree

~v1.mold(1, 'audio');
~v2.mold(1, 'audio');
~v3.mold(1, 'audio');
~v4.mold(1, 'audio');

(
/*
    
    Sound sources

*/

~v1 = { |f=110, mix=1, room  = 0.752, in| 
    FreeVerb.ar(
        LFTri.ar(
            f,
            0,
            (1-in.lag) * CombC.ar(in)
        ),
        mix: mix,
        room: room
    )

};

~v2 = { |f=110,mix=1, room=0.9521, in| 
    FreeVerb.ar(
        LFTri.ar(
            f,
            0,
            (1-in.lag) * CombC.ar(in)
        ),
        mix: mix,
        room: room

)};

~v3 = { |f=110,mix=1, room=1.0, in| 
    FreeVerb.ar(
        LFTri.ar(
            f,
            0,
            (1-in.lag) * CombC.ar(in)
        ),
        mix: mix,
        room: room

)};

~v4 = { |f=110, mix=1, room=0.75, in| 
    FreeVerb.ar(
        LFTri.ar(
            f,
            0,
            1
        ),
        mix: mix,
        room: room

    )
};
)

(

/*
    
    Patching 

*/

~v1.xmap(\in, ~v4);
~v2.xmap(\in, ~v1);
~v3.xmap(\in, ~v2);
~v4.xmap(\in, ~v3);

~v1.xset(\f, 133, \room, 0.5);
~v2.xset(\f, 123, \room, 0.5);
~v3.xset(\f, 233, \room, 0.75);
~v4.xset(\f, 223, \room, 0.95);

~v1.xmap(\in, ~v4);
~v2.xmap(\in, ~v1);
~v3.xmap(\in, ~v2);
~v4.xmap(\in, ~v3);


)

(
/*
    
    LFOS 

*/

~l1 = {|f=0.01, base=110| 
    SinOsc.kr(f, 0, 1.6712, base);
    };

~l2 = {|f=0.02, base=211.15| 
    SinOsc.kr(f, 0, 2, base);
    };

~l3 = {|f=0.03, base=295| 
    SinOsc.kr(f, 0, 3, base);
    };

~l4 = {|f=0.04, base=192.382| 
    SinOsc.kr(f, 0, 5, base);
    };

~l5 = {|f=0.015|
    SinOsc.kr(f, 0, 0.5, 0.5);
    };


~v1.xmap(\f, ~l1);
~v2.xmap(\f, ~l2);
~v3.xmap(\f, ~l3);
~v4.xmap(\f, ~l4);

)


(
/*

 Outputs

*/

~output = {|cutoff = 1000|
    DFM1.ar(
        Splay.ar(
        [
        ~v1, 
        ~v2, 
        ~v3,
        ~v4 * 0.10
    ], ~l5 * 0.5),
    freq: 40+cutoff
)
};

~output.mold(2, 'audio');

~output.play;

)

(
/*

 GUIS

*/

// Sources
~v1.gui;~v2.gui;~v3.gui;~v4.gui;

// Lfos
~l1.gui;~l2.gui;~l3.gui;~l4.gui;~l5.gui;

~output.gui;
)



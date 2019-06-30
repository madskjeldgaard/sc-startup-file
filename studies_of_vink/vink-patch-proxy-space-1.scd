/*

    a VINK patch

    Inspired by Ernst van der Loo

*/

s.record;

s.reboot

p = p ?? ProxySpace.push;

p.fadeTime = 4;

s.meter;

(
/*
    
    Sound sources

*/
~v1.mold(1, 'audio');
~v2.mold(1, 'audio');
~v3.mold(1, 'audio');
~v4.mold(1, 'audio');

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

~v2 = { |f=110,mix=1, room=0.9521, decay=0.1, lag=0.01, in| 
    FreeVerb.ar(
        LFTri.ar(
            f,
            0,
            (1-in.lag) * CombC.ar(in, decaytime: decay * 5)
        ),
        mix: mix,
        room: room

)};

~v3 = { |f=110,mix=1, room=1.0, decay=0.25, in| 
    FreeVerb.ar(
        LFTri.ar(
            f,
            0,
            (1-in.lag) * CombC.ar(in, decaytime: decay * 5)
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

)

(
/*
    
    LFOS 

*/

~mainFreq = 110;

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

~l5 = {|f=0.115| SinOsc.kr(f, 0, 0.5, 0.5); };

~l4.xmap(\base, ~mainFreq);

~v1.xmap(\f, ~l1);
~v2.xmap(\f, ~l2);
~v3.xmap(\f, ~l3);
~v4.xmap(\f, ~l4);

)


(
/*

 Outputs

*/

~output = {|cutoff = 1000, spread=0.5|
    DFM1.ar(
        Splay.ar(
        [
        ~v1, 
        ~v2, 
        ~v3,
        ~v4 * 0.10
    ], spread),
    freq: 40+cutoff
)
};

~output.mold(2, 'audio');

~output.play;

)
(
/*

    MOUSE 

*/

~x = {MouseX.kr};
~y = {MouseY.kr};

~fy = {~y * 1000};
~fx = {~x * 1000};

~v1.xmap(\freq, ~y);
~v3.xmap(\decay, ~x);
~v4.xmap(\room, ~x);

)
~x.scope;
(

/*

    Patterns

*/

a = [60.05, 62.05, 63.25];

~mainfreq = {100};

~v1[1] = \xset -> Pbind(\dur, Pxrand([4,8,16,32],inf), \f, Pwhite(1.0, 1.75, inf) * Pseq(a, inf), \room, Pseq([0.5, 0.75, 1.0], inf));
~v2[1] = \xset -> Pbind(\dur, 32, \f,Pwhite(1.0, 1.35, inf) * Pseq(a.pyramid(4)*0.651274,inf), \room, Pseq([0.95, 0.75, 1.0], inf));
~v3[1] = \xset -> Pbind(\dur, 48, \f, Pseq(a.pyramid(3)*2.22358,inf), \room, Pseq([0.95, 0.75, 1.0], inf));
~v4[1] = \xset -> Pbind(\dur, 64, \f, Pseq(a.pyramid(2)*1.22358,inf), \room, Pseq([0.95, 0.75, 1.0], inf));

~output[1] = \xset -> Pbind(
    \cutoff, 10000,
    \spread, Pwhite(0.1,0.4,inf), 
    \dur, 8
    ); 
)


Server.local.options.blockSize = 1;

Server.local.options.blockSize = 1;
s.options.blockSize_(1)
s.reboot

postln(s.options.blockSize)

/************************************

    SETUP

*************************************/
( 
	j = MKtl('p1', "arrogant_bastard");

	p = Particular.new;

	MKtl('p1').trace(true);
)
/************************************

    PROCESS

*************************************/
( 
    ~instr='buf1';

    ~buffer = Buffer.read(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_real/CLUSTERS/Eggs boiling on induction stove rattling nt55 mono cardio.wav").normalize;

    // Pattern
    Pdef(\g,
        Pfx(
            Pbind(
            \instrument, Pdefn(\instr, p.def('rexpodec', ~instr)),
            \buffer, ~buffer,
            \start, Pdefn(\gstart, 0.1),
            \dur, Pdefn(\gdur, 0.1), 
            \freq, Pdefn(\gfreq, 444),
            \rate, Pdefn(\grate, 1),
            \amp, Pdefn(\gamp, 1)
        ),
        \panner, \pan, Ndef(\pan, {|pan=0.5| pan})
        )
    );

    // Actions
    ~grainpat = (
        actions: (
			startProcess: {|el| 
				if(el.value > 0.0, {Pdef(\g).reset.play}, {Pdef(\g).stop}) 
			},
			randEnv: { |el| 
				if(el.value > 0.0, {Pdefn(\instr, p.defs[~instr].choose.postln) 
			})},
			genv: {|el| 
				var index = el.value.linlin(0.0,1.0,0, p.defs[~instr].size-1).round; 
				Pdefn(\instr, p.defs[~instr][index].postln
			)},
			grandenv: {|el| 
				if(el.value > 0.0, { Pdefn(\instr, p.defs[~instr].choose )}) 
			},
			gdur: {|el| 
				Pdefn(\gdur, el.value.linexp(0.0,1.0,0.02,1.0)) 
			},
			ggaussdur: {|el| 
				Pdefn(\gdur, el.value.linexp(0.0,1.0,0.02,1.0).gauss(el.value/10).max(0.001)) 
			},
			grandur: {|el|
				// Pdefn(\gdur, Pwhite(1.0, 2.0))
},
			gfreq: {|el| 
				Pdefn(\gfreq, el.value.linexp(0.0,1.0, 12000, 40) ) 
			},
			grate: {|el| 
				Pdefn(\grate, el.value.linexp(0.0,1.0,0.001, 5.0
				))
			},
			gamp: {|el| 
				Pdefn(\gamp, el.value)
			},
			gpan: {|el| 
				Ndef(\pan).set(\pan, el.value)
			},
			gscan: {|el| 
				Pdefn(\gstart, el.value)
			},
			granstart: {|el| 
				Pdefn(\gstart, rrand(0.0,1.0))
			},
        )
    );

/************************************

    MAPPING

*************************************/
~grainpat.put(
    \gamepad, (
        \map1: (
            'bt_r1': 'startProcess',
            'bt_r2': 'grandenv',
			'bt_l1': 'granstart',
			// 'bt_a': 'wobble',
			'joy_l_x': 'ggaussdur',
            'joy_l_y': 'gfreq',
            'joy_l_y': 'grate',
            'joy_r_x': 'gpan',
			'joy_l_y': 'gamp',
            'compass': 'genv'
        )
    )
);

~grainpat.gamepad.map1.keysValuesDo{ |elName, actName|
    MKtl(\p1).elAt(elName).postln.action = ~grainpat.actions[actName.postln].postln;
};

)

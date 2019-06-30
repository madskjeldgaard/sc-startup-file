/************************************

    SETUP

*************************************/
( 
	j = MKtl('p1', "arrogant_bastard");

	// MKtl('p1').trace(true);

    // Target
    // n = NetAddr.new("127.0.0.1",  port: 7777);
)
/************************************

    PROCESS

*************************************/
( 
    ~latency=0.12;

    // Actions
    ~joy = (
        actions: (
			sendJoyX1: {|el| 
                n.sendBundle(~latency, [ '/bastard/joyx1', el.value ])
			},
            sendJoyX2: {|el| 
                n.sendBundle(~latency, [ '/bastard/joyx2', el.value ])
			},
            sendJoyY1: {|el| 
                n.sendBundle(~latency, [ '/bastard/joyy1', el.value ])
			},
            sendJoyY2: {|el| 
                n.sendBundle(~latency, [ '/bastard/joyy2', el.value ])
			},
            sendComp: {|el| 
                n.sendBundle(~latency, [ '/bastard/comp', el.value ])
			},

        )
    );

/************************************

    MAPPING

*************************************/
~joy.put(
    \gamepad, (
        \map1: (
            // 'bt_r1': 'startProcess',
            // 'bt_r2': 'grandenv',
			// 'bt_l1': 'granstart',
			'joy_l_x': 'sendJoyX1',
            'joy_l_y': 'sendJoyY1',
            'joy_r_x': 'sendJoyX2',
			'joy_r_y': 'sendJoyY2',
            'compass': 'sendComp'
        )
    )
);

~joy.gamepad.map1.keysValuesDo{ |elName, actName|
    MKtl(\p1).elAt(elName).postln.action = ~joy.actions[actName.postln].postln;
};

)

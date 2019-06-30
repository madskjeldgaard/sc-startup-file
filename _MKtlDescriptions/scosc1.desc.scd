( 
(
    idInfo: "osc app",
    name: \scosc1,
    netAddrInfo: ( 
        recvPorT: nil,
        srcPort: NetAddr.langPort,             
        ipAddress: NetAddr.localAddr.ip
    ), 
    deviceType: \phoneApp,
    protocol: \osc, 
    collectives: (

        // Gyroscope
        accel: (
            oscPath: '/accxyz',
            elements: [ [\accel, \x], [\accel, \y], [\accel, \z]],
            ioType: \in
        ),

        // Page 1
        xy1: (
            oscPath: '/1/xy1',
            elements: [[\1, \sl, \1, \x], [\1, \sl, \1, \y] ],                            
            ioType: \in
        ),
        xy2: (
            oscPath: '/1/xy2',
            elements: [[\1, \sl, \2, \x], [\1, \sl, \2, \y] ],                            
            ioType: \in
        ),
        xy3: (
            oscPath: '/1/xy3',
            elements: [[\1, \sl, \3, \x], [\1, \sl, \3, \y] ],                            
            ioType: \in
        ),
        xy4: (
            oscPath: '/1/xy4',
            elements: [[\1, \sl, \4, \x], [\1, \sl, \4, \y] ],                            
            ioType: \in
        ),

        // Page 3
        mxy1: (
            oscPath: '/3/multixy1/1',
            elements: [[\3, \sl, \2, \x], [\3, \sl, \2, \y] ],                            
            ioType: \in
        ),
        mxy2: (
            oscPath: '/3/multixy1/2',
            elements: [[\3, \sl, \3, \x], [\3, \sl, \3, \y] ],                            
            ioType: \in
        ),

        mxy3: (
            oscPath: '/3/multixy1/3',
            elements: [[\3, \sl, \4, \x], [\3, \sl, \4, \y] ],                            
            ioType: \in
        ),

        mxy4: (
            oscPath: '/3/multixy1/4',
            elements: [[\3, \sl, \4, \x], [\3, \sl, \4, \y] ],                            
            ioType: \in
        ),

        mxy5: (
            oscPath: '/3/multixy1/5',
            elements: [[\3, \sl, \5, \x], [\3, \sl, \5, \y] ],                            
            ioType: \in
        ),

        mxy6: (
            oscPath: '/3/multixy1/6',
            elements: [[\3, \sl, \6, \x], [\3, \sl, \6, \y] ],                            
            ioType: \in
        ),

    ),
    elementsDesc: (
        elements: [

            // Gyroscope
            (
                key: \accel,
                shared: (elementType: 'accelAxis', ioType: \collectiveIn, \spec: 'accx' ),
                elements: [
                    (key: \x),
                    (key: \y),
                    (key: \z)
                ]
            ),

            // Page1
            (key: '1',
                elements: [
                    // Buttons
                    (key: 'bt',
                        shared: (
                            elementType: 'button', 
                            ioType: \in, 
                            spec: \but,
                        ),
                        elements: [
                            (oscPath: '/1/rec'),
                            (oscPath: '/1/play'),
                            (oscPath: '/1/stop'),
                            (oscPath: '/1/prev'),
                            (oscPath: '/1/next')
                        ]
                    ),

                    // Sliders
                    (key: 'sl', 
                        shared: (
                            elementType: 'slider', 
                            ioType: \collectiveIn, 
                            spec: \unipolar,
                        ),
                        elements:
                            // XY sliders on page 1
                            (1..4).collect{|i|
                                 (key: i.asSymbol, elements: [ (key: \x), (key: \y) ] )
                            } ++ 

                            // Top/bottom sliders
                            [\topslider, \bottomslider].collect{|i, n| (ioType: \in, oscPath: '/1/' ++ i, key: i)}
                    )
                ] 
            ),
            
            // Page 2
            (key: '2',
                elements: [

                    // Multisliders
                    (key: 'sl',
                        shared:(
                            type: 'slider', 
                            ioType: \in, 
                            spec: \unipolar,
                        ),
                    elements: 
                        (1..8).collect{|i|
                            (ioType: \in, oscPath: '/2/multifader1/' ++ i.asSymbol, key: i.asSymbol)
                        }
                    ),

                    // Multipush
                    (key: 'bt',
                        shared: (
                        type: 'button', 
                        ioType: \in, 
                        spec: \but
                    ),
                    elements: 
                        (1..8).collect{|x|
                            (1..8).collect{|y|
                                "/2/multipush1/%/%".format(x,y).postln;
                                (oscPath: "/2/multipush1/%/%".format(x,y).asSymbol)
                            }
                        }.reshape(64)
                    )
                ] 
            ),

            // Page 3
            (key: '3',
                elements:[
                    
                    // Multi xy fader
                    (key: 'sl', 
                        shared: (
                            elementType: 'slider', 
                            ioType: \in, 
                            spec: \unipolar,
                        ),
                        elements: 
                            (1..6).collect{|i|
                                     (key: i.asSymbol, elements: [ (key: \x), (key: \y) ] )
                                }
                        ),

                    // Rotaries
                    (key: 'kn',
                        shared: (
                            elementType: 'knob',
                            ioType: \in
                        ),
                        elements: 
                            (1..6).collect{|i| 
                                (oscPath: '/3/rotary' ++ i, key: i.asSymbol)
                            }
                        )
                ]
            ),

            // Page 4
            (key: '4',
                elements:[
                    // Slider
                    (key: 'sl',
                        elements: [ 
                            (oscPath: '/4/fader1',
                            type: 'slider', 
                            buttonMode: 'momentary',
                            ioType: \in, 
                            spec: \unipolar) 
                        ]
                    ),
                    // Toggle
                    (key: 'toggle',
                        elements: [ 
                            (oscPath: '/4/toggle1',
                            type: 'button', 
                            buttonMode: 'toggle',
                            ioType: \in, 
                            spec: \but) 
                        ]
                    ),
                    // Push buttons
                    (key: 'bt',
                    shared: (
                        type: 'button', 
                        buttonMode: 'momentary',
                        ioType: \in, 
                        spec: \but
                    ),
                    elements: 
                        (1..2).collect{|i|(oscPath: "/4/push%".format(i).asSymbol) }
                    ),
                    // Multitoggle
                    (key: 'pad',
                    shared: (
                        type: 'button', 
                        buttonMode: 'toggle',
                        ioType: \in, 
                        spec: \but
                    ),
                    elements: 
                        (1..8).collect{|x|
                            (1..16).collect{|y|
                                (oscPath: "/4/multitoggle1/%/%".format(x,y).asSymbol)
                            }
                        }.reshape(128)
                    )
                ]
            )

        ]
    )
);
)
// TEST
/*
( 

m.free; m = MKtl.new(\scosc1, d);

m.postElements;

    var fix = { 
        // tell the collectives action to ...
        m.collectivesDict.keysDo{|k|
            k.postln;
            m.collectivesDict[k].action = { |coll|

                // trigger the group action once ...
                3.do{|x|  
                    m.elAt(\1).action.value(m.elAt(\1));
                };

                // and trigger the individual element actions
                coll.do { |elem| elem.action.value(elem) };
            }
        }
    };


    m.free; m = MKtl.new(\scosc1, d);

    m.resetActions; m.trace;


    n = NetAddr.localAddr;

    // tell m to listen to local osc from SC itself: ( I dont have the app)
    m.device.updateSrcAddr(n.hostname, n.port);

    // Register test actions for all xy sliders on page 1
    (1..4).do{|slnum|
        [\x, \y].do{|k|
            var page = 1;
            m.elAt(page.asSymbol, \sl, slnum.asSymbol, k.asSymbol).action =
                {|sl| "page: %, %, %, % YOO!!!!!".format(page, slnum, k, sl.value).postln}
        }
    };

    // Fix the actions (Modality bug)
    fix.value;

    // Send test values to xy sliders page 1
    4.do{|i|
        i = i + 1;
        n.sendMsg('/1/xy' ++ i.asSymbol, 1.0.rand, 1.0.rand);
    };

    // Test mxy sliders on page 3
    (1..6).do{|slnum|
        var page = 3;
        [\x, \y].do{|k|
            m.elAt(page.asSymbol, \sl, slnum.asSymbol, k.asSymbol).action =
                {|sl| "page:%, %, %, % YOO!!!!!".format(page, slnum, k, sl.value).postln}
        }
    };
    
    // Send test values to xy sliders page 1
    6.do{|i|
        i = i + 1;
        n.sendMsg('/3/multixy1/' ++ i.asSymbol, 1.0.rand, 1.0.rand);
    };

    // Test page 2
    8.do{|i|
        var page=2;
        i = i + 1;

        m.elAt(page.asSymbol, \sl, i).action =
                {|sl| "page:%, %, % YOO!!!!!".format(page, i, sl.value).postln};

     n.sendMsg('/2/multifader1/' ++ i.asSymbol, 1.0.rand);
    };

    8.do{|x| x=x+1; 
        8.do{|y| 
            var page= 2;
            y=y+1;

            m.elAt(page.asSymbol, \bt, ( x+y ).asSymbol ).action =
                {"page:%, %, % YOO!!!!!".format(page, x, y).postln};

            n.sendMsg("/2/multipush1/%/%".format(x,y).asSymbol, 1.0);
        }
    }

)
*/

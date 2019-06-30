/*

iem-pattern.scd
2019-04-03
By: Mads Kjeldgaard, mail@madskjeldgaard.dk

*/

// Setup target
~pluginPort = 1234;
~pluginUDP = NetAddr.localAddr.port_(~pluginPort);

( 
    // Add event type
    Event.addEventType(
        \multiencoder,  
        func: {
            ~azimuth.notNil.if({
                ~target.sendMsg(
                    "/MultiEncoder/azimuth%".format(~source),
                    ~azimuth.linlin(0.0,1.0,-180.0,180.0))
                }
            );

            ~elevation.notNil.if({
                ~target.sendMsg(
                    "/MultiEncoder/elevation%".format(~source), 
                    ~elevation.linlin(0.0,1.0,-180.0,180.0))
                }
            );

            ~gain.notNil.if({
                ~target.sendMsg(
                    "/MultiEncoder/gain%".format(~source), 
                    ~gain.linlin(0.0,1.0,-60.0,10.0))
                }
            );

            ~eventTypes[\note].play; 

        },  
        parentEvent: nil);
)
( 
    Pdef(\test,
        Pbind(
            \instrument, \default,
            \type, \multiencoder,
            \target, ~pluginUDP,
            \source, 1,
            \azimuth, Pwhite(),
            \elevation, Pwhite(),
            \gain, Pwhite(),
            \dur, 0.5
        )
    ).play;
)

Event.eventTypes.keysDo{|k| k.postln}

s.plotTree;

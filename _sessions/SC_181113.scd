/*

- Event type
- OSC setup
- Pattern

*/

(

var sources=16;

var port = 7000;
var max = NetAddr("127.0.0.1", port);
var baseMessage = "/supercollider/";

var oscTransmitter = 
    Pfunc({|ev| 

        var oscArray = [baseMessage ++ (ev.id ?? '') ];

        ev.keysValuesDo{|k,v| 

            // Filter out the 'destination' and 'id' keys
            (k != 'destination' and: {k != 'id'}).if{

            var sendThis = oscArray ++ ['/' ++ k] ++ [v];

            "Sending bundle to % %: %".format(max.ip, port, sendThis).postln;

            max.sendBundle(~latency, sendThis) // Brackets necessary in case value is a string

            }
        };
        
        }
    );

var sendINITMessages = {|ev| 

    ev.keysValuesDo{|k,v| 

            var initPath = 'init';
            var sendThis = [baseMessage ++ initPath ++ '/' ++ k ++ '/'++ v];

            /* if(k.isCollection, {sendThis = sendThis + k.collect{|item| item }}); */
            
            "SENDING INIT MESSAGES TO SPAT".postln;
            "~~~~~~~~~~~~~~".postln;
            "Sending bundle to % %: %".format(max.ip, port, sendThis).postln;

            max.sendBundle(~latency, sendThis) // Brackets necessary in case value is a string

            }

};

var init = (
    source: 'number/16',
    distance: 15
);

// Initialise SPAT
sendINITMessages.value(init);

Pbind(
    \destination, max,
    \id, 'voice0',
    \dur, 1, 
    \source,0,
    \azimuth, Pseq([180, 90],inf),
    \play, oscTransmitter 
).play;

)

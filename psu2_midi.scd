// 
// MUSIC FOR POWER SUPPLIES II
// 
// By Mads Kjeldgaard, 2017
//

// Initialise midi client
MIDIClient.init; 

(
// Basenote
var note1 = 0;

// Set up midi output via internal routing
~mOut = MIDIOut.newByName("intmidi", "supercollider").latency_(Server.default.latency);

// Low psu freq in Ableton
~p1 = Pbind(
    \type, \midi,
    \midiCmd, \noteOn,
    \dur, Pseq([33, Rest(3), 66], inf),
    \stretch, 4,
    \octave, 4,
    \degree, [note1, note1+7],
    \midiout, ~mOut,
    \chan, Pseq([0, 0, 4, 4],inf) ); // Shifts between midi chan 1 and 5

// Mid  psu freq in Ableton
~p2 = Pbindf( ~p1, \octave, 5, \stretch, 3, \chan, 1);

// High psu freq in Ableton
~p3 = Pbindf( ~p2, \octave, 4, \stretch, 2, \chan, 2);

// Top psu freq in Ableton
~p4 = Pbindf( ~p2, \octave, 2, \stretch, 1, \chan, 3, \degree, note1+ Pseq((0..3), inf) );

// Gather all component patterns in one Plambda 
~plam1 = Plambda(
    Ptpar([
        32.0, ~p1,
        64.0, ~p2,
        128.0, ~p3,
        0.0, ~p4
    ])
);

~plam1.play;

)

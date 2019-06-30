//
// Binaural demonstrations
// By Mads Kjeldgaard, DIEM, 2017
//

(

// A demonstration of the haas effect

var haas = {
    // Sound source = noise
    var sound = PinkNoise.ar(0.25);

    // A line going from 0ms to 35 ms in 30 seconds, to control the delay
    var line = Line.kr(start: 1, end: 35, dur: 30, doneAction: 2) / 1000; 

    // Clean sound = left, delayed = right 
    sound = [sound, AllpassC.ar(sound, delaytime: line, decaytime: line)];

    Out.ar(0, sound);
};

haas.play;

s.record;
)

(

// A demonstration of linear panning 

var linearpan = {
    // Sound source = noise
    var sound = PinkNoise.ar(0.25);

    // A line going from 0.0 to 1.0 in amplitude in 30 seconds, to control the panning 
    var line = Line.kr(start: 0.0, end: 1.0, dur: 30, doneAction: 2); 

    // Pan from right to left 
    sound = [sound*line, sound-(sound*line)];

    Out.ar(0, sound);
};

linearpan.play;

//s.record;
)

(

// A demonstration of the franssen effect 

var franssen = {
    // Sound source = Sine Wave at 442 hz, attenuated to a quarter of it's
    // maximum intensity 
    var sound = SinOsc.ar(442) * 0.1 ; 

    // A line going from 1.0 to 0.0 in amplitude in 30 seconds, to control the panning 
    var line = Line.kr(start: 1.0, end: 0.0, dur: 30, doneAction: 0); 

    // Panning oscilator at 442 hz
    var panner = SinOsc.ar(442)*line; 

    // Pan from right to left 
    sound = [sound*panner, sound-(sound*panner)];

    Out.ar(0, sound);
};

franssen.play;

)


(
// Chord progressions
var triads = Array.new;

// Function that generates chord progressions
var x4chords = {|progLength=4| 

    var maxChordNum=6;

    var numOfChords=maxChordNum.pow(progLength); // Set maximum to the biggest amount of possible combinations

    {{maxChordNum.rand}.dup(progLength)}.dup(numOfChords);

};

// Make the chord progressions into triads
/*
triads = x4chords.(4).do{|item, i| 
    Array.fill(item.size, {|y| item[i][y]+2 });
}; 
*/

//triads[1..5].postln;
h=x4chords.(3);

triads = h.do{|item, i| Array.fill(item.size, {|y| item[y]+2 }); }; 

triads[5]
)

// INVERTED TRIADS???
/*
~p1[0] = Pbind(
    \instrument, \pmPerc,
    \degree, Pstutter(2, Pseq(triads[1], inf)),
    \scale, Scale.minor,
    \octave, 4,
    \cutoff, 500,
    \dur, Pseq([0.25, Rest(0.5)],inf),
    \atk, 0, 
    \rel, 0,
    \out, 0
).trace();

~p1.play(fadeTime:8);
*/

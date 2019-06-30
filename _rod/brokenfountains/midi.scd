/*********************************
            MIDI 

"The fountains were broken up by the tuning-fork"

*********************************/


(
p.stop;
m.allNotesOff(1);
m.allNotesOff(2);
m.allNotesOff(3);
m.allNotesOff(4);
m.allNotesOff(5);
q.stop;
m.allNotesOff(0);
e.stop;
f.stop;
)   
(
Scale.directory; // To see all possible scales
Tuning.directory;  // To see all posible tunings
)


(
~scale =  Scale.harmonicMinor;   
a = Array.fill(20, {arg i; 1});
b = Array.fill(10, {arg i; 2});
c = Array.fill(10, {arg i; 3});
d = Array.fill(10, {arg i; 4});
 
~notearray0 = a ++ b ++ c ++ d ++ b ++ c ++ a;
~notearray1 = [-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7];
~notearray2 = ~scale.degrees.reverse;
~notearray3 = ~notearray1.stutter(5);~notearray3.removeAt(0); 
~notearray4 = ~notearray1.scramble;

~root = 2;


    // Chan 0 - 2 x saw -> VS VCF
~lead = 
Pfindur(8,
    Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, m,    // must provide the MIDI target here
    \chan, 0,
    \degree, Pseq([0,7,4,5,3], 8), 
    \scale, ~scale,
    \root, ~root,
    //\mtranspose, -12,
    \octave, 3,
    \dur, Pseq([1,1/2,5/3,1/2, Rest(6)],inf)
));
~lead2 = 
Pfindur(8,
    Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, m,    // must provide the MIDI target here
    \chan, 0,
    \degree, Pseq([0,0,0,0,0], 8), 
    \scale, ~scale,
    \root, ~root,
    //\mtranspose, -12,
    \octave, 4,
    \dur, Pseq([1,1/2,5/3,1/2, Rest(6)],inf)
));

// cHAN 1 - wave mult + benjolin
~serge = 
Pfindur(4,
    Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, m,    // must provide the MIDI target here
    \chan, 1,
    \degree, Prand(~notearray3, inf), 
    \scale, ~scale,
     \root, ~root,
    \octave,4,
    \dur,Pxrand([1/8,1,Rest(1),1/2],inf),
));
// Chan 4 (5 on microbrute) - Microbrute
~mb = 
Pfindur(8,
    Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, m,    // must provide the MIDI target here
    \chan, 4,
    \degree,Pwhite(0,7), 
    \scale, ~scale,
    \root, ~root,
    \octave,4,

    \dur,Prand([1/4, 2/5, 1, Rest(5/3),1/4],inf)
));
)



    ~lead2.play(quant:4);
    ~serge.play(quant:4);
    ~mb.play(quant:4);
    ~mb.stop;

(
~melodiArp.stop;
m.allNotesOff(1);
m.allNotesOff(2);
m.allNotesOff(3);
m.allNotesOff(4);
m.allNotesOff(5);
q.stop;
m.allNotesOff(0);
e.stop;
f.stop;
)

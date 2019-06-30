
MIDIIn.connectAll;
(
// Connect midi device

// Set up bus
~apcmidicc = Bus.control(s, 128);

// Get midi cc data 
// NOTE: Sliders are cc no 48 through 56
MIDIdef.cc(\apccc, {
    arg value, ccno, chan, src; 
    var normalizedvalue = value/127; 
    { 
        ~apcmidicc.setAt(ccno, normalizedvalue);
    }.value
}, chan: 0).permanent_(true);


// Get midi note on data 
MIDIdef.noteOn(\apcnoteon, {
    arg vel, nn, chan, src; 
    { 
    }.value
}, chan:0);

MIDIdef.noteOff(\apcnoteoff, {
    arg vel, nn, chan, src; 
    { 
    }.value
}, chan:0);

)

// Test it out
{var i = ~apcmidicc.kr(128); SinOsc.ar(440*i[48])}.play

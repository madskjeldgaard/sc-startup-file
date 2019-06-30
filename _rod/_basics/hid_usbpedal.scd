(
    // Activate this to see which key is pressed and it's keycode
    w = Window.new("I catch keystrokes");
    w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;
        [char, keycode].postln; };
        w.front;
)

// Using the KeyState ugen – and the keycode (11 for b)
// Test it out
{SinOsc.ar(800, 0, KeyState.kr(11, 0, 0.1)) }.play; //Server-side 

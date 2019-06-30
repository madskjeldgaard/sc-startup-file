~c = Bus.control(s, 1); // 1 channel control bus 
~d = Bus.control(s, 1); // 1 channel control bus 


(
/*** Pattern pattern1 for samplePlayer2 synth ***/
~pattern1 = Pbind(
    \instrument, \samplePlayer2, 
    \loop, 0,
    \buffer, Pseq(o["gw"][1..5],inf), 
    \amp, 0.15,
    \atk, 0.1, 
    \pan, Pwhite(-0.5,0.5,inf),
    \out, 0
);

~pattern1.play;
)

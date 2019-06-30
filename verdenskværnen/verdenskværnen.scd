b = BufFiles.new(s,  "/Volumes/MK_BLUE/ULTIMA/Verdenskværnen/filer-til-sc");
s.options.numOutputBusChannels=64;
s.reboot;
( 
Pdef(\low,
    Pbind(
        \instrument, \bufplayer8,
        \buffer, Pxrand(b, inf),
        \loop, 0, 
        \rate, Pseq([1,-1],inf) * Pexprand(0.5, 0.75),
        \atk, 0.1,
        \sus, 0.001,
        \rel, 0.9,
        \sustain, 2,
        \dur, Pwhite(3,6) 
    )).play;
)

s.meter;

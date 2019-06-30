~dirt = SuperDirt.new;
~dirt.loadSoundFileFolder("/Users/madskjeldgaard/Desktop/SOUNDCENTRAL/ALGOFODDER/909bd", \909);
~dirt.start;

Pbind(\type, \dirt, 
    \dirt, ~dirt, 
    \sound, "909",
    \n, Pseq([0, 10, 25, 2],inf),
    \dur, Pwrand([0.125, Rest(0.5), 0.25], [0.9,0.05, 0.05], inf),
    \room, Pseq([0, 0.21],inf),
    \speed, sin(Ptime(inf))
).play

/***************************

He bore this shower of large meteoric masses.

****************************/
(
// FJEDER SAMPLES

~sounds = Array.new;// Creat array for sounds

~folder = PathName.new("/Users/madskjeldgaard/Desktop/scripts/sc/brokenfountains/fjeder");

// Iterate over all sound files in folder and load them to buffers
~folder.entries.do({
	arg path;
	~sounds = ~sounds.add(Buffer.read(s, path.fullPath));

});

)
~sounds[1].play;
~bd1 = Buffer.read(s, "/Users/madskjeldgaard/Desktop/Samples/DRUMS/909/bd/909BD_T1A1D1V1_Tape.wav");
~bd1.play;
(
// DRUM SAMPLES

~drums = Array.new;// Creat array for sounds

~folder = PathName.new("/Users/madskjeldgaard/Desktop/Samples/DRUMS/909");

// Iterate over all sound files in folder and load them to buffers
~folder.entries.do({
	arg path;
	~drums = ~drums.add(Buffer.read(s, path.fullPath));

});

)

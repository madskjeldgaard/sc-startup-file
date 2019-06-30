/**************************************

               SAMPLES 

***************************************/
(

~sounds = Array.new;// Creat array for sounds

~folder = PathName.new("/Users/madskjeldgaard/Desktop/scripts/sc/granosc/samples/p");

~folder.entries.do({ // Iterate over all sound files in folder and load them to buffers
	arg path;
	~sounds = ~sounds.add(Buffer.read(s, path.fullPath));

});

)

(

a = APCmini.new;

a.setPadModeAll('hold'); 

// Assign synths to pads
~synths = Array2D.new(8,8);

8.do{|x| 
    8.do{|y| 
        // ON
        a.setPadFunction(x,y,1,{
            ~synths.put(x, y, 
                {
                    Warp1.ar(2, 
                        bufnum: 0, 
                        pointer: 0, 
                        freqScale: 1,
                        windowSize: 0.2, 
                        envbufnum: -1, 
                        overlaps: 8, 
                        windowRandRatio: 0, 
                        interp: 1)
                }.play
                );
            });

        // OFF
        a.setPadFunction(x,y,0,{
            ~synths.at(x,y).release;
            })
    }
}
)

~synths

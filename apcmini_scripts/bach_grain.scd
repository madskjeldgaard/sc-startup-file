/*


2DO:
- AMP MOD på grains
- FILTRE PÅ GRAINS
- ENVELOPES
*/



~sf = "~/Desktop/scripts/sc/apcmini_scripts/snd/bird.wav".standardizePath;
~bach = Buffer.read(s, ~sf, startFrame: 0, numFrames: -1);

(

a = APCmini.new;

a.setPadModeAll('switch'); 
a.setNumStatesAll(2);

// Set up busses to contain the slider data 
~slider = Array.fill(9, {Bus.control(s,1)});

// Slider values are normalized
9.do{|slider| 
    a.setSliderFunction(slider, 
        {|sliderindex, slidervalue| 
        ~slider.at(sliderindex).set(slidervalue/128) ;
        }
    )
};

// Assign synths to pads
~synths = Array2D.new(8,8);

8.do{|x| 
    8.do{|y| 

        // ON
        a.setPadFunction(x,y,1,{
            ~synths.put(x, y, 
                {
                    var xy = (x+y) / 64;

                    var s1 = Array.fill(9, {|i|
                        In.kr(~slider.at(i)).linlin(0.0,1.0,0.01,1.0)  
                    });

                    var panner = SinOsc.kr(s1[5]);

                    //var looplength = s1[3] s1[4];
                    
                    var sig = 
                        Warp1.ar(2, 
                        bufnum: ~bach, 
                        pointer: xy,
                        freqScale: s1[8] * 4, //* xy, 
                        windowSize: s1[0] * xy.linexp(0,1,1,0.01), 
                        envbufnum: -1, 
                        overlaps: s1[2] * 4 * xy, 
                        windowRandRatio: s1[3], 
                        interp: 4);

                    // SOME KIND OF FILTER HERE

                    Balance2.ar(sig[0], sig[1], panner ); 

                }.play
                );
            });

        // OFF
        a.setPadFunction(x,y,0,{ ~synths.at(x,y).release(1)});
    }
}
)

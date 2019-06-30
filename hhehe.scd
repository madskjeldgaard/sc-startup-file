( 
    { var signal; var delaytime = MouseX.kr(0.05, 2, 1); // between 50 ms and 2 seconds - exponential. 
    signal = Blip.ar(LFNoise2.kr(0.0001).linexp(-1.0,1.0,40,200),  numharm: 10.0,  mul: 1.0,  add: 0.0);

// compare DelayL, CombL and AllpassL

//d = DelayL.ar(signal, 0.6, delaytime); 
//d = CombL.ar(signal, 0.6, delaytime, MouseY.kr(0.1, 10, 1)); // decay using mouseY 
d = AllpassL.ar(signal, 0.6, delaytime, MouseY.kr(0.1,10, 1));

(signal+d).dup }.play(s) 
)

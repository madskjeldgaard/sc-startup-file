(

// Generative melodies based on the pyramid method in SC
var melody = {
    
    (

    init: {|self, array| 
        self.makePyrs(array); 
        self.makePerms(array);
        //self.makePermutedPyramids();
        self.makeShrinkingMelodies(self.allPyrs);
        self.makePermsAndPyrs;
    },
    
    // All melodic permutations are accessible here
    allPerms: [],

    makePerms: {|self, array| 
       self.allPerms = Array.fill(array.size, {|i| array.permute(i)} );
    }, 

    // All melodic pyramids are accessible here
    allPyrs: [],

    makePyrs: {|self, array| 
        self.allPyrs = Array.fill(10, {|i| array.pyramid(i); }) 
    },

    // Shrinking pyramid melodies
    sPyrs: [],

    makeShrinkingMelodies: {|self, array|
       self.sPyr = array.collect{|item, i| item[i..array.size] } 
    },

    // Permutations and pyramids 
    pP: [],

    makePermsAndPyrs: {|self|

        // For every permutation of the melody, create 10 pyramids
        self.pP = Array.fill2D(self.allPerms.size, 10, {|x,y|
            self.allPerms[x].pyramid(y+1)  
        })

    }

        
    )
};

~mel1 = melody.value;
~mel1.init([0,4,5,3,2,5,6]);
)

~mel1.pP[0]

/*
*
* MIDIII!!!
*
*/ 


MIDIClient.init;    // if not already done

(

var    mOut = MIDIOut.newByName("intmidi", "supercollider").latency_(Server.default.latency);

~p1 = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, mOut,    // must provide the MIDI target here
    \chan, 0,
    \degree, Pseq(~mel1.pP[0].flat,inf),
    \scale, Scale.major,
    \stretch, 1.5,
    \dur, Pbjorklund2(3, Pseq([9,7,8],inf), inf)/10,
    \vel, 127,
    \legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
    \amp, Pexprand(0.5, 1.0, inf)
);
~p1.play;

~p2 = Pbindf(~p1.source,
    \chan, 1,
    \octave, 5,
    \dur, Pbjorklund2(3, 4, inf)/8,
    \degree, Pseq(~mel1.pP[1].flat, inf)
);

~p2.play;

~p3 = Pbindf(~p1.source,
    \chan, 2,
    \octave, 3,
    \dur, Pbjorklund2(3, 12, inf)/8,
    \degree, Pseq(~mel1.pP[2].flat, inf)
);

~p3.play;

)



1+1
2+2
3+3

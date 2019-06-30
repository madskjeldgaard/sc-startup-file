(

// Generative melodies based on the pyramid method in SC
m = (

    init: {|self, array| 
        self.makePyrs(array); 
        self.makePerms(array);
        //self.makePermutedPyramids();
        self.makeShrinkingMelodies(self.allPyrs);
    },
    
    // All melodic permutations are accessible here
    allPerms: [],

    makePerms: {|self, array| 
       self.allPerms = Array.fill(10, {|i| array.permute(i)} );
    }, 

    // All melodic pyramids are accessible here
    allPyrs: [],

    makePyrs: {|self, array| 
        self.allPyrs = Array.fill(10, {|i| array.pyramid(i); }) 
    },

    // Shrinking pyramid melodies
    sPyr: [],

    makeShrinkingMelodies: {|self, array|
       self.sPyr = array.collect{|item, i| item[i..array.size] } 
    }

        
);

m.init((1..5));
)

m.allPerms

// SHRINKING MELODY
(1..10).collect{|item, i| (i..10).permute(i) };

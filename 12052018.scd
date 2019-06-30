~listeningBus = Bus.audio(s, 1);
~frequencyBus = Bus.control(s,1);
(

// Get the frequency of the oscillator
// And post it to a control bus
~trackOscillatorInput = {| oscillatorInput=5|

    var in = SoundIn.ar(oscillatorInput); //In.ar(5, 1);
    var freq, hasFreq;

    # freq, hasFreq = Pitch.kr(in);

    Out.kr(~frequencyBus, freq);
};

// Raise or lower the cv output according to frequency value
~checkFreq = {|targetFreq=200|
    ~frequencyBus.get{|value| 
        "Current frequency: %".format(value).postln;
        case 
            { value.round == targetFreq} {10.do{"perfect!!".postln}}
            { value < targetFreq} {"too low".postln}
            { value > targetFreq} {"too high".postln}
        }
};

// loop the function
~trackOscillatorInput.play;
fork{loop{~checkFreq.value; 0.1.wait}};
)

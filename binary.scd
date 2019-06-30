(

var verbosity = true;

var interpretOneByte = {
    // Calculate the value of one byte

    arg binarycode; var b, c=0; 

    binarycode = binarycode.reverse;

    if (binarycode.size == 8){
        // If the binarycode string has the correct length, iterate over each
        // character and do some math on them
        for (0, 7) { |i|

            b = binarycode[i];

            case
                {b.digit == 1} { c = c + 2.pow(i)} 
                {b.digit == 0} { c = c + 0} 
                {b.digit != 0 && b.digit != 1} { "Digit at register % is not binary".format(i).error} 

            };

        if (verbosity){"Byte interpreted: % = %".format(binarycode[0..].reverse, c).postln;}; 

        c; // Return processed value

        }{
            // If the binarycode string does not contain exactly 8 digits,
            // return an error
            "String has only % characters.  Must contain exactly 8 digits!".format(binarycode.size).error; 
            1;
        };

    };

var setBus = { arg addy, time, amp, freq, detune, bus, chunkno;
    // This functions sets the control bus to the appropriate value
    // First it waits for the amount of time defined in the time byte
    // Then sets the control bus

    fork { 
        
        time.wait; 

        bus.setPairs(addy, amp, addy+1, freq, addy+2, detune); 

        if (verbosity) {  
            10.do{"-".post}; 
            "\n".postln;
            "Chunk % processed and bus set to following values.".format(chunkno).postln;
            "Waited % seconds".format(time).postln;
            "\n".postln;
            "Addy: %".format(addy).postln;
            "Wait: %".format(time).postln;
            "Amp: %".format(amp).postln;
            "Freq: %".format(freq).postln;
            "Detune: %".format(detune).postln;
        };


        }

    };

var interpretChunck =  { arg chunck, chunkno, bus=~ctrl; 
    var addy, time, amp, freq, detune;
    // Interpret a chunck of 8 bytes:

    for (0, 7) { |i|
        case
            // Byte 0: Address
            {i == 0} {addy = interpretOneByte.(chunck[0]);}

            // Byte 1: Wait time
            {i == 1} {time = interpretOneByte.(chunck[1]);}

            // Byte 2: Amplitude
            {i == 2} {amp = interpretOneByte.(chunck[2]);}

            // Byte 3: Frequency 1/4 : 0-255
            {i == 3} {freq = interpretOneByte.(chunck[3])}

            // Byte 4: Frequency 2/4 : 0-255
            {i == 4} {freq = freq + interpretOneByte.(chunck[4])}

            // Byte 5: Frequency 3/4 : 0-255
            {i == 5} {freq = freq + interpretOneByte.(chunck[5])}

            // Byte 6: Frequency 4/4 : 0-255
            {i == 6} {freq = freq + interpretOneByte.(chunck[6]);}

            // Byte 7: Detune frequency (added to fundamental frequency)
            {i == 7} {detune = interpretOneByte.(chunck[7]);};
        };

    
        setBus.(addy, time, amp, freq, detune, bus, chunkno);

    };

var interpretBinaryInstructions = {

    arg listOfInstructions, chunksize=8; 

    var l = Array.new, cleanInstructions, chunk, chunkno;
    
    // Use reg ex to find all bits written in 8 digits
    // And fill an array with pointers to the positions of those bits
    // In the listOfInstructions string

    l = listOfInstructions.findAllRegexp("[0-1]{8}");

    // Then use that info to extract only those instructions to a new array
    cleanInstructions = Array.fill(l.size, 
        {|y| listOfInstructions[l[y]..l[y]+7]});

    forBy(0, cleanInstructions.size-1, chunksize){|i| 

        "\n".post;

        chunkno = i/chunksize;

        10.do{"-".post}; "\n Chunck %".format(chunkno).postln;

       chunk = cleanInstructions[i..i+(chunksize-1)];

       interpretChunck.(chunk, chunkno);

        };
    };

var txt = "
    00000000 
    00000110
    10011011
    11011001
    10011001
    00011101
    10011000
    10110110

    00000000 
    00000111
    10011011
    10011001
    10111001
    00011101
    00011000
    00110110

    00000000 
    00001111
    10011011
    11011001
    10111001
    10011101
    10011000
    10110110

    00000000 
    00001111
    10011011
    11011001
    10111001
    10011101
    10011000
    10110110

    00000000 
    00001111
    10011011
    11011001
    10111001
    10011101
    10011000
    10110110
";  
    
~ctrl = Bus.control(s, 30); // 30 channel control bus 
interpretBinaryInstructions.(txt)
)
~ctrl.scope;
forBy(0, 30, 10) {|i| i.postln;};

t = Task({ });
{fork{ loop{1.wait; ~ctrl.get }}}.play

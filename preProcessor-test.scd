(
this.preProcessor = nil;
this.preProcessor = {|code| 

    code.replace("z", "{|freq = 110, beatfreq = 4| SinOsc.ar([ freq,
        freq-beatfreq ]).sum ! 2}");

};

)

i = z;
i.play
i.set(\beatfreq, 8);
i.play;


".play(1089)".findRegexp("[ 0-9 ]").postln;

".play(10)".findRegexp("play(").postln;


2+2


(
this.preProcessor = {};
this.preProcessor = {|code| 

    var prefix = "emp";

    if (code.beginsWith(prefix),
        { 
            // If our prefix is present, change the passed code to sc code
            code = code[ prefix.size+1 .. ]; // Slice
            code.replace("s", "SinOsc.ar");

            code.findRegexp("[ 0-9 ]*").do{|item, idx| 
                if(item[ 1 ].isEmpty.not, 
                    {
                        "Found %".format(item[ 1 ]).postln;
                        code.replace(item[ 1 ], ("(" ++ item[ 1 ] ++ ")"));
                    }
                )
            };
        }, {
            // If no prefix is present, just evaluate the code
            code
        });
};

)

emp s 110 220 330

"emp hello hello".beginsWith("emp");

a = "hello"
a.size

this.preProcessor = nil;

Interpreter

(
z = "s 110 220 333 ";

z;
)


a = "abcdefg"

a[ 3 ] = 'ø'


"s 110 220 330".findRegexp("[ 0-9 ]*")

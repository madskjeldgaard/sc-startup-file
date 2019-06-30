
this.preProcessor = {|code| 

    code.replace("s", "{|freq, beatfreq| SinOsc.ar([ freq, freq-beatfreq ])};
")

}

s;

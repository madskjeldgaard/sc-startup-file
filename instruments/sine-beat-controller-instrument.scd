k = MKtl('k', "korg-nanokontrol2");

/***************** SOUND *****************/
( 
    5.do{|i| 
        var ndname=( "s" ++ i ).asSymbol;

        // Populate Ndefs
        Ndef(ndname).source = {
            arg freq=0.1, amp=0.25, beat=0.1;
            SinOsc.ar(freq.linexp(0.0,1.0,40,12000) - [0, beat], mul:amp).sum
        };

        // Set defautl values
        Ndef(ndname).set(\freq,(i+1)/40, \amp, 0.25*( (i+1)/5 ), \beat, value{ rrand(0.0,1.0) });

        // Map to controller
        k.elAt('sl', i).action = {|el| Ndef(ndname).set(\freq, el.value.postln)};
        k.elAt('kn', i).action = {|el| Ndef(ndname).set(\beat, el.value.postln)};

        // Master vol
        k.elAt('sl', 7).action = {|el| Ndef.set(\amp, el.value.postln)};
};
)
( 
    Ndef(\s0).play;
    Ndef(\s1).play;
    Ndef(\s2).play;
    Ndef(\s3).play;
)
/***************** MAP *****************/

s.volume = 0

s.record("~/Desktop/bass-sine1.wav".asAbsolutePath, numChannels: 2);

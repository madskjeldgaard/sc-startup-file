Ndef(\happy, {|freq=110, amp| SinOsc.ar(freq)});

Ndef(\happy).controlKeys
Ndef(\happy)[1] = \filter -> {|in, hell| in};

Ndef(\happy).fadeTime_(0)
Ndef(\happy).set(\freq, exprand(100,1000).postln)

l = MKtl('k', "korg-nanokontrol2");

l.gui

l.elAt('sl', '1').action = {|element| Ndef(\happy).set(\freq, element.value.linexp(0.0,1.0, 20,12000))};

Modality

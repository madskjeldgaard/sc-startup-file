l = Leap.new;

(
// Allocate memory
s.options.memSize = 8192 * 64;

// Set sample rate
//s.options.sampleRate= 44100;

// Number of hardware ins / outs
s.options.numOutputBusChannels;
s.options.numInputBusChannels;

// increase this if you are getting drop outs and the message "too many nodes"
s.options.maxNodes = 1024 * 64; 

// Audio meters
s.meter;

// Server visualisation 
s.plotTree;

// ProxySpace setup
//p = ProxySpace.push(s);

// Boot the server 
s.reboot;
)
(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
)
~finger1;
/* --- SYNTH: microLeap --- */
~x.play;
~x.stop;
(
SynthDef(\microLeap, {
    arg out=0, amp=0.1, freq=80,
    atk=1, dur=1, rel=1, pan=0;
    var env, sig;
    var f1 = In.kr(~finger1, 3), f2 = In.kr(~finger2, 3), 
        f3 = In.kr(~finger3, 3), f4 = In.kr(~finger4, 3);
    var h1 = In.kr(~lefthand, 4);
    var f = f1 ++ f2 ++ f3;    

    sig = Array.fill(9, {
        |i| var x = i+1; 
        SinOsc.ar([freq*x, x*freq* f[i]+1], 0, 1/x );
        });  

    sig = Splay.ar(sig,h1[3]);

    sig = sig * amp;
    Out.ar(out, sig )
}).add;

x.free;
x = Synth(\microLeap);
)
x.map(\freq, 120);

/*** Pattern pattern1 for microLeap synth ***/
~pattern1 = Pbind(
  \instrument, \microLeap, 
  \amp, 0.5,
  \freq, Pseq([110,220,440,560],1),
  \dur, Pseq([5,3,2,10]*10, 1),
  \pfunc, Pfunc({"%: pattern1 is playing microLeap synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);
~pattern1.play;

~finger1;

(
~l1 = 
{
var f1,f2,f3, sig; 
f1= In.kr(~finger1, 3);
sig = SinOsc.ar([110, 110 * f1[0]])*0.10;
Out.ar(0, sig!2);
};)

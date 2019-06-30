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
p = ProxySpace.push(s);

// Boot the server 
s.boot;
)

b = Buffer.read(s, "basinski.wav", startFrame: 0, numFrames: -1);
c = Buffer.read(s, "basinski2.wav", startFrame: 0, numFrames: -1);

(
~bas = {

var f=0.125, step = Stepper.ar(trig: Impulse.ar(f*10), reset: Dust.ar(0.001), min: 1, max: 3, step: 0.5);
m = LFSaw.kr(f).range(0, 1);
l = LFCub.kr(0.0001).cubed.fold2;

z = BasinskiBuf.ar(numChannels: 2,buffer:[c,b,c], rate:[3, 1.5, 0.75], trig:1,
start:0, loop:1, loss:[m, 0.10, 0.10], lossFreq:[f, f*2, f]*10, instability:0.05,
noise:[0.3,0.2, 0.1], doneAction: 0, mul: 0.8);

z = DFM1.ar(z, freq: l.range(50,250)*m.range(1,2), res:0).sum * 0.5;

z = Basinski.ar(in: z, loss:l, lossFreq:f, noise:m);

Splay.ar(z.sum*0.10, 1);
//Greyhole.ar(z, delayTime: 2.75, damp: 0.25, size: 4, diff: 0.507,  feedback: 0.25, modDepth: 0.1, modFreq: 2)*0.25

};
~bas.play;
)

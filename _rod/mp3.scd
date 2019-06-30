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

p = ProxySpace.push(s);
p.fadeTime = 4;
// p.clear

b = Buffer.read(s, "adele.wav", startFrame: 0, numFrames: -1);

z = Buffer.alloc(s, 1024,1);
(
~mp3 = {var p = 312; var kbps = p.reciprocal; var r = 12000; var bits=8;

    var in = PlayBuf.ar(2, b, BufRateScale.kr(b) , 1,
      0, 1, doneAction:0);

    in = LPF.ar(in, 14000);  
    k = LFSaw.kr(kbps, mul:p);
    l =  LFSaw.kr(kbps); 
    in = Decimator.ar(in, r, bits);
    in = Splay.ar(SMS.ar(in, maxpeaks: p, currentpeaks: p, tolerance: 32,
        noisefloor: l, freqmult: 5, freqadd: 0, formantpreserve: 0, useifft: 1, ampmult: 1).sum);

    };
~mp3.play;
)
s.avgCPU

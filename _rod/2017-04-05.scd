g = ServerOptionsGui(s);
s.quit;
Server.killAll;
Server.quitAll;
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
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
)
b = Buffer.read(s, "/Users/madskjeldgaard/Desktop/scripts/sc/callfromuganda.wav" , startFrame: 0, numFrames: -1);    
c = Buffer.read(s, "/Users/madskjeldgaard/Desktop/Field\ rec/Vand/Faldstamme_Haderslevgade_Stereo_Piezo\ -\ december\ 2016-24b.wav" , startFrame: 0, numFrames: -1);    
d = Buffer.read(s, "/Users/madskjeldgaard/Library/Application\ Support/SuperCollider/downloaded-quarks/Dirt-Samples/brown/brown1.wav" , startFrame: 0, numFrames: -1);    
e = Buffer.read(s, "/Users/madskjeldgaard/Desktop/Field\ rec/Vand/Springvand Kannikestræde_Stereo_Binaural - marts 2017.WAV" , startFrame: 0, numFrames: -1);    

(
~p.play;
~p = {
    var in, chain, out=0, buffer=e;
    in = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer), 1, 0, 1, doneAction:0);  
    //in = WhiteNoise.ar(0.8);
    chain = FFT(LocalBuf(2048), in)!2;
    //chain = PV_BinScramble(chain, LFSaw.kr(1), LFCub.kr(2), Dust.kr(10))*0.25; 
    //chain = PV_ConformalMap(chain, LFSaw.kr(0.01), LFCub.kr(2.1));
    //chain = PV_Freeze(chain, LFPulse.kr(1));
    chain = PV_BrickWall(chain, MouseX.kr(-1,1));
    //chain = PV_RectComb(chain, numTeeth:32, phase:MouseY.kr, width:MouseX.kr);
    chain = PV_RandComb(chain, 0.5, Impulse.kr(0.4));
    chain = PV_MagSmear(chain, MouseX.kr(0,100));
    chain = IFFT(chain);
    chain = Splay.ar(chain, LFSaw.kr(1));
    Out.ar(out, chain);
    };
/*



SynthDef(\bins, {
    arg out=0, buf=b;
    var in, chain;

    //in = PlayBuf.ar(1, buf, BufRateScale.kr(buf), loop:0, doneAction:0);
    }).add; * */
)
/*** Pattern pattern1 for bins synth ***/
~pattern1 = Pbind(
  \instrument, \bins, 
  \amp, 0.5,
  \dur, Pseq([64],inf),
  \pfunc, Pfunc({"%: pattern1 is playing bins synth".format(Date.getDate.format("%H:%M:%S")).postln}),
  \out, 0
);
~pattern1.play;
~pattern1.free;

( 
    s.reboot;
    s.options.numOutputBusChannels=64;
    s.waitForBoot{
        b = BufFiles.new(s, "/Users/madskjeldgaard/Dropbox/_sound_archive/_real/HANDLING\ NOISE");
        s.record(numChannels: 8);
    };
)
(

    Ndef(\b1, {|rate=1, trig=1, buffer|
        PlayBuf.ar(2, buffer.bufnum, Ndef(\l)*rate*BufRateScale.kr(buffer),trig,0,1)
    }).mold(8).play;

    Ndef(\b1)[1] = \filter -> {|in| in.tanh};
    Ndef(\b1)[1000] = \set -> Pbind(\dur, Pwhite(32, 128), \buffer, Prand(b, inf));
)

Ndef(\b1).xset(\buffer, b[10]);
( 

    Ndef(\l,{|f=0.1| { 1.0.rrand(2.5) * LFCub.kr(f) * LFSaw.kr(f).linexp(-1.0,1.0,0.01,4.0) }!4}).mold(4);
    Ndef(\l).xmap(\f, Ndef(\l2));
    Ndef(\l2, {LFSaw.kr(MouseX.kr).linexp(-1.0,1.0,0.01,5.0)});

)
s.stopRecording

OSCFunc.trace(true, true)

thisProcess.openUDPPort(7001)

"open % .".format("~/").unixCmd
Platform.recordingsDir.openOS



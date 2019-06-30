thisProcess.openUDPPort(1592)
thisProcess.openPorts

OSCFunc.trace(true, true)

OSCFunc.new({|...args| 
    var val = args[0][1]; 
    Ndef(\sin).set(\f, val.linexp(0.0,1.0,40,12000));
},  path: '/right/open/posy',  srcID: nil,  recvPort: 1592);

Ndef(\sin, {|f=110| SinOsc.ar(f,  phase: 0.0, mul:0.5,  add: 0.0)}).fadeTime_(0.001).play;


(
/**************************************** 
              SET TEMPO 
*****************************************/    

var bpm = 140;
TempoClock.default.tempo = bpm/60;
)


s.boot;
s.reboot;
s.reset;
~reverbBus = Bus.audio(s,2);
~r = {Out.ar([0,1], FreeVerb.ar(In.ar(~reverbBus, 2), mix: 0.9, room: 5.7, damp:0.5, mul:1))};
(
/**************************************** 
             hunSaws SynthDef 
*****************************************/    


SynthDef.new(\hunSaws, {
    arg out=~reverbBus, bus= ~granulBus, 
    atk = 0.05, rel=2, envlvl=0.5, curve=0.90, //Envelope parameters 
    maxL=(-0.95), maxR=0.95, pantime=rel/2; // Pan parameters
    var sig, freq;
    // Make array with x number of frequencies
    freq = Array.fill(10, { arg counter; (counter+10)*exprand(10, 100);});
    // Make x number of oscillators and mix them down with Splay, randomize spread
    sig = Splay.ar(
            Saw.ar(
                freq,// set frequency of osc 
                EnvGen.ar(Env.perc(atk, rel, envlvl, curve), doneAction:2);
                ), 
            spread: Saw.kr(exprand(1,5))*exprand(0.1, 0.9)
            );
    //sig = HPF.ar(sig, freq);
    sig = BPF.ar(sig, XLine.kr(10000, 500, rel)); 
    sig = RLPF.ar(sig, XLine.kr(20000, 500, rel-1), rq:1.1);

    sig = Balance2.ar(sig, sig, Line.kr(-1, 1,rel), 0.5);
    sig = Splay.ar(sig, spread: XLine.kr(maxL, maxR, pantime));
    Out.ar(bus, sig);
    Out.ar(out, sig);
}).add;
)
Synth(\hunSaws).play;
(
/**************************************** 
             Granular SynthDef 
*****************************************/    
~granulBus = Bus.audio(s, 2);
SynthDef.new(\grains1, {
    arg out=~reverbBus, in=~granulBus,
    vol = 0.8;
    var sig, env, freq, grn; 
    sig = In.ar(in, 2);
    grn = GrainIn.ar(2, 1, dur:0.55, in:sig,pan:LFNoise0.kr(0.8), mul:0.1); 
    Out.ar(out,sig*vol);


}).send(s);
)
(
~h = Pbind(\instrument, \hunSaws,
           \dur, Pseq([1,Rest(7)], 8),
        );
)
~h = ~h.play;
~h.stop;
~grains = Synth.new(\grains1);

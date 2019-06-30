TempoClock.default.tempo = 2.55;
/*** Pattern pattern1 for synthDefName synth ***/
~p= Ppar([

    Pbind(
        \instrument, \samplePlayer2, 
        \buffer, o["luft"][0],
        \amp, 0.9,
        \rate, [0.25, 0.5,1.5, 2.25], 
        \loOrHi, 1,
        \autopan, 0.25,
        \pan, [-1, -0.5, 0.5,1],
        \atk, 0,
        \res, 0.0,
        \rel,0,
        \cutoff, [200, 200, 200, 300],
        \dur, Pseq([1, Rest(2), 2, Rest(1), 0.25, Rest(1.75)],inf),
        \out, 0
        ).collect({|ev| ~ppp = ev}),

    Pbind(
        \instrument, \samplePlayer1,
        \amp, 0.2,
        \atk, 0, 
        \rel, 0,
        \buffer, o["lot"][0],
        \rate, Prand([1, 2, 1.5],inf),
        \pan, -1,
        \pfunc, Pfunc({ |ev| ev = ~ppp; 
            if (ev.isRest) {
                ev[\dur];
            }{
                Rest(ev[\dur]);
            };}),
        \dur, Pkey(\pfunc)    
    )
],1);
~p.play;
(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 3.05;
// Activate limiter
StageLimiter.activate;
)
(
// Browse SynthDefs
SynthDescLib.global.read;
SynthDescLib.global.browse;
)
~p= Ppar([
    Pfindur(9, Pbind(
        \instrument, \samplePlayer1, 
        \buffer, d["808bd"][50],
        \amp, 0.5,
        \rate, Pseq([3,0.5,2],inf),
        \atk, 0,
        \res, 0.0,
        \rel,0.1,
        \dur, Pseq([0.5, 1.0,0.5, Rest(0.25),0.25, 0.25, 0.75, Rest(0.5),0.5, Rest(1.75), 0.25, 0.25,Rest(1)],inf),
        ), inf).collect({|ev| ~ppp = ev}),

    Pbind(
        \instrument, \samplePlayer1,
        \amp, 0.2,
        \atk, 0, 
        \rel, 0.2,
        \buffer, d["808sd"][5],
        \pfunc, Pfunc({ |ev| ev = ~ppp; 
            if (ev.isRest) {
                ev[\dur].wait; ev[\dur];
            }{
                Rest(ev[\dur]);
            };}),
        \dur, Pkey(\pfunc)    
    ),
    Pbind(
        \instrument, \pmClassic,
        \amp, 0.1,
        \atk, 0, 
        \pmi, 1,
        \rel, 0.0,
        \freq, [155, 153]*2,
        \modfreq, Pkey(\freq)*2,
        \pfunc, Pfunc({ |ev| ev = ~ppp; 
            if (ev.isRest) {
                ev[\dur].wait; ev[\dur]/2;
            }{
                Rest(ev[\dur]);
            };}),
        \dur, Pkey(\pfunc)    
    ),
    Pbind(
        \instrument, \samplePlayer1,
        \amp, 0.02,
        \atk, 0, 
        \rel, 0.2,
        \rate, 1,
        \buffer, d["808hh"][1],
        \pfunc, Pfunc({ |ev| ev = ~ppp; 
            if (ev.isRest) {
                if(0.5.coin){ev[\dur]/8;}{ev[\dur]/12}; 
            }{
                Rest(ev[\dur]);
            };}),
        \dur, Pkey(\pfunc)    
    )
],1);
~p.play;



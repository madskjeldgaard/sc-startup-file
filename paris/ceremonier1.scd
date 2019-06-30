(~b.index;
~rev = Bus.audio(s, 2); // 2 channel audio bus 
~b = Bus.audio(s, 2); // 2 channel audio bus 
TempoClock.default.tempo = 1.33;
)
(
//~basinski = Synth(\basinski, [\inbus, ~b, \out, ~rev, \loss, 0.75]);
~r = Synth(\cheapRev, [\inbus, ~rev]);

r = [0.25, 0.5];
/*** Pattern pattern1 for sample synth ***/
~pattern1 = Pbind(
    \instrument, \samplePlayer2, 
    \amp, 0.3,
    \rate, Pseq([r*3,Rest, r*3.1, Rest, r*3.25, Rest],inf) ,
    \buffer, o["faldstamme"][16],
    \dur, Pseq([1.5, Rest(0.25), 1, Rest(1)], 1),
    \pfunc, Pfunc({"%: pattern1 is playing sample synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \send, 0.25,
    \effectBus, ~rev,
    \out, 0
);

~pattern2 = Pbind(
    \instrument, \samplePlayer2, 
    \amp, 0.3,
    \rate, [5.25 , Pseq([r*3,Rest, r*3.5, Rest, r*3.25, Rest],inf)] ,
    \buffer, o["faldstamme"][5],
    \dur, Pseq([1.5, Rest(0.25), 1, Rest(1)], 1),
    \pfunc, Pfunc({"%: pattern1 is playing sample synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \send, 0.20,
    \effectBus, ~rev,
    \out, 0
);
/*** Pattern fm1 for fm synth ***/
~fm1 = Pbind(
    \instrument, \fmClassic, 
    \amp, 0.1,
    \freq, Pseq([110,160,220],inf),
    \modfreq, Pwhite(50, 300),
    \pan, 1,
    \atk,0,
    \dur, Pseq([1,0.25,1,]*3, 4),
    \pfunc, Pfunc({"%: fm1 is playing fm synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \send, 0.00,
    \effectBus, 10,
    \send, 0.00,
    \out, 0
);
/*** Pattern sand1 for sample synth ***/
~sand1 = Pbind(
    \instrument, \samplePlayer1, 
    \amp, 0.9,
    \rate, [4, 0.25, 2],
    \buffer, Pseq(o["undersand"], inf),
    \rel, 1.25,
    \dur, Pseq([2], 1),
    \autopan, 0.5,
    \pfunc, Pfunc({"%: sand1 is playing sample synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \out, 0
);

/*** Pattern pm for pmClassic synth ***/
~pm = Pbind(
    \instrument, \pmClassic, 
    \amp, 0.3,
    \atk, 0.25,
    \freq, Pseq([110],1),
    \modfreq, Pkey(\freq)/4,
    \dur, Pseq([2], 1),
    \pfunc, Pfunc({"%: pm is playing pmClassic synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \out, 0
);
~mov1 = Pseq([Ppar([Pbindf(~sand1, \cut, 25000), ~pm],1), Rest(1.0)],1);
~mov2 = Pseq([Ppar([Pbindf(~sand1, \cut, 5000), ~pm],1), Rest(1.00)],1);
~mov3 = Pseq([Ppar([Pbindf(~sand1, \cut, 2500), ~pm],1), Rest(1.0)],1);
~mov4 = Pseq([Ppar([Pbindf(~sand1, \cut, 1000), ~pm],1), Rest(1.5)],1);

/*** Pattern pm2 for pmClassic synth ***/
~pm2 = Pbind(
    \instrument, \pmClassic, 
    \amp, Pn(Pseries(0.01, 0.05, 10), inf)*0.75,
    \freq, Pseq([[1220, 880]],inf),
    \pmi, Pn(Pseries(0.1,0.1,10),inf),
    \mod, Pn(Pseries(0.1,0.1,10),inf),
    \atk, 0,
    \rel, 0.125,
    \modfreq, Pkey(\freq)/4,
    \dur, Pseq([0.25], 8),
    \pfunc, Pfunc({"%: pm2 is playing pmClassic synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \send, Pkey(\pmi),
    \autopan, 0.25,
    \autopanfreq, 0.25,
    \effectBus, ~rev,
    \out, 0
).collect({ |event| ~pmEvent= event;});
/*** Pattern pbb for pm synth ***/
~pbb = Pbind(
    \instrument, \fmChaos, 
    \amp, Pseq([0.1525],5),
    \freq, Pfunc({~pmEvent[\freq]})/2,
    \modfreq, Pkey(\freq)/2,
    \dur, Pfunc({~pmEvent[\dur]})*1.5,
    \pan, Pwhite(-1,1,inf),
    \atk,0,
    \pfunc, Pfunc({"%: pbb is playing pm synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \out, 0
);

~pm3 = Pseq([Pbindf(~pm2, \dur, Pseq([Pseq([0.125],6),0.25,0.75],1), \autopan, 0.75), Rest(0.5)],1);
~pm4 = Pseq([Ppar([Pbindf(~pm2, \dur, Pseq([Pseq([0.125],6),1],1), \autopan, 0.75), ~pbb],1), Rest(2)],1);
~pm2 = Pseq([~pm2, Rest(0.5)],1);

/*** Pattern warp1 for warp2 synth ***/
~warp1 = Pbind(
    \instrument, \warp1, 
    \amp, 0.3,
    \buffer, o["lot"][1], 
    \rate, [3.1, 9.33],
    \gdur, 0.025,
    \overlaps, 32, 
    \atk,0.25,
    \pointRate, [0.01,0.25],
    \dur, Pseq([2.5], 1),
    \pfunc, Pfunc({"%: warp1 is playing warp2 synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \effectBus, ~rev,
    \pan, [-0.75, 0.75],
    \send, 0.15,
    \out, 0
);
~dust = Pbind(
    \instrument, \dust, 
    \amp, 0.3,
    \atk, 0.125,
    \density, 30.15,
    \dur, Pseq([1,0.25]*0.5, 1),
    \pfunc, Pfunc({"%: pb3 is playing pm synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \effectBus, ~rev,
    \pan, Pseq([-1, 1],inf),
    \send, Pseq([0,1],inf),
    \out, 0
);

~dust2 = Pbind(
    \instrument, \dust, 
    \amp, 0.3,
    \atk, 0.125,
    \density, 1.15,
    \dur, Pseq([4], 1),
    \pfunc, Pfunc({"%: pb3 is playing pm synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \effectBus, ~rev,
    \pan, 0,
    \send, Pseq([0,1],inf),
    \out, 0
);
/*** Pattern rm1 for ringmod synth ***/
~rm1 = Pbind(
    \instrument, \ringmod1, 
    \amp, Pwhite(0.10, 0.25),
    \freq, Pseq([[880, 888]],inf),
    \modfreq, 333,
    \atk, 0.9,
    \rel, 0.125,
    \pan, Pwhite(-1,1,inf),
    \effectBus, ~rev,
    \send, Pwhite(0.1,1,inf),
    \dur, Pseq([0.25, 1.50, 0.3, 1]/2, 1),
    \pfunc, Pfunc({"%: rm1 is playing ringmod synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \out, 0
);

~rm2 = Pbind(
    \instrument, \ringmod1, 
    \amp, 0.8,
    \rel, 0.1,
    \freq, Pseq([60],inf),
    \modfreq, 20,
    \dur, Pseq([0.33, Rest(0.33), 0.33, Rest(0.33)], 2),
    \atk, Pkey(\dur),
    \pfunc, Pfunc({"%: pm is playing pmClassic synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \out, 0
);

/*** Pattern fmg for fmGrain synth ***/
~fmg = Pbind(
    \instrument, \fmGrain, 
    \amp, 3.5,
    \freq, Pseq([[440,1220,880]],inf),
    \trigrate, 3,
    \gdur, 0.25,
    \lossFreq, 0.25,
    \loss, 0.15,
    \noise,0.1,
    \rel, 0.25,
    \dur, Pseq([1.5, Rest(1.5)], 1),
    \atk, Pkey(\dur),
    \effectBus, ~rev,
    \cutoff, 9500,
    \lfofreq, 8,
    \send, 0.5,
    \pfunc, Pfunc({"%: fmg is playing fmGrain synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \out, 0
);

/*** Pattern nois for noisySquare synth ***/
~nois = Pbind(
    \instrument, \noisySquare, 
    \amp, 0.5,
    \freq, [440, 80, 444],
    \cutoff, 1000,
    \dur, Pseq([1.5, Rest(1.5)], 1),
    \pan, Pwhite(-1,1,inf),
    \effectBus, ~rev,
    \send, 0.25,
    \pwm, [0.25, 0.1, 0.75],
    \pfunc, Pfunc({"%: nois is playing noisySquare synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \out, 0
).collect({ |event| ~noisEvent= event;});

/*** Pattern noisChaos for fmCh synth ***/
~arp = [1220, 880, 990, 1000, 440, 220, 80];
~noisChaos = Pbind(
    \instrument, \sawChaos, 
    \amp, 0.1,
    \freq, Pseq([~arp, ~arp*1.25, ~arp*0.95],inf) ,
    \atk, 0,
    \rel, 0.2,
    \gain, 8,
    \cutoff, 3000,
    \res, 0.9,
    \modfreq, Pkey(\freq)/2,
    \chaosFreq, 80,
    \pan, Pseq([Pn(0.5,4), Pn(-0.5,4)],inf),
    \res, 0.8,
    \dur, Pseq([0.25, 0.75, 0.25, 0.16, 0.16]/8, 16),
    \effectBus, ~rev,
    \send, 0.25,
    \pfunc, Pfunc({"%: noisChaos is playing fmCh synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \out, 0
).collect({|ev| ~chaosEvent=ev;});

/*** Pattern chaos2 for  synth ***/
~chaos2 = Pfindur(4, Pbind(
    \instrument, \sawChaos, 
    \amp, 0.1,
    \freq, Pfunc({~chaosEvent[\freq]})/10,    
    \dur, Pfunc({~chaosEvent[\dur]})*10,    
    \pfunc, Pfunc({"%: chaos2 is playing  synth".format(Date.getDate.format("%H:%M:%S")).postln}),
    \out, 0
));

//Pfunc({~pmEvent[\freq]})/2,

~a = Pseq([
    ~mov1,
    ~pm2,
    ~mov2,
    ~pm3,
    ~mov3,
    ~pm4,
    ~dust
    ],1);

~b = Pseq([
    Ppar([~rm1, ~rm2, ~warp1],1),
    ~dust,
    Rest(2)
    ],2);

~c = Pseq([
    Ppar([~pm, ~nois, ~dust2, ~pattern1],1),
    Rest(2),
    ~dust,
    Ppar([~nois, ~dust2, ~pattern2],1),
    Rest(2),
    ~dust
], 1);
//~nois.play;
//~c.play;
//~fmg.play;

//Ppar([~pm2, ~pbb],1).play;
)
(
// Main
Pseq([ ~a,~b, ~c, ~b, ~a ],1).play
)

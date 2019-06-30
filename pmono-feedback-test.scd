(
// --- SETUP --- //

p = ProxySpace.push(s);
p.fadeTime = 1;
// p.clear

// Start tempoclock
p.makeTempoClock;

//give proxyspace a tempo
p.clock.tempo = 2;

// Activate limiter
StageLimiter.activate;

//Record
//s.record;

)

p.pop;
(
~feedbackbus = Bus.audio(s, 2); 
~feedbackbus2 = Bus.audio(s, 2); 
~feedbackbus3 = Bus.audio(s, 2); 


~mousex = {MouseX.kr(0.25,2) };
~mousey = {MouseY.kr(0.00,1) };

~p1 = Pmono(
    \fb1, 
    \amp, 0.2,
    \freqscale, 0.5*Pseq([0.125, 0.15],inf) * Pseq([1,2,3],inf),
    \winsize, Pseq([0.1,0.5],inf),
    \pitchdisp, Pwhite(0,0.05,inf),
    \timedisp, Pwhite(0,0.05,inf),
    \res, 0.1, //Pseq([0.1,0.5,0.8],inf),
    \slew, Pseq([0.0,0.1,0.5,0.1,1.0],inf),
    \cutoff, Pseq([100,500, 5000, 300, 1200],inf),
    \loOrHi,0,
    \delaytime, Pxrand((0.05, 0.06..0.10),inf),
    \dur, Pseq([8, 12, 16], inf),
    \out, 0
);

~p2 = Pmono(
    \fb1, 
    \amp, 0.2,
    \freqscale, 1.0*Pseq([0.125, 0.15],inf) * Pseq([1,2,3],inf),
    \winsize, Pseq([0.1,0.5],inf),
    \stretch, 0.35,
    \pitchdisp, Pwhite(0,0.05,inf),
    \timedisp, Pwhite(0,0.05,inf),
    \res, 0.1, //Pseq([0.1,0.5,0.8],inf),
    \loOrHi,1,
    \slew, Pseq([0.0,0.1,0.5,0.1,1.0],inf),
    \cutoff, Pseq([100,500, 5000, 300, 1200],inf),
    \loOrHi,0,
    \delaytime, Pxrand((0.05, 0.06..0.10),inf),
    \dur, Pseq([8, 12, 16], inf),
    \out, 0
);

~p3 = Pmono(
    \fb1, 
    \amp, 0.2,
    \freqscale, 1.0*Pseq([0.125, 0.15],inf) * Pseq([1,2,3],inf),
    \winsize, Pseq([0.1,0.5],inf),
    \stretch, 1.35,
    \pitchdisp, Pwhite(0,0.05,inf),
    \timedisp, Pwhite(0,0.05,inf),
    \res, 0.1, //Pseq([0.1,0.5,0.8],inf),
    \loOrHi,1,
    \slew, Pseq([0.0,0.1,0.5,0.1,1.0],inf),
    \cutoff, Pseq([100,500, 5000, 300, 1200],inf),
    \loOrHi,0,
    \feedbackBus, ~feedbackbus3,
    \delaytime, Pxrand((0.05, 0.06..0.10),inf),
    \dur, Pseq([8, 12, 16], inf),
    \out, 0
);

)

~p1.play;
~p2.play;
~p3.play;

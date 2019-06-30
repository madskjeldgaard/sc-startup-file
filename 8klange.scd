(
// TODO: Waveloss bus, Hass bus, multi channel out pseq



/*************** FX **************/

/* --- SYNTH: jpverb --- */
SynthDef(\jpverb, {
    arg inBus, out=0, amp=1.0, time=1, damp=0, size=1, mod=0.25, modfreq=2; 
    var in, sig;

    in = In.ar(inBus, 2); // Stereo

    // Signal
    sig = JPverb.ar(in, t60: time,damp: damp, size: size, 
        earlyDiff: 0.707, modDepth: mod, modFreq: modfreq, 
        lowcut: 500, highcut: 2000);

    sig = sig * amp;
    Out.ar(out, sig )
}).add;

~b = Bus.audio(s, 2); // 2 channel audio bus 

Synth.after(1, \jpverb, [\inBus, ~b, \size, 2.5, \time, 2.5, \modfreq, 0.5, \mod, 0.8]); 
//Synth.after(1, \spectralVoid, [\inBus, ~b]); 


/*************** RODEN **************/

~roden = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pseq(o["fbsc"], 1), 
    \amp, 0.5,
    \dur, 5 * Pgeom(1,1,inf),
    \atk, Pkey(\dur)/2, 
    \rel, Pkey(\dur)/2, 
    \effectBus, ~b, \send, 0.2,
    \out, 0
);


~knopskud1 = Pbindf(~roden, \buffer, Pseq(o["fbsc"].reverse), 
    \stretch, 2, \atk, Pkey(\dur)*1.5, \rel, Pkey(\dur)*1.5, \rate, -0.25, \start, 0.25);

~knopskud2 = Pbindf(~roden, \buffer, Pxrand(o["8klange"], 8), 
    \stretch, 1, \rate, 0.5); 

~knopskud3 = Pbindf(~knopskud2, 
    \instrument, \shimmeringWarpPlayer2_vox3,
    \buffer, Pseq(o["ga"], 1),
    \dur, 8 * Pgeom(1,1,inf) ,
    \stretch, 2.5, \atk, 12, \rel, 8, 
    \pitchenv, Pwhite(0, 0.33, inf), \loOrHi, 1, \filterenv, Pkey(\pitchenv), 
    \cutoff, Pseries(100, 100, inf), \res, 0.25, \autopan, 1, 
    \panfreq, Pwhite(0.0001, 0.01, inf), \rate, Pseq([-0.25, 0.25],inf), \start, 0.10);

~knopskud4 = Pbindf(~knopskud3,
        \filterenv, 0,
        \am, 0.5,
        \rate, 0.5
    );

~knopskud5 = Ppar([
    Pbindf(~knopskud2, \rate, 0.125),
    ~knopskud1]);

~knopskud6 = Pbindf(~knopskud5, 
    \instrument, Pseq([\phaseSyncSamplePlayer2_vox4, \shimmeringSamplePlayer2_vox3], inf), 
    \amp, 0.5, \start, Pwhite(0.1, 0.3), \rate, -0.125);


/*************** MAIN **************/

// Todo: Supra pattern i parallel

~otteklangekomposition = Pseq([~roden, ~knopskud1, ~knopskud2, ~knopskud3, ~knopskud4, ~knopskud5, ~roden], 1);

~knopskud1.play;
~knopskud3.play;


)

LinkClock(1); 
p = ProxySpace.push(s);
p.clock = LinkClock(1); 

(
p.clock = LinkClock(1); 

~p1[0] = Pbind(
    \instrument, \_saw, 
    \note, Pseq([0, 3, 7],inf),
    \dur, 1.0,
    \pan, -1,
    \rel, p.clock.tempo*0.125,
    \out, 0
);

~p1.play(fadeTime:8);

~p2[0] = Pbindf(~p1.source,
    \instrument, \_tri, 
    \note,Pseq([0,2,4],inf),
    \dur, Pseq([Rest(0.5), 0.5],inf) ,
    \pan, 1,
    \out, 0
);

~p2.play(fadeTime:8);

s.record("~/Desktop/korte_sav_og_tri_terts+kvint.aiff");
)

s.meter;

s.stopRecording;

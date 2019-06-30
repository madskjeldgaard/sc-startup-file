p.activeProxies

"Currently active proxies:".postln; 
for(0,p.activeProxies.size-1, {|i| var c = p.activeProxies[i]; if(c.isPlaying,{c.class.postln}, {"no".postln})})

p.monitors[0].name

p.name

p.postln

ProxyMixer.getState

currentEnvironment


dwif


dwif

hwej

hej

o
hej

ohejq€kb


~p1 = Pbind(
    \instrument, \samplePlayer2, 
    \buffer, Pseq(o["omenhits"],inf), 
    \amp, 0.5,
    \dur, Pseq([8, 12, 16], inf),
    \rate, 0.1, 
    \rel, Pkey(\dur), 
    \atk, Pkey(\dur), 
    \out, 0
);

~p1.play(fadeTime:2);

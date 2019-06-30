(
// Make proxyspace
p = ProxySpace.push(s);

// This is the latency found in the Ableton Settings under overall latency
s.latency = 52.7/1000;

// Set the clock of the proxyspace to the Link clock
p.clock = LinkClock(1);

// Create a nodeproxy 
~i = Pbind( \freq, Pseq([100, 200, 300, 400],inf), \atk, 0, \dur, 0.25);

~i.play();
)

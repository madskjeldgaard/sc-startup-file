(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
StageLimiter.activate;
//Record
//s.record;
)
MIDIClient.init;    // if not already done

~s = {SinOsc.kr(freq: 0.01, phase: 0, mul: 1)};

(

    // substitute your own device here
var    mOut = MIDIOut.newByName( "Fireface UC Mac (23741446)", "Port 1").latency_(Server.default.latency);

~l = LinkClock(1);

~p1 = Pbind(
    \type, \midi,
        // this line is optional b/c noteOn is the default
        // just making it explicit here
    \midicmd, \noteOn,
    \midiout, mOut,    // must provide the MIDI target here
    \chan, 0,
        // degree is converted to midinote, not just frequency
    \degree, Pseq([0,1],inf),
    \octave, 4, // Pstutter(32, Pseq([5,4,3],inf)),
    \scale, Scale.minor,
    \stretch, 1, //Pkrlive(~s, 0.5, 2.5),
    \dur,  Pbjorklund2(5, Pseq([12,13,15],inf), inf)/10,
    \vel, 127,
    \aftertouch, Pwhite(0,127,inf),
    \cc5, Pwhite(0,127,inf),
    \legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
    \amp, Pexprand(0.75, 1.0, inf)
);
~p1.play(clock:~l, quant:1);
)


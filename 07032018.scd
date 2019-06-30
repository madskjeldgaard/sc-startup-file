(
p = ProxySpace.push(s);
p.fadeTime = 2;
// p.clear
// Start tempoclock
p.makeTempoClock;
//give proxyspace a tempo
p.clock.tempo = 1;
// Activate limiter
//StageLimiter.activate;
//Record
//s.record;
)


(
~fm1 = {arg freq = 220;

    var rate = [1,
                1.565, 
                1.2134, 
                1.523, 
                1.234, 
                1.424, 
                1.4];

    var op = Array.fill(6, {|i| x=i+1; SinOsc.ar(freq * rate[i]);});

    var sig = (op[0] * op[2] * op[5]) * ( op[0] * op[3]) ;


    sig!2*0.075;
};
)
~fm1.play

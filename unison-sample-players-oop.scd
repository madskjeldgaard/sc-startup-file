(
/*

SYNTH DEFS: UNISON SAMPLE PLAYERS

By Mads Kjeldgaard, may 2018

These are sample players with unison effects inspired by (Ableton's) wavetable synthesizers 

All of the synthdefs have a suffix ala _vox# where # is the number of voices in
the unison effect. 

Note that these algos are purely speculative dsp / math but hey, they sound
juicy, innit! 

*/

var unison = {
    | maxVox = 5, numChans=2, basename='sampleplayer'|

    (
    init: {|self| 
        "---------".postln;
        "making unison sample player synths \n".postln;

        self.sd;

        "done.".postln;
    },

    // These are the different sample player cores which vary in detune/unison design
    cores:(
        unison: {|self, numVoices, buffer, rate=1, trig=1, start=0, loop=0, detune=0.1| 
            var detunes = Array.fill(numVoices, {|i| 
                1 + ((i+1 + detune)/(numVoices))
            });

            PlayBuf.ar(numChans, 
                buffer, 
                BufRateScale.kr(buffer) * [rate * detunes], 
                trig, 
                start * BufFrames.kr(buffer), 
                loop) / numVoices;
        },

        phaseSync: {|self, numVoices, buffer, rate=1, trig=1, start=0, loop=0, detune=0.1| 
            var detunes = Array.fill(numVoices, {|i| 
                1 + ((i+1 + detune)/(numVoices))
            });

            BufRd.ar(numChans, 
                buffer,
                LFSaw.ar(rate*detunes*BufDur.ir(buffer).reciprocal).range(0, BufFrames.ir(buffer))
            ) / numVoices; 

        },

        shimmer: {|self, numVoices, buffer, rate=1, trig=1, start=0, loop=0, detune=0.1, shimscale=15| 
            var shim = Array.fill(numVoices, {
                LFNoise1.kr(110).linlin(-1,1,1.0, 1.00 + (detune/10))
            });
            
            var offsets = Array.fill(numVoices, {|i| 
                x = i+1; i/((1+detune)*shimscale)
            });

            PlayBuf.ar(numChans, 
                buffer, 
                BufRateScale.kr(buffer) * rate * shim, 
                trig, 
                (offsets + start) * BufFrames.kr(buffer), 
                loop
            ) / numVoices;

        },

        spread: {|self, numVoices, buffer, rate=1, trig=1, start=0, loop=0, detune=0.1| 
            var detunes = Array.fill(numVoices, {|i| 
                1 + ((i+1 + detune)/(numVoices*10))
            });

            var offsets = Array.fill(numVoices, {|i| 
                x = i+1;
                BufFrames.ir(buffer)/((1+detune)*x*100)
            });
            
            BufRd.ar(numChans, 
                buffer, 
                offsets +
                LFSaw.ar(rate*detunes*BufDur.ir(buffer).reciprocal).range(0, BufFrames.ir(buffer))
            ) / numVoices; 
        },

        shimmerWarp: {|self, numVoices, buffer, rate=1, grainsize=0.1,
            grainrandomization=0.01, loop=0, detune=0.1, shimscale=15, interp=4| 

            var shim = Array.fill(numVoices, {
                LFNoise1.kr(110).linlin(-1,1,1.0, 1.00 + (detune/100))
            });
            
            var offsets = Array.fill(numVoices, {|i| 
                x = i+1; 
                x/((1+detune)*shimscale)
            });

            var pointer = offsets + LFSaw.ar(rate*BufDur.ir(buffer).reciprocal).range(0, BufFrames.ir(buffer));

            Warp1.ar(numChans, 
                buffer, 
                pointer, 
                rate,
                grainsize, 
                -1, 
                2, 
                grainrandomization, 
                interp) / numVoices;
        }

    ), 

    // Put the pieces together and make the actual SynthDefs iteratively
    sd: {|self| 

        self.cores.keysValuesDo{|coretype, corefunc| 
            maxVox.do{|i| 
                var vox = i+1;

                var name = basename ++ "%_%_vox%".format(numChans, coretype, vox);

                "adding synth: %".format(name).postln;

                SynthDef(name, {|atk=0, dur=1, rel=1, 
                    envcurve='lin',
                    cutoff=20000, res=0.1|

                    var ignoredThisVariable=0; // this is needed to make prependArgs work with the wrapping. I have no idea why 

                    var env = EnvGen.kr(Env([0, 1.0, 0.75, 0.0], [atk, dur, rel], envcurve), doneAction:2);

                    var sig = SynthDef.wrap(corefunc, nil, [ignoredThisVariable, vox]);

                    sig = Splay.ar(sig);

                    sig = DFM1.ar(sig, cutoff + 20, res);

                    Out.ar(0, sig*env);
                }).add;
            }
        }
    }
);

};

// Make the synth defs and add them
unison.value(5, 1).init;
unison.value(5, 2).init;
)

(
// Browse SynthDefs
SynthDescLib.global.read;
SynthDescLib.global.browse;
)

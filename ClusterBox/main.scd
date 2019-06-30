(
s.options.outDevice = "Soundflower (64ch)";
s.options.numOutputBusChannels = 64;
s.options.memSize = 8192*16;
s.reboot;
s.meter;
s.plotTree;
)

(
~prefix = 'cluster';

/* -------------------------------------------------

				 	SYNTHS	

---------------------------------------------------- */

SynthDef(~prefix ++ '_saw', {
    arg out = 0, freq = 100, cutoff = 550, vibrato=0.01, vibratofreq=1,
    resonance = 0.1, amp = 0.05, pan = 0,
    atk = 0.01, dec=0.45, curve=(-4.0), sus=0.1, gate=1, dur = 1, rel = 0.1, detune = 0.001, noise = 0.01, filterEnv = 1,
    filterTime = 0.98, filterBias = 0;
    
    // Envelope stuff

    var vibratosine = SinOsc.kr(vibratofreq, 0, vibrato * freq, 1);
    var e = Env.new([ 0.0, 1.0, 0.8, 0.5, 0.0 ], [ atk, dec, sus, rel ].normalizeSum, curve);

    var env = EnvGen.kr(e, gate, 1, 0, dur, doneAction:14);

    var filterenv = EnvGen.kr(
        e, 
        /* levelScale:cutoff, */ 
        /* levelBias: filterBias, */ 
        timeScale: filterTime, 
        doneAction: 0);

    // Our sound source is a sawtooth wave 
    // To make it stand out even more, we're adding a detuned saw as well
    var sig = DPW4Saw.ar(
        freq: [ vibratosine + freq, vibratosine + freq * detune.linlin(0.0, 1.0, 1.0, 2.0) ]
    ).sum;

    sig = RLPF.ar(
        in: sig, 
        freq: (filterenv * cutoff)+cutoff+20, 
        rq: resonance
    );

    Out.ar(out, Pan2.ar(sig, pan) * env * amp)
}).add;
)

/* -------------------------------------------------

				    GUI	

---------------------------------------------------- */
(

var layout, window, sliderarray;
var fontName = "Helvetica";
var font = Font(fontName, 14);

var h1 = Font(fontName, 14, bold: true);

var objBG = Color.white;

var knobCol = Color.black;

var btnCol = Color.gray(0.9);
var btnColInv = Color.gray(0.75);

var numSliders = 8;

~sliderBusses = numSliders.collect{Bus.control(s,1)};

Font.setDefault(font);

sliderarray = 
    numSliders.collect{|sliderNum|
        VLayout(

            // Slider
            Slider()
            .background_(objBG)
            .knobColor_(knobCol)
            .action_({|obj| 
                // Set sliderbus to value of slider
                ~sliderBusses[sliderNum].set(obj.value);
            }),

            // Label
            StaticText()
                .string_(sliderNum)
                .align_(\center)
            )
        };       

window = View(
        bounds: Rect(0,0,300,200)
    )
    .alwaysOnTop_(true);

layout = VLayout(
            StaticText().string_("Hello").font_(h1), 
            
            Button().states_(
                [["damn", knobCol, btnCol], 
                ["nice buton m8", knobCol, btnColInv]]
            ),
            HLayout( *sliderarray )
    );


window.layout_( layout);

window.front;

/* -------------------------------------------------

					EVENTS

---------------------------------------------------- */

~masterGroup = Group.new;
~synthBus = Bus.audio(s,2);

Event.addParentType(~prefix,
    (
        dur: 64,
        deg: 0,
		instrument: ~prefix ++ '_saw',
        size: 10,
        res: 0.1,
        vib: 1,
        cut: 0.5,
        curve: 0,
        atk: 0.33,
        dec: 0.25,
        sus: 0.15,
        rel: 0.25,
        amp:0.01,
        detune: 0.1,
        harmonics:1,
        out: 0 
    )

);

Event.addEventType(~prefix, 
	Event.default.eventTypes[\note] <> {|server|
	
    var clusterSize = ~size;
    var clusterRand = {|from, to| clusterSize.collect({rrand(from, to)})};

    var harmonics = (1..~harmonics);

	~group = Group.new(target: ~masterGroup, addAction: \addToHead);

	~freq = ~freq * clusterRand.(0.99,1.01) * harmonics; 

	~cutoff = ~cut * clusterRand.(500,1500);   
	~resonance = ~res;
	~filterTime = clusterRand.(0.4,0.99);    

	~detune = ~detune * clusterRand.(0.0001,0.002);    
	~vibrato = ~vib * clusterRand.(0.0001,0.0099);    
	~vibratofreq = ~vib * clusterRand.(0.0001,0.099);    
	
	~pan = clusterRand.(-1.0,1.0);

	server;

});

/* ----------------------------------------------------

                    Output stuff
-------------------------------------------------------*/

/* Synth.tail(~masterGroup, ~prefix ++ '_freqshift', [\freq, (-0.1), \drywet, 1.0, \bus, ~synthBus]); */
/* Synth.tail(~masterGroup, ~prefix ++ '_haas', [\modFreq, 0.5, \modAmount, 1.0, \drywet, 1.0, \bus, ~synthBus]); */
/* Synth.tail(~masterGroup, ~prefix ++ '_freqshift', [\freq, (10.001), \drywet, 1.0]); */
/* Synth.tail(~masterGroup, ~prefix ++ '_verb', [\size, 3, \damp, 0.1, \time, 0.9,\bus, ~synthBus, \drywet, 0.5, \out, 0]); */ 

/* (type: \cluster, midinote:48, size: 10).play; */ 
)

(type: \cluster, 
    /* detune: ~sliderBusses[0].linlin(0.0,1.0,0.25,0.75).asMap, */
    midinote:58, 
    harmonics: 20,
    size: 36
).play; 

(
3.do{|i|
    x = i;
    i = i + 1;

    Pbind(\type, \cluster, 
        \cut, Pseq([0.5, 0.25, 0.6],inf) / i, 
        \vib, i*1, 
        \atk, Pseq([0.4,0.5,0.25,0.75],inf),
        \curve, Pwhite(-10.0,10.0,inf),
        \detune, Pwhite(0.0,1.0,inf)/ i, 
        \harmonics, Pn(Pseries(1,1,3), inf),
        \stretch, i*Pwhite(1.0,1.5,inf), 
        \dur, i*Pseq([13, 64, 128],inf), 
        \octave, 6,
        \note, i*Pxrand([1,5,3,2,1],inf),
        \out, 0 
    ).trace.play;
    }
)

~sliderBusses[0].scope

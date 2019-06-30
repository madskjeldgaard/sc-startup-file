n = NetAddr.new("127.0.0.1",  1234);

// GUI
(
    ~titlefont = Font("Helvetica", 20);
    ~textfont = Font("Helvetica", 12, true);

    ~windowBG=Color.white;
    ~sliderBG=Color.grey(0.99);

    Window.closeAll;
    ~w = Window("IEM MultiEncoder manipulation", bounds:Rect(700,200,400,100)).front.alwaysOnTop_(true);

    // Elements
    ~title = StaticText(~w).string_("sound field distortion").font_(~titlefont);
    ~slider = Slider(~w).orientation_(\horizontal);
    ~modslider = Slider(~w).orientation_(\horizontal);
    ~modulationTarget = PopUpMenu(~w).items_(["elevation", "azimuth", "gain"]);
    ~evenUneven = PopUpMenu(~w).items_(["all", "odd", "even"]);
    ~modulation = PopUpMenu(~w).items_(["none", "saw", "tri", "sine", "random"]);
    ~numSources = NumberBox(~w).clipLo_(1).clipHi_(64).decimals_(0).value_(8);
    ~portNum = NumberBox(~w).clipLo_(1).clipHi_(9999).decimals_(0).value_(6565);
    ~resetBtn = Button(~w).states_([["reset"]]);

    // Layout
    ~vertical = VLayout(
        ~title, 
        StaticText(~w).string_("-------------------------------------------"),
        StaticText(~w).string_("reset"),
        ~resetBtn,
        StaticText(~w).string_("port"),
        ~portNum, 
        StaticText(~w).string_("sources"),
        ~numSources, 
        StaticText(~w).string_("direction"),
        ~modulationTarget, 
        StaticText(~w).string_("selected sources"),
        ~evenUneven,
        StaticText(~w).string_("modulation"),
        ~modulation,
        StaticText(~w).string_("freq"),
        ~modslider,
        StaticText(~w).string_("distortion"),
        ~slider
    );
    ~w.layout = ~vertical;

    // Set color palette
    QtGUI.palette = QPalette.auto(Color.grey(0.99), Color.white).highlight_(Color.black);


    // Port selection
    ~portNum.action_({|obj| n.port_(obj.value) });

    // LFO
    ~lfoname='lfo';
    Ndef(~lfoname, {0});
    Ndef(~lfoname).fadeTime_(0.1);

    ~replyFunc = {|in|
        SendReply.kr(
            Impulse.kr(10), 
            cmdName: '/reply/lfo', 
            values: in.linlin(-1.0,1.0,0.0,1.0)
        );
    };

    OSCdef.new(~lfoname, {|msg ... args|
        var val = msg[3];
        { ~slider.valueAction = val}.defer
    },  '/reply/lfo');

    ~modulation.action_({|obj|
        switch(obj.item,
            "saw", {
                Ndef(~lfoname, {|f| LFSaw.kr(f)});
                Ndef(~lfoname).set(\f, ~slider.value);
                Ndef(~lfoname)[1] = \filter -> ~replyFunc;
            },
            "sine", { 
                Ndef(~lfoname, {|f| SinOsc.kr(f)});
                Ndef(~lfoname).set(\f, ~slider.value);
                Ndef(~lfoname)[1] = \filter -> ~replyFunc;
            },
            "tri", { 
                Ndef(~lfoname, {|f| LFTri.kr(f)});
                Ndef(~lfoname).set(\f, ~slider.value);
                Ndef(~lfoname)[1] = \filter -> ~replyFunc;
            },
            "random", {
                Ndef(~lfoname, {|f| LFNoise2.kr(f)});
                Ndef(~lfoname).set(\f, ~slider.value);
                Ndef(~lfoname)[1] = \filter -> ~replyFunc;
            },
            "none", {
                Ndef(~lfoname, { 0 }) 
            }
        );
    });

    ~modslider.action_({|obj|
        Ndef(~lfoname).set(\f, obj.value.postln);
    });

    // FUNCTIONS
    // Reset sources to a full circle
    ~resetToCircle = {|nums|
        nums.do{|num|
            var azimuth = num.linlin(0, (nums-1).postln, -180.0, 180.0);
            var elevation = 0;
            n.sendMsg("/MultiEncoder/azimuth%".format(num), azimuth);
            n.sendMsg("/MultiEncoder/elevation%".format(num), elevation);
        }
    };

    ~resetBtn.action_({
        ~resetToCircle.value(~numSources.value.asInteger)
    });

    // When changing number of sources
    ~numSources.action_({|nums| 
        n.sendMsg("/MultiEncoder/inputSetting", nums.value.asInteger);
        ~resetToCircle.value(~numSources.value.asInteger);
    });


    // Scale slider value
    ~scaleValueForTarget = {|target, value, sourcenum, totalNumSrcs|
        switch(target,
            "elevation", {
                value.linlin(0.0,1.0,-180.0,180.0);
            },
            "azimuth", {
                var minval = sourcenum/totalNumSrcs;
                value.linlin(0.0,1.0,-180.0,180.0);
            },
            "gain", {
                value.linlin(0.0,1.0,-60.0,10.0);
            }
        );
    };

    // OSC Function
    ~sendFunc = {|target, sendVal, sourcenum|
        n.sendMsg("/MultiEncoder/%%".format(target, sourcenum), sendVal);
    };

    ~oscFunction = {|sliderval|
        var modTarget = ~modulationTarget.item;
        var selected = ~evenUneven.item;
        var numSrcs = ~numSources.value.asInteger.postln;

        numSrcs.do{|sourcenum|
            var sendVal = sliderval.value;

            sendVal = ~scaleValueForTarget.value(modTarget, sendVal, sourcenum, numSrcs);

            // Selection
            switch(selected,
                "even", {
                    sourcenum.even.if{ ~sendFunc.value(modTarget, sendVal, sourcenum) }
                },
                "odd", {
                    sourcenum.odd.if{ ~sendFunc.value(modTarget, sendVal, sourcenum) }
                },
                "all", { 
                    ~sendFunc.value(modTarget, sendVal, sourcenum) 
                }
            );

        };
    };

    ~slider.action_(~oscFunction);

    // INIT STUFF
    // Reset target
    ~resetToCircle.value(~numSources.value.asInteger);
    ~numSources.valueAction = 8;
)
(360-100)

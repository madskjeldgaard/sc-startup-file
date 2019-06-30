// Make a synth which will be used to hold a vst
~synth = Synth.tail(1, \vst2, [\bus, 0]);

// get a handle to the VSTPlugin:
~fx = VSTPluginController(~synth);

// open a plugin:
~fx.open("FabFilter Pro-R", info: true);

( 
    // How many preset files to generate
    ~numPresets = 100;

    // Put preset files in home dir
    ~presetPath = "~/sc_generative0";

    // Make the presets
    ~numPresets.do{ 
        ~presetPath = PathName(~presetPath).nextName;

        ~fx.numParameters.do{|paramnum|
            // Each parameter gets a random value
            ~fx.set(paramnum, 0.0.rrand(1.0))
        };

        ~fx.writeProgram(~presetPath ++ ".fxp");
    };
)

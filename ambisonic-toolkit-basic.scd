s.options.sampleRate = 48000.asInt;
s.reboot;


// ------------------------------------------------------------
// define convenience function to verify number of server outputs
(
~checkMyServerOutputs = { arg server, decoder;
    server.serverRunning.if({
        (decoder.numOutputs > server.options.numOutputBusChannels).if({
            "Number of Server output bus channels is less than number required by Decoder!".warn;
            "Server Outputs: %\n".postf(server.options.numOutputBusChannels);
            "Decoder Outputs: %\n\n".postf(decoder.numOutputs);
            "Update number of Server outputs as illustrated here: ".post;
            "http://doc.sccode.org/Classes/ServerOptions.html#examples".postln;
        }, {
            "Server has an adequate number of output bus channels for use with this Decoder!".postln;
        })
    })
}
)


// ------------------------------------------------------------
// choose a decoder

// stereophonic / binaural
~decoder = FoaDecoderMatrix.newStereo((131/2).degrad, 0.5) // Cardioids at 131 deg
~decoder = FoaDecoderKernel.newUHJ                         // UHJ (kernel)
~decoder = FoaDecoderKernel.newSpherical                   // synthetic binaural (kernel)
~decoder = FoaDecoderKernel.newCIPIC                       // KEMAR binaural (kernel)


// pantophonic (2D)
~decoder = FoaDecoderMatrix.newQuad(k: 'dual')             // psycho optimised quad
~decoder = FoaDecoderMatrix.newQuad(pi/6, 'dual')          // psycho optimised narrow quad
~decoder = FoaDecoderMatrix.new5_0                         // 5.0
~decoder = FoaDecoderMatrix.newPanto(6, k: 'dual')         // psycho optimised hex


// periphonic (3D)
~decoder = FoaDecoderMatrix.newPeri(k: 'dual')             // psycho optimised cube
~decoder = FoaDecoderMatrix.newDiametric(                  // psycho optimised bi-rectangle
    [[30, 0], [-30, 0], [90, 35.3], [-90, 35.3]].degrad,
    'dual'
)


// inspect
~decoder.kind
~checkMyServerOutputs.value(s, ~decoder)


// ------------------------------------------------------------
// define ~renderDecode
(
~renderDecode = { arg in, decoder;
    var kind;
    var fl, bl, br, fr;
    var fc, lo;
    var sl, sr;
    var flu, blu, bru, fru;
    var fld, bld, brd, frd;
    var slu, sru, sld, srd;


    kind = decoder.kind;

    case
        { decoder.numChannels == 2 }
            {
                // decode to stereo (or binaural)
                FoaDecode.ar(in, decoder)
            }
        { kind == 'quad' }
            {
                // decode (to quad)
                #fl, bl, br, fr = FoaDecode.ar(in, decoder);

                // reorder output to match speaker arrangement
                [fl, fr, bl, br]
            }
        { kind == '5.0' }
            {
                // decode (to 5.0)
                #fc, fl, bl, br, fr = FoaDecode.ar(in, decoder);
                lo = Silent.ar;

                // reorder output to match speaker arrangement
                [fl, fr, fc, lo, bl, br]
            }
        { kind == 'panto' }
            {
                // decode (to hex)
                #fl, sl, bl, br, sr, fr = FoaDecode.ar(in, decoder);

                // reorder output to match speaker arrangement
                [fl, fr, sl, sr, bl, br]
            }
        { kind == 'peri' }
            {
                // decode (to cube)
                #flu, blu, bru, fru, fld, bld, brd, frd = FoaDecode.ar(in, decoder);

                // reorder output to match speaker arrangement
                [flu, fru, blu, bru, fld, frd, bld, brd]
            }
        { kind == 'diametric' }
            {
                // decode (to bi-rectangle)
                #fl, fr, slu, sru, br, bl, srd, sld = FoaDecode.ar(in, decoder);

                // reorder output to match speaker arrangement
                [fl, fr, bl, br, slu, sru, sld, srd]
            };
}
)

// ------------------------------------------------------------
// omni encoder
// mono pink noise source


// define encoder matrix
~encoder = FoaEncoderMatrix.newDirection

// inspect
~encoder.kind
~encoder.numChannels
~encoder.dirChannels

(
{
    var sig;                            // audio signal
    var angle, azim;                    // angle and azimuth control


    // display encoder and decoder
    "Ambisonic encoding via % encoder".format(~encoder.kind).postln;
    "Ambisonic decoding via % decoder".format(~decoder.kind).postln;

    // angle ---> top           = push to plane wave
    //            bottom        = omni-directional
    angle = MouseY.kr(pi/2, 0);

    // azimuth -> hard left     = back
    //            centre        = centre
    //            hard right    = back
    azim = MouseX.kr(pi, -pi);

    // ------------------------------------------------------------
    // test sig
    sig = DFM1.ar(SawDPW.ar(freq: (140..145), iphase: 0).sum * 0.015, 200);                         // mono pink noise


    // ------------------------------------------------------------
    // transform
    sig = FoaTransform.ar(sig, 'push', LFCub.kr(0.0513).range(-pi, pi) , azim);

    sig = FoaTransform.ar(sig, 'rtt', 
        LFNoise2.kr(1).range(-pi, pi),
        SinOsc.kr(0.0001).range(-pi, pi), 
        LFSaw.kr(0.001).range(-pi, pi)
    );

    // ------------------------------------------------------------
    // decode (via ~renderDecode)
    ~renderDecode.value(sig, ~decoder)

}.scope;
)

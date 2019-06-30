(

this.preProcessor = { |code|

	code.replace("sine1", "Ndef('sine1', {SinOsc.ar(110)!2}).play")

	code.findRegexp("sine1")
};
)
this.preProcessor = nil
sine1

r ="sine1 110";
o = r.findRegexp("[a-z]*");

z = "here is a sine1 110";
o = z.findRegexp("\\W[0-9]")
u = z.findRegexp("\[0-9]", o[0][0])[0][0]

z[u..]
o[0][0]
z = "sine"

"grep %".format(z, r).unixCmd.postln

Ndef('sin', {SinOsc.ar(110)})

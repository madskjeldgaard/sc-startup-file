(
// SETUP
s.reboot;

s.options.numOutputBusChannels = 4;
p = ProxySpace.push(s);
)





(
{
	PanAz.ar(
		4,
		PinkNoise.ar(0.1),
		//RLPF.ar(DPW4Saw.ar(100), 100 + SinOsc.kr(0.5, 0, 100, 100).clip(100, 200)),
		SinOsc.kr(1)
	) * 0.5

}.play;
)

(
{
	Pan2.ar(
	SinOsc.ar(50),
		SinOsc.kr(0)
	)

}.play;
)
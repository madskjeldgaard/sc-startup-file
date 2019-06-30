/* { */

/* ( */
/*     sine: {|self, freq| SinOsc.ar(freq)}, */
/*     playSine: {|self| {self.sine}.play} */
/* ) */
/* }; */
{
SynthDef(\errorSynthDef, {
    arg out=0, amp=1.0, freq = 'hello';

    var sig = SinOsc.ar([freq, freq*1.01]);

    Out.ar(out, sig )
}, rates:  0.1).add;

}
ls: illegal option -- /
usage: ls [-ABCFGHLOPRSTUWabcdefghiklmnopqrstuwx1] [file ...]

01032018.scd
01042018.scd
01072018.scd
02042018.scd
03032018.scd
03042018.scd
03052018.scd
05032018.scd
05092018.scd
06042018.scd
06052018.scd
07032018.scd
07052018.scd
1
10052018.scd
11042018.scd
112.scd
12032018.scd
12052018.scd
13032018.scd
14032018.scd
15032018.scd
16032018.scd
17042018.tidal
17082018.scd
18032018.scd
19032018.scd
19042018.scd
20001.scd
20032018.scd
2017-04-19.scd
2017-04-27.scd
2017-04-28.scd
2017-07-07.scd
2017-08-15.scd
2017-09-20.scd
2017-09-21.scd
2017-09-24.scd
2017-10-04.scd
2017-10-18.scd
2018-01-01.scd
2018-01-22.scd
2018-01-24.scd
2018-01-25.scd
2018-01-26.scd
2018-01-28.scd
2018-01-29.scd
2018-01-30.scd
2018-01-31.scd
2018-02-01.scd
2018-02-07.scd
2018-02-10.scd
2018-02-15.scd
2018-02-17.scd
2018-02-18.scd
2018-04-26.tidal
2018-04-28.tidal
2018-05-06.tidal
21022018.scd
21032018.scd
21052018.scd
22022018.scd
22032018.scd
23022018.scd
23032018.scd
23042018.scd
23052018.scd
24022018.scd
24032018.scd
24042018.scd
25052018.scd
26022018.scd
26032018.scd
26042018.scd
27022018.scd
27032018.scd
28022018.scd
28032018.scd
28042018.scd
29032018.scd
29042018.scd
29072018.scd
2concerts.scd
8klange.scd
:w
AnalyseEventsDatabase.schelp
AnalyseEventsDatabase.txt
AudioSprayGun_081
ClusterBox
CtkAudio.schelp
CtkAudio.txt
DAF342-acousmatic-live-interface-nanokontrol2.scd
Loop-Like-An-Emperor.schelp
Loop-Like-An-Emperor.txt
PENTES
SuperDirt
SuperPrism
Troop
_MKtlDescriptions
___SCDOCPROBLEMS.txt
_ambisonics
_book code
_controllerism
_halling-processerne
_live
_notes
_other peoples shit
_phrases
_projects
_raspberrypi
_rod
_sessions
_setup.scd
_spectralfun
_synthdefs
_tuts
ableton_midi.scd
adele.wav
afterthescreaming.scd
airrakers
akustik-diatonic.scd
akustik-fundamental.scd
akustik4.scd
ambient-algos
ambisonic-fun1.scd
ambisonic-toolkit-basic.scd
apcmini.scd
apcmini_scripts
apctest.scd
aslaug.scd
basinski.wav
basinski2.wav
binary.scd
binauralakustik.scd
bintest.scd
btest.scd
canetti-punktet.scd
cloudgenmini
computergamelan1.scd
conv.scd
cosctest.scd
ctk-tull.scd
ctkbasic.scd
ctktest.scd
cwejman.scd
daf342_acousmatic
david_design_pattern.scd
dust-grain.scd
electro-drum-kit.scd
essay2.scd
examples
exformal1.scd
exformal3.scd
exformal4.scd
exformal5.scd
exformal6.scd
fb-livecode1-paris.scd
feedback-help.scd
feedbackpatch1.scd
feedbacksynths.scd
feedbackwork1.scd
feedbackworks2.scd
feedbackworks3.scd
feedbackworks4.scd
ffttest.scd
figfun.scd
fm-fun.scd
fonts
fredrik_olofsson_examples_and_guides
gabber-fun.scd
generative-chords.scd
guitarmusic-shimmer.scd
handling_noise
hello.scd
help_file_converter.py
hi.scd
ian.scd
iusedtofloatinmountainstreams_1.scd
ixitest.scd
jaap-patch-1-proxyspace.scd
joke-ambient.scd
korte_sav_terts+kvint.aiff
kroppenskalke.scd
lemurtest1.scd
lpd8-description
lush-feedback-patch.scd
microleap.scd
microlive.scd
microtonalexperiments
microtonalopgave_diem.scd
miditull.scd
modfbexperiments1.scd
modular-calibration.scd
musicforpowersuppliesII.scd
mw1.scd
mw2.scd
mw3.scd
mw3.scd!
mw4.scd
mw5.scd
mw7.scd
mw8.scd
network-drums.scd
nodeproxy-design-test.scd
nvimtest.scd
nytårsfeedback.scd
ohjgasdf.scd
ohshit.scd
oop-example-event.scd
paris
paris-refrag-feedback.scd
part3.scd
performance-algos-feb-march-2018.scd
pitch model.png
pmono-feedback-test.scd
preProcessor-test.scd
proxy_fb.scd
pslide-fun.scd
psu2_midi.scd
pyramids
quaddecor.scd
quadsine.scd
rawsaw.scd
reactpattest.scd
revtest.scd
samplerPseudoUgens.scd
sc-feedback-2.scd
sc-tweets.scd
sc_resources
score-test
sctest.hs
scvim_effects.scd
sd-error.scd
smalley-interface.scd
solhilsen.scd
solhilsen_live.scd
someEvent.scd
spathehe.scd
streams
studies_of_vink
superdirt-livecode.scd
systemekjeldgaard
t.scd
t.scd!
test.scd
test2.scd
testhelp.schelp
testhelp.txt
testsquit.scd
tidal4live_malmo.tidal
tull.scd
twitter.scd
twitterproject
undtagelsestilstand1.scd
undtagelsestilstand2.scd
unison-sample-players-oop.scd
vim_keys.txt
warpinfun.scd
wraptest.scd


zsh:1: command not found: figlettest.scd


 _            _                 _
| |_ ___  ___| |_   ___  ___ __| |
| __/ _ \/ __| __| / __|/ __/ _` |
| ||  __/\__ \ |_ _\__ \ (_| (_| |
 \__\___||___/\__(_)___/\___\__,_|

 (
Pade
 )


 (
	 Pbind(
			 \instrument, \help_sinegrain,
			 \dur, 0.2,
			 \sustain, Pade(1.2, 0.5).linlin(-1.0,1.0,0.03,0.8),
			 \freq, Pade(Pseq([1,5.1,3.5],inf), 2, inf).linlin(-1.0,1.0,200.0,2000.0)

	 ).play;

 )
Server.local.cmdPeriod
 (
	 SynthDef(\help_sinegrain,
		 { arg out = 0, freq = 440, sustain = 0.05;
				 var env;
					 env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
						 Out.ar(out, SinOsc.ar(freq, 0, env))
						 }).add;

 )

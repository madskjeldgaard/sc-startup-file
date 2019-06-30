/********************************************

                MAIN

"The fountains were broken up by the tuning-fork"

********************************************/

// Boot
s.boot;
s.reboot;
s.reset;
s.unmute;
// Set project tempo
(
var bpm = 120;
TempoClock.default.tempo = bpm/60;
)


// List connected out ports with names:
(
MIDIClient.init;
MIDIClient.destinations;
m = MIDIOut(0).latency_(Server.default.latency);
m.midiClock; // Sync with Midi clock
)


/******************************
          SCORE
******************************/
~intro2.play;
~intro1.play;

(

~intro1 = Ppar([~fjeder1,~fjeder6, ~fjeder5,~fjeder2, ~fjeder3], 6);
~intro2 = Ppar([~fjeder1, ~fjeder5],1);


// Intro
Pseq([ ~intro1, ~intro2, ~intro1], 1).play;

)
(
~drumSeq1 = 
    Pseq([
        Ppar([~fjeder2,~lead2,~hhpat2,~saw1],4),
        Rest(4),
        Ppar([~bdpat1,~lead2, ~hhpat2,~sdpat1],4),
        Rest(1),
        Ppar([~cppat1,~mb,~lead, ~bdpat1,~saw2, ~sdpat1],4),
        Ppar([~atmos1, Ppar([~fjeder1,~fjeder2, ~saw3],4)],1),
        Ppar([~atmos2, Ppar([~cppat1, ~serge,~lead2, ~bdpat3, ~hhpat1],8)],1),
        Ppar([~mb, ~bdpat1,~saw2, ~sdpat1],4),
    Pn(~fjeder2,2)]
    );
)
~drumSeq1 = ~drumSeq1.play;
~drumSeq1.play;
~bdpat1.play;
~fjeder1.play;

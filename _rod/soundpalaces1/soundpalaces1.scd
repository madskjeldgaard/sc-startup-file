s.boot;

//s.options.outDevice = "supercollider";
s.options.outDevice = "Built-in Output";

s.options.hardwareBufferSize = 512*2;
s.options.memSize_(65536 * 8);
s.options.memSize;
s.reboot;



/*** SYNTHS ***/
(
    // Stage 1 Synth
    SynthDef(\stage1, 
        {|out = 0, amp = 0.25, freq = 200|
            var sig = SinOsc.ar(In.kr(~ft1x).range(40,400));
            Out.ar(out, sig*amp);
        }
    ).add;

    // Stage 2 Synth
    SynthDef.new(\stage2, 
        {|out = 0, amp = 0.25, freq = 200|
 gt           var sig = SinOsc.ar(In.kr(~ft1x).range(400,600));
            Out.ar(out, sig*amp);
        }
    );

    // Stage 3 Synth
    SynthDef.new(\stage3, 
        {

        }
    );
)
/*** FUNCTION ***/
(
    ~leapfunction = case
        {~lradius.getSynchronous < 50 }{"stage1".postln;} 
        {~lradius.getSynchronous > 50}{"stage2".postln;}; 


)
~leapfunction.value


/*** ROUTINE ***/

(

~routinetest = Routine(
    {
        loop{

            yield(
                // Stage 1 
                300.do{" ~ Stage 1 ~ ".post}
            );


            yield(
                // Stage 2 
                300.do{" ~ Stage 2 ~  ".post}
            );

            yield(
                // Stage 3 
                300.do{" ~ Stage 3 ~   ".post}
            );
        }
    }
);
)
(

~taskforce1.stop;

~taskforce1 = Task({
    loop {

        if(~lgrab.getSynchronous < 0.5){
            "Half grab!".postln;
        }
        else if(~lgrab.getSynchronous > 0.5){
"Whole grab!".postln;
        }


    //~routinetest.next;
    }
    }).play;
) 

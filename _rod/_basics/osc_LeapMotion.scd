/***

LEAP MOTION OSC 

This file pipes all data from the Leap OSC app to control busses

Positional data will be normalized to a scale of 0.0 - 1.0

FINGER DATA 
 
/leap/fingers/[no]/tipposition/ – {x, y, z} – [no] is finger number from 1 to 10 
 
HAND DATA 
 
Note: replace 'left' in message pattern with 'right' for same data on right hand 
 
leap/hands/left/palmposition/ - {x, y, z} 
leap/hands/left/wristposition/ - {x, y, z} 
leap/hands/left/handdirection/ - {x, y, z} 
leap/hands/left/spherecenter/ - {x, y, z} - placed roughly as if the hand were
holding a ball
leap/hands/left/sphereradius/ - {mm} - sphere radius in mm

leap/hands/left/pinch - {pinch} - 0.0 - 1.0 
leap/hands/left/grab - {grab} - 0.0 - 1.0 

leap/hands/left/palmvelocity - {x, y, z} - rate of change of the palm position
in millimeters/second.  

leap/hands/left/timevisible – {time} - time visible in seconds
***/

/*** OSC SETUP ***/
(
s.reboot;
s.reset;
)

(

// Receiving port for OSC
r = 7000; 

// Do you want to print all osc data to the terminal? If so: True
~printOscData = false;

// Finger 1
~ft1x = Bus.control(s, 1);
~ft1y = Bus.control(s, 1);
~ft1z = Bus.control(s, 1);

// trigger
~ft1trig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~ft1y, \outbus, ~ft1trig]);

OSCdef.new(\finger1,
    {|msg, time, from, recvPort| 
    ~ft1x.set(msg[1]);
    ~ft1y.set(msg[2]);
    ~ft1z.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/fingers/1/tipposition/', nil, r); 

OSCdef(\finger1).enable;

// Finger 2
~ft2x = Bus.control(s, 1);
~ft2y = Bus.control(s, 1);
~ft2z = Bus.control(s, 1);

// trigger
~ft2trig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~ft2y, \outbus, ~ft2trig]);

OSCdef.new(\finger2,
    {|msg, time, from, recvPort| 
    ~ft2x.set(msg[1]);
    ~ft2y.set(msg[2]);
    ~ft2z.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/fingers/2/tipposition/', nil, r); 

OSCdef(\finger2).enable;

// Finger 3
~ft3x = Bus.control(s, 1);
~ft3y = Bus.control(s, 1);
~ft3z = Bus.control(s, 1);

// trigger
~ft3trig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~ft3y, \outbus, ~ft3trig]);

OSCdef.new(\finger3,
    {|msg, time, from, recvPort| 
    ~ft3x.set(msg[1]);
    ~ft3y.set(msg[2]);
    ~ft3z.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/fingers/3/tipposition/', nil, r); 

OSCdef(\finger3).enable;

// Finger 4
~ft4x = Bus.control(s, 1);
~ft4y = Bus.control(s, 1);
~ft4z = Bus.control(s, 1);

// trigger
~ft4trig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~ft4y, \outbus, ~ft4trig]);

OSCdef.new(\finger4,
    {|msg, time, from, recvPort| 
    ~ft4x.set(msg[1]);
    ~ft4y.set(msg[2]);
    ~ft4z.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/fingers/4/tipposition/', nil, r); 

OSCdef(\finger4).enable;

// Finger 5
~ft5x = Bus.control(s, 1);
~ft5y = Bus.control(s, 1);
~ft5z = Bus.control(s, 1);

// trigger
~ft5trig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~ft5y, \outbus, ~ft5trig]);

OSCdef.new(\finger5,
    {|msg, time, from, recvPort| 
    ~ft5x.set(msg[1]);
    ~ft5y.set(msg[2]);
    ~ft5z.set(msg[3]);
    if(~printOscData){ msg.postln;}
         },
    '/leap/fingers/5/tipposition/', nil, r); 

OSCdef(\finger5).enable;


// Finger 6
~ft6x = Bus.control(s, 1);
~ft6y = Bus.control(s, 1);
~ft6z = Bus.control(s, 1);

// trigger
~ft6trig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~ft6y, \outbus, ~ft6trig]);

OSCdef.new(\finger6,
    {|msg, time, from, recvPort| 
    ~ft6x.set(msg[1]);
    ~ft6y.set(msg[2]);
    ~ft6z.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/fingers/6/tipposition/', nil, r); 

OSCdef(\finger6).enable;

// Finger 7
~ft7x = Bus.control(s, 1);
~ft7y = Bus.control(s, 1);
~ft7z = Bus.control(s, 1);

// trigger
~ft7trig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~ft7y, \outbus, ~ft7trig]);

OSCdef.new(\finger7,
    {|msg, time, from, recvPort| 
    ~ft7x.set(msg[1]);
    ~ft7y.set(msg[2]);
    ~ft7z.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/fingers/7/tipposition/', nil, r); 

OSCdef(\finger7).enable;

// Finger 8
~ft8x = Bus.control(s, 1);
~ft8y = Bus.control(s, 1);
~ft8z = Bus.control(s, 1);

// trigger
~ft8trig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~ft8y, \outbus, ~ft8trig]);

OSCdef.new(\finger8,
    {|msg, time, from, recvPort| 
    ~ft8x.set(msg[1]);
    ~ft8y.set(msg[2]);
    ~ft8z.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/fingers/8/tipposition/', nil, r); 

OSCdef(\finger8).enable;

// Finger 9
~ft9x = Bus.control(s, 1);
~ft9y = Bus.control(s, 1);
~ft9z = Bus.control(s, 1);

// trigger
~ft9trig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~ft9y, \outbus, ~ft9trig]);

OSCdef.new(\finger9,
    {|msg, time, from, recvPort| 
    ~ft9x.set(msg[1]);
    ~ft9y.set(msg[2]);
    ~ft9z.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/fingers/9/tipposition/', nil, r); 

OSCdef(\finger9).enable;

// Finger 10
~ft10x = Bus.control(s, 1);
~ft10y = Bus.control(s, 1);
~ft10z = Bus.control(s, 1);

// trigger
~ft10trig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~ft10y, \outbus, ~ft10trig]);

OSCdef.new(\finger10,
    {|msg, time, from, recvPort| 
    ~ft10x.set(msg[1]);
    ~ft10y.set(msg[2]);
    ~ft10z.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/fingers/10/tipposition/', nil, r); 

OSCdef(\finger10).enable;

// LEFT PALM POSITION 

~lpalmx = Bus.control(s, 1);
~lpalmy = Bus.control(s, 1);
~lpalmz = Bus.control(s, 1);

OSCdef.new(\leftpalm,
    {|msg, time, from, recvPort| 
    ~lpalmx.set(msg[1]);
    ~lpalmy.set(msg[2]);
    ~lpalmz.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/left/palmposition/', nil, r); 

OSCdef(\leftpalm).enable;

// RIGHT PALM POSITION 

~rpalmx = Bus.control(s, 1);
~rpalmy = Bus.control(s, 1);
~rpalmz = Bus.control(s, 1);

OSCdef.new(\rightpalm,
    {|msg, time, from, recvPort| 
    ~rpalmx.set(msg[1]);
    ~rpalmy.set(msg[2]);
    ~rpalmz.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/right/palmposition/', nil, r); 

OSCdef(\rightpalm).enable;

// LEFT WRIST POSITION 

~lwristx = Bus.control(s, 1);
~lwristy = Bus.control(s, 1);
~lwristz = Bus.control(s, 1);

OSCdef.new(\leftwrist,
    {|msg, time, from, recvPort| 
    ~lwristx.set(msg[1]);
    ~lwristy.set(msg[2]);
    ~lwristz.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/left/wristposition/', nil, r); 

OSCdef(\leftwrist).enable;

// RIGHT WRIST POSITION 

~rwristx = Bus.control(s, 1);
~rwristy = Bus.control(s, 1);
~rwristz = Bus.control(s, 1);

OSCdef.new(\rightwrist,
    {|msg, time, from, recvPort| 
    ~rwristx.set(msg[1]);
    ~rwristy.set(msg[2]);
    ~rwristz.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/right/wristposition/', nil, r); 

OSCdef(\rightwrist).enable;

// LEFT HAND DIRECTION 

~lhanddirx= Bus.control(s, 1);
~lhanddiry= Bus.control(s, 1);
~lhanddirz= Bus.control(s, 1);

OSCdef.new(\lefthanddir,
    {|msg, time, from, recvPort| 
    ~lhanddirx.set(msg[1]);
    ~lhanddiry.set(msg[2]);
    ~lhanddirz.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/left/handdirection/', nil, r); 

OSCdef(\lefthanddir).enable;

// RIGHT HAND DIRECTION 

~rhanddirx= Bus.control(s, 1);
~rhanddiry= Bus.control(s, 1);
~rhanddirz= Bus.control(s, 1);

OSCdef.new(\righthanddir,
    {|msg, time, from, recvPort| 
    ~rhanddirx.set(msg[1]);
    ~rhanddiry.set(msg[2]);
    ~rhanddirz.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/right/handdirection/', nil, r); 

OSCdef(\righthanddir).enable;

// RIGHT SPHERE CENTER 

~rspherex= Bus.control(s, 1);
~rspherey= Bus.control(s, 1);
~rspherez= Bus.control(s, 1);

OSCdef.new(\rightsphere,
    {|msg, time, from, recvPort| 
    ~rspherex.set(msg[1]);
    ~rspherey.set(msg[2]);
    ~rspherez.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/right/spherecenter/', nil, r); 

OSCdef(\rightsphere).enable;

// LEFT SPHERE CENTER 

~lspherex= Bus.control(s, 1);
~lspherey= Bus.control(s, 1);
~lspherez= Bus.control(s, 1);

OSCdef.new(\leftsphere,
    {|msg, time, from, recvPort| 
    ~lspherex.set(msg[1]);
    ~lspherey.set(msg[2]);
    ~lspherez.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/left/spherecenter/', nil, r); 

OSCdef(\leftsphere).enable;

// LEFT SPHERE RADIUS 

~lradius= Bus.control(s, 1);

OSCdef.new(\leftsphereradius,
    {|msg, time, from, recvPort| 
    ~lradius.set(msg[1]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/left/sphereradius/', nil, r); 

OSCdef(\leftsphereradius).enable;

// RIGHT SPHERE RADIUS 

~rradius= Bus.control(s, 1);

OSCdef.new(\rightsphereradius,
    {|msg, time, from, recvPort| 
    ~rradius.set(msg[1]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/right/sphereradius/', nil, r); 

OSCdef(\rightsphereradius).enable;

// LEFT HAND PINCH 

~lpinch= Bus.control(s, 1);

// trigger
~lpinchtrig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~lpinch, \outbus, ~lpinchtrig]);

OSCdef.new(\lefthandpinch,
    {|msg, time, from, recvPort| 
    ~lpinch.set(msg[1]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/left/pinch/', nil, r); 

OSCdef(\lefthandpinch).enable;

// RIGHT HAND PINCH 

~rpinch= Bus.control(s, 1);

// trigger
~rpinchtrig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~rpinch, \outbus, ~rpinchtrig]);

OSCdef.new(\righthandpinch,
    {|msg, time, from, recvPort| 
    ~rpinch.set(msg[1]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/right/pinch/', nil, r); 

OSCdef(\righthandpinch).enable;

// RIGHT HAND GRAB 

~rgrab= Bus.control(s, 1);

// trigger
~rgrabtrig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~rgrab, \outbus, ~rgrabtrig]);

OSCdef.new(\righthandgrab,
    {|msg, time, from, recvPort| 
    ~rgrab.set(msg[1]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/right/grab/', nil, r); 

OSCdef(\righthandgrab).enable;

// LEFT HAND GRAB 

~lgrab= Bus.control(s, 1);

// trigger
~lgrabtrig = Bus.control(s, 1);
Synth.new(\triggerfingers, [\inbus, ~lgrab, \outbus, ~lgrabtrig]);

OSCdef.new(\lefthandgrab,
    {|msg, time, from, recvPort| 
    ~lgrab.set(msg[1]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/left/grab/', nil, r); 

OSCdef(\lefthandgrab).enable;

// LEFT PALM VELOCITY 

~lpalmvelx = Bus.control(s, 1);
~lpalmvely = Bus.control(s, 1);
~lpalmvelz = Bus.control(s, 1);

OSCdef.new(\leftpalmvel,
    {|msg, time, from, recvPort| 
    ~lpalmvelx.set(msg[1]);
    ~lpalmvely.set(msg[2]);
    ~lpalmvelz.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/left/palmvelocity/', nil, r); 

OSCdef(\leftpalmvel).enable;

// RIGHT PALM VELOCITY 

~rpalmvelx = Bus.control(s, 1);
~rpalmvely = Bus.control(s, 1);
~rpalmvelz = Bus.control(s, 1);

OSCdef.new(\rightpalmvel,
    {|msg, time, from, recvPort| 
    ~rpalmvelx.set(msg[1]);
    ~rpalmvely.set(msg[2]);
    ~rpalmvelz.set(msg[3]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/right/palmvelocity/', nil, r); 

OSCdef(\rightpalmvel).enable;

// RIGHT HAND TIME VISIBLE 

~rtimevis= Bus.control(s, 1);

OSCdef.new(\righttimevisible,
    {|msg, time, from, recvPort| 
    ~rtimevis.set(msg[1]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/right/timevisible/', nil, r); 

OSCdef(\righttimevisible).enable;

// LEFT HAND TIME VISIBLE 

~ltimevis= Bus.control(s, 1);

OSCdef.new(\lefttimevisible,
    {|msg, time, from, recvPort| 
    ~ltimevis.set(msg[1]);
    if(~printOscData){ msg.postln;}
    },
    '/leap/hands/left/timevisible/', nil, r); 

OSCdef(\lefttimevisible).enable;

// OSCdef.all; // See all OSC defs
// OSCFunc.trace(false);
)

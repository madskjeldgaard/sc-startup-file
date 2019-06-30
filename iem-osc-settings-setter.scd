n = NetAddr.new("127.0.0.1", port: 9999);

( 
    ~numChans = 16;

    n.sendMsg("/MultiEncoder/inputSetting", ~numChans);

    ~numChans.do{|i|
        n.sendMsg("/MultiEncoder/azimuth%".format(i), i.linlin(0, ~numChans, -180.0, 180.0).postln) ;
        // n.sendMsg("/MultiEncoder/elevation%".format(i), i.linlin(0, ~numChans, -180.0, 180.0).postln) 
    };

)

n.sendMsg("/MultiEncoder/azimuth1", 120)

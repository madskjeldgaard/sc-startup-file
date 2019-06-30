s.boot;
z = Spat.new
z.setDestination(2002)

z.initOper

z.basePath_ ( "/yo" )

z.send(["hello", 10])

f = File.new("~/Desktop/jocelyn.mp3".asAbsolutePath, "r");

File.copy("~/Desktop/jocelyn.mp3".asAbsolutePath, "~/Desktop/copyto/jocelyn.mp3".asAbsolutePath)

Event.eventTypes[\spat].keys

(type: 'spat', elevation: 0.25, yaw: 1).play

z.registerOSCdef('damn', '/oper/source/1/yaw', '/yawfucker')

(
play{
    SendReply.kr(Impulse.kr(1), '/yawfucker', SinOsc.kr(1));
}
)

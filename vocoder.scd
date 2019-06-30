(
{

    var in, fft;

    in = PlayBuf.ar(1, d, BufRateScale.kr(d), 1, 0, 1)*4;
    fft = FFT(LocalBuf(1024, 1), in.tanh, wintype:1);
    DelayN.ar(TPV.ar(fft, 1024, 512, 70, MouseX.kr(1,70), MouseY.kr(0.25,3), 4, 0.2), 3, 3)

}.play
)


s.plotTree;

d = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");

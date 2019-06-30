LoopingSampler2{
    *ar{ arg buffer, rate, start, end;
    var sig;
    
    var numFrames = BufFrames.ir(buffer);
	var sawrate = rate* BufSampleRate.ir(buffer) / (absdif(start, end) * numFrames);
	var phase = (rate.sign * LFSaw.ar(pitchenvelope*sawrate, 1)).range(start,end) * numFrames;

	sig = BufRd.ar(
		numChannels: 2,
		bufnum: buffer,
		phase: phase,
		loop: 0,
		interpolation: 4 // cubic interpolation
	);

    ^sig;

    }
        
}

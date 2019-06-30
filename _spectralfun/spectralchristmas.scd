k = KModules.new;
k['fx']['spectral']
Ndef('hell').gui;
Ndef('hell').play;
Ndef('hell', {|f=110, w=0.5, a=0.5| a * VarSaw.ar(LFSaw.kr(1 * LFSaw.kr(0.01)).range(1.0,1.5) * [f, f*1.01],0,w)});
(
5.do{|i| i = i+1;
	Ndef('hell')[i] = \kfilter -> k['fx']['spectral']['enhance'];
	Ndef('hell').map(\enhance ++ i.asSymbol, Ndef('lfo' ++ i));
};
)
(
Ndef('lfo1', {|f=0.1| LFPar.kr(f)});
Ndef('hell') <<>.numPartials1 Ndef('lfo1');
Ndef('hell') <<>.wet5 Ndef('lfo1');
Ndef('lfo2', {|f=0.152| LFPar.kr(f)});
Ndef('hell') <<>.numPartials2 Ndef('lfo2');
Ndef('hell') <<>.wet4 Ndef('lfo2');
Ndef('lfo3', {|f=0.5213243| LFPar.kr(f)});
Ndef('hell') <<>.numPartials3 Ndef('lfo3');
Ndef('hell') <<>.wet3 Ndef('lfo3');
Ndef('lfo4', {|f=0.04| LFPar.kr(f)});
Ndef('hell') <<>.numPartials4 Ndef('lfo4');
Ndef('hell') <<>.wet2 Ndef('lfo4');
Ndef('lfo5', {|f=0.12345| LFPar.kr(f)});
Ndef('hell') <<>.numPartials5 Ndef('lfo5');
Ndef('hell') <<>.wet1 Ndef('lfo5');
)

k['fx']['spectral']
p = KParticles.new;

KParticles.synthnames[\sin][0]

a = [];
(

1000.do{|i|
	a = a ++ [0.001 + (i/100000),
		[\s_new, KParticles.synthnames[\sin][0], 1001, 0, 1000, \dur, 0.01, \amp, (i/1000)]
	]
})
(
z = Score.new([
	[0.0,
		[\g_new, 1000],
		[\s_new, KParticles.synthnames[\sin][0], 1001, 0, 1000, \dur, 0.01, \amp, 0.1]
	],
	[0.1,
		[\g_new, 1000],
		[\s_new, KParticles.synthnames[\sin][0], 1001, 0, 1000, \dur, 0.01, \amp, 0.2]
	],
	[0.2,
		[\g_new, 1000],
		[\s_new, KParticles.synthnames[\sin][0], 1001, 0, 1000, \dur, 0.01, \amp, 0.3]
	],
	[0.3,
		[\g_new, 1000],
		[\s_new, KParticles.synthnames[\sin][0], 1001, 0, 1000, \dur, 0.01, \amp, 0.4]
	]
]);

)
z.play
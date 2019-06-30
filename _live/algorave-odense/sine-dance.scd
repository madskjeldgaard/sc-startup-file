p = ProxySpace.push(s)
p.fadeTime=10;
p.quant = 1.0;
p.clock = TempoClock.default;

~gDiff = {|d=1| d};
~gDiff.fadeTime=2;
~gDiff[1] = \xset -> Pbind(\dur, Pwrand((1..4), [0.1, 0.5, 0.25, 0.1].normalizeSum, inf), \d, Pseq([1, 0.01, 0.5, 1,1].pyramid));

~gØ = {2pi};
~gøD = {1.1};

~scale = {|s=1| s};
~scale[1] = \xset -> Pbind(\dur, 4, \s, 1+Pseq([0, 0.01, 0.5, 0.1].pyramid));

~basefreq = {80};

(
~sine1 = {|h=1, amp=1| SinOsc.ar([~basefreq,~basefreq-~gDiff] * h * ~scale, [~gØ, ~gøD * ~gØ], amp/h).sum};
~sine2 = {|h=2, amp=1| SinOsc.ar([~basefreq,~basefreq-~gDiff] * h * ~scale,  [~gØ, ~gøD * ~gØ], amp/h).sum};
~sine3 = {|h=3, amp=1| SinOsc.ar([~basefreq,~basefreq-~gDiff] * h * ~scale,  [~gØ, ~gøD * ~gØ], amp/h).sum};
~sine4 = {|h=4, amp=1| SinOsc.ar([~basefreq,~basefreq-~gDiff] * h * ~scale,  [~gØ, ~gøD * ~gØ], amp/h).sum};
~sine5 = {|h=5, amp=0| SinOsc.ar([~basefreq,~basefreq-~gDiff] * h * ~scale,  [~gØ, ~gøD * ~gØ], amp/h).sum};
~sine6 = {|h=6, amp=0| SinOsc.ar([~basefreq,~basefreq-~gDiff] * h * ~scale, ~gØ, amp/h).sum};
~sine7 = {|h=7, amp=0| SinOsc.ar([~basefreq,~basefreq-~gDiff] * h * ~scale, ~gØ, amp/h).sum};
~sine8 = {|h=8, amp=0| SinOsc.ar([~basefreq,~basefreq-~gDiff] * h * ~scale, ~gØ, amp/h).sum};
)
~sine3.mold(1, 'audio');

~sine3.set(\f, 555);
~sine3.awake;

~sine3.play;
~sine3.stop;

~spreader = {|f=0|0.25+SinOsc.kr(f)};

~output.map(\spread, ~spreader);
~output = { |spread=0| Splay.ar([~sine1, ~sine2, ~sine3, ~sine4, ~sine5, ~sine6, ~sine7, ~sine8], spread) * 0.25 };
~output.play;

s.plotTree;
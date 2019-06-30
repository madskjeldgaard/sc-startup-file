(
t = "
00000001
00000001
01010101
01010101
01010101
01010101
01010101
01010101";

b = BinaryComposition.new;
b.interpretBinaryInstructions(t, 8, ~bus);
)
~bus = Bus.control(s, 10); // 1 channel control bus 
~bus.get;

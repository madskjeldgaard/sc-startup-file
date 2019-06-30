s.boot;
(

Ndef(\trajectory, { |gate=1, scale=1,dur=1|
    var numPoints = 512;
    var traj = Array.rand(numPoints, 0.0, 1.0);
    EnvGen.kr(Env(traj), [numPoints.reciprocal], gate, scale, 0, dur).poll;
}
)
)

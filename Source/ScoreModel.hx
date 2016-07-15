package;

import api.IScoreModel;
import msignal.Signal;

class ScoreModel implements IScoreModel
{
    public var score(default, null):Int;

    public function new()
    {
    }

    public function reset()
    {
        score = 0;
    }

    public function increaseScore(points:Int)
    {
        score += points;
    }
}
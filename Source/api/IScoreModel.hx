package api;

import msignal.Signal;

interface IScoreModel
{
    public var score(default, null):Int;

    public function reset():Void;
    public function increaseScore(points:Int):Void;
}
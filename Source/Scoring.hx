package;

import api.IScoreModel;

import msignal.Signal;

import openfl.display.Sprite;
import openfl.text.TextField;

class Scoring extends Sprite
{
    private var _score:Int;
    private var _scoreTextField:TextField;
    private var _model:IScoreModel;

    public function new()
    {
        super();
        init();
    }

    public function init()
    {
        Signals.foodConsumedSignal.add(onFoodConsumed);
        Signals.resetScoreSignal.add(onResetScore);

        _model = new ScoreModel();

        _scoreTextField = new TextField();
        this.addChild(_scoreTextField);

        onResetScore();
    }

    private function onResetScore()
    {
        _model.reset();
        render();
    }

    private function onFoodConsumed()
    {
        trace("on food consumed");
        increaseScore(Constants.FOOD_POINTS_VALUE);
    }

    private function increaseScore(points:Int)
    {
        _model.increaseScore(points);
        render();
    }

    private function render()
    {
        if (_scoreTextField != null)
        {
            _scoreTextField.text = "Score: " + _model.score;
        }
    }
}

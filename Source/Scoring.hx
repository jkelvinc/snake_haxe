package;

import api.IScoreModel;
import api.IDisposable;

import msignal.Signal;

import openfl.display.Sprite;
import openfl.text.TextField;

class Scoring extends Sprite implements IDisposable
{
    private var _score:Int;
    private var _scoreTextField:TextField;
    private var _model:IScoreModel;

    public function new()
    {
        super();

        Signals.foodConsumedSignal.add(onFoodConsumed);
        Signals.resetScoreSignal.add(onResetScore);

        _model = new ScoreModel();

        _scoreTextField = new TextField();
        this.addChild(_scoreTextField);

        onResetScore();
    }

    public function dispose()
    {
        Signals.foodConsumedSignal.remove(onFoodConsumed);
        Signals.resetScoreSignal.remove(onResetScore);
    }

    private function onResetScore()
    {
        _model.reset();
        render();
    }

    private function onFoodConsumed()
    {
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

package;

import openfl.display.Sprite;
import openfl.text.TextField;

class Scoring extends Sprite
{
    private var _score:Int;
    private var _scoreTextField:TextField;


    public function new()
    {
        super();
        init();
    }

    public function init()
    {
        _score = 0;
        _scoreTextField = new TextField();
        _scoreTextField.text = "Score: ";
        this.addChild(_scoreTextField);
    }

    /*
    * To be called when a food has been eaten (signal)
    */
    public function UpdateScore()
    {

    }
}

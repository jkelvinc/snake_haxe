package;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.Lib;

class InputProcessor
{
	public var InputBuffer(default, default):List<InputData>;
	private var _canAcceptInput:Bool;
	private var _lastKeyboardButton:Int;

    public function new()
    {
        InputBuffer = new List<InputData>();
    }

    public function acceptInput()
    {
        // Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }

    public function stopInput()
    {
        // Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }


    private function onKeyDown(evt:KeyboardEvent)
	{
		// if (!_canAcceptInput)
		// {
		// 	return;
		// }

		// var inputData = new InputData();

		// if (evt.keyCode == Keyboard.LEFT && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.RIGHT)
		// {
		// 	// can't go LEFT if we just went RIGHT
		// 	trace("LEFT");
		// 	_lastKeyboardButton = Keyboard.LEFT;
		// 	inputData.Direction = Constants.DIRECTION_LEFT;
		// 	inputData.TurnPositionX = _snake.Model.getHead().x;
		// 	inputData.TurnPositionY = _snake.Model.getHead().y;
		// 	_canAcceptInput = false;
		// }
		// else if (evt.keyCode == Keyboard.RIGHT && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.LEFT)
		// {
		// 	// can't go RIGHT if we just went LEFT
		// 	trace("RIGHT");
		// 	_lastKeyboardButton = Keyboard.RIGHT;
		// 	inputData.Direction = Constants.DIRECTION_RIGHT;
		// 	inputData.TurnPositionX = _snake.Model.getHead().x;
		// 	inputData.TurnPositionY = _snake.Model.getHead().y;
		// 	_canAcceptInput = false;
		// }
		// else if (evt.keyCode == Keyboard.UP && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.DOWN)
		// {
		// 	// can't go UP if we just went DOWN
		// 	trace("UP");
		// 	_lastKeyboardButton = Keyboard.UP;
		// 	inputData.Direction = Constants.DIRECTION_UP;
		// 	inputData.TurnPositionX = _snake.Model.getHead().x;
		// 	inputData.TurnPositionY = _snake.Model.getHead().y;
		// 	_canAcceptInput = false;
		// }
		// else if (evt.keyCode == Keyboard.DOWN && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.UP)
		// {
		// 	// can't go DOWN if we just went UP
		// 	trace("DOWN");
		// 	_lastKeyboardButton = Keyboard.DOWN;
		// 	inputData.Direction = Constants.DIRECTION_DOWN;
		// 	inputData.TurnPositionX = _snake.Model.getHead().x;
		// 	inputData.TurnPositionY = _snake.Model.getHead().y;
		// 	_canAcceptInput = false;
		// }

		// _inputBuffer.add(inputData);
		// // moveSnake(inputData);

		// if (_snake != null)
		// {
		// 	_snake.processInput(_inputBuffer);
		// }
	}
}
package;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.Lib;

class InputProcessor
{
	private var _canAcceptInput:Bool;
	private var _lastKeyboardButton:Int;
	
    public function new()
    {
    }

    public function acceptInput()
    {
        Signals.InputProcessedSignal.add(onInputProcessed);
		
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		_canAcceptInput = true;
    }

    public function stopInput()
    {
        Signals.InputProcessedSignal.remove(onInputProcessed);

        Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		_canAcceptInput = false;
    }


	private function onInputProcessed()
	{
		_canAcceptInput = true;
	}

    private function onKeyDown(evt:KeyboardEvent)
	{
		if (!_canAcceptInput)
		{
			return;
		}

		var inputData = new InputData();

		if (evt.keyCode == Keyboard.LEFT && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.RIGHT)
		{
			// can't go LEFT if we just went RIGHT
			trace("LEFT");
			_lastKeyboardButton = Keyboard.LEFT;
			inputData.Direction = Constants.DIRECTION_LEFT;
			_canAcceptInput = false;
		}
		else if (evt.keyCode == Keyboard.RIGHT && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.LEFT)
		{
			// can't go RIGHT if we just went LEFT
			trace("RIGHT");
			_lastKeyboardButton = Keyboard.RIGHT;
			inputData.Direction = Constants.DIRECTION_RIGHT;
			_canAcceptInput = false;
		}
		else if (evt.keyCode == Keyboard.UP && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.DOWN)
		{
			// can't go UP if we just went DOWN
			trace("UP");
			_lastKeyboardButton = Keyboard.UP;
			inputData.Direction = Constants.DIRECTION_UP;
			_canAcceptInput = false;
		}
		else if (evt.keyCode == Keyboard.DOWN && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.UP)
		{
			// can't go DOWN if we just went UP
			trace("DOWN");
			_lastKeyboardButton = Keyboard.DOWN;
			inputData.Direction = Constants.DIRECTION_DOWN;
			_canAcceptInput = false;
		}

		Signals.InputChangedSignal.dispatch(inputData);
	}
}
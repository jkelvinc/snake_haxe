package;

import api.IInputProcessorAdapter;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.Lib;

class KeyboardInputProcessor implements IInputProcessorAdapter
{
	private var _enabled:Bool;
	private var _lastKeyCode:Int;
	

    public function new()
    {
    }

    public function enable()
    {
        Signals.inputProcessedSignal.add(onInputProcessed);
		
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		_enabled = true;
    }

    public function disable()
    {
        Signals.inputProcessedSignal.remove(onInputProcessed);

        Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		_enabled = false;
    }


	private function onInputProcessed()
	{
		_enabled = true;
	}

    private function onKeyDown(evt:KeyboardEvent)
	{
		if (!_enabled)
		{
			return;
		}

		var inputData = new InputData();

		if (evt.keyCode == Keyboard.LEFT && _lastKeyCode != evt.keyCode && _lastKeyCode != Keyboard.RIGHT)
		{
			// can't go LEFT if we just went RIGHT
			trace("LEFT");
			_lastKeyCode = Keyboard.LEFT;
			inputData.direction = Constants.DIRECTION_LEFT;
			_enabled = false;
		}
		else if (evt.keyCode == Keyboard.RIGHT && _lastKeyCode != evt.keyCode && _lastKeyCode != Keyboard.LEFT)
		{
			// can't go RIGHT if we just went LEFT
			trace("RIGHT");
			_lastKeyCode = Keyboard.RIGHT;
			inputData.direction = Constants.DIRECTION_RIGHT;
			_enabled = false;
		}
		else if (evt.keyCode == Keyboard.UP && _lastKeyCode != evt.keyCode && _lastKeyCode != Keyboard.DOWN)
		{
			// can't go UP if we just went DOWN
			trace("UP");
			_lastKeyCode = Keyboard.UP;
			inputData.direction = Constants.DIRECTION_UP;
			_enabled = false;
		}
		else if (evt.keyCode == Keyboard.DOWN && _lastKeyCode != evt.keyCode && _lastKeyCode != Keyboard.UP)
		{
			// can't go DOWN if we just went UP
			trace("DOWN");
			_lastKeyCode = Keyboard.DOWN;
			inputData.direction = Constants.DIRECTION_DOWN;
			_enabled = false;
		}

		Signals.inputChangedSignal.dispatch(inputData);
	}
}
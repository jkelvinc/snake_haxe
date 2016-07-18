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
		_lastKeyCode = -999;
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
		if (!_enabled || _lastKeyCode == evt.keyCode)
		{
			return;
		}

		_lastKeyCode = evt.keyCode;
		var inputData = new InputData();

		switch (evt.keyCode)
		{
			case Keyboard.LEFT:
			{
				inputData.direction = Constants.DIRECTION_LEFT;
				_enabled = false;
			}
		
			case Keyboard.RIGHT:
			{
				inputData.direction = Constants.DIRECTION_RIGHT;
				_enabled = false;
			}

			case Keyboard.UP:
			{
				inputData.direction = Constants.DIRECTION_UP;
				_enabled = false;
			}

			case Keyboard.DOWN:
			{
				inputData.direction = Constants.DIRECTION_DOWN;
				_enabled = false;
			}
		}

		Signals.inputChangedSignal.dispatch(inputData);
	}
}
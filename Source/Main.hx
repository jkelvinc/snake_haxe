package;

import api.IUpdatable;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.events.KeyboardEvent;
import openfl.utils.Timer;
import openfl.events.TimerEvent;
import openfl.ui.Keyboard;

// import msignal.Signal;

enum GameState {
	Paused;
	Playing;
}

class Main extends Sprite
{
	private var _isInitialzed:Bool;

	private var _snake:Snake;
	private var _food:Food;
	private var _scoring:Scoring;
	private var _timer:Timer;

	private var _updateList:List<IUpdatable>;
	private var _lastKeyboardButton:Int;

	/* ENTRY POINT */

	function onResize(e)
	{
		if (!_isInitialzed)
		{
			init();
		}
		// else (resize or orientation change)
	}

	function init()
	{
		if (_isInitialzed)
		{
			return;
		}
		_isInitialzed = true;

		_updateList = new List<IUpdatable>();

		stage.addEventListener(KeyboardEvent.KEY_DOWN, onInputChanged);
		stage.addEventListener(Event.ENTER_FRAME, onUpdate);

		// TODO: take a look at IOC via minject

		_scoring = new Scoring();
		this.addChild(_scoring);

		_snake = new Snake(Constants.MIN_SNAKE_SECTIONS_COUNT);
        this.addChild(_snake);

		_food = new Food(0xFF0000, _snake.Model);
		this.addChild(_food);

		_snake.Food = _food;
		// _snake.DiedSignal.add(onSnakeDied);

		_updateList.add(_snake);
	}

	/* SETUP */

	public function new()
	{
		super();

		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	public static function main()
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
		//
	}

	private function onUpdate(evt:Event)
	{
		for (obj in _updateList)
		{
			if (obj != null)
			{
				obj.update();
			}
		}
	}

	private function onAddedToStage(e)
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		stage.addEventListener(Event.RESIZE, onResize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}

	private function onSnakeDied()
	{
		trace("Snake Died");
	}

	private function onInputChanged(evt:KeyboardEvent)
	{
		if (evt.keyCode == Keyboard.LEFT && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.RIGHT)
		{
			// can't go LEFT if we just went RIGHT
			trace("LEFT");
			_lastKeyboardButton = Keyboard.LEFT;
		}
		else if (evt.keyCode == Keyboard.RIGHT && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.LEFT)
		{
			// can't go RIGHT if we just went LEFT
			trace("RIGHT");
			_lastKeyboardButton = Keyboard.RIGHT;
		}
		else if (evt.keyCode == Keyboard.UP && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.DOWN)
		{
			// can't go UP if we just went DOWN
			trace("UP");
			_lastKeyboardButton = Keyboard.UP;
		}
		else if (evt.keyCode == Keyboard.DOWN && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.UP)
		{
			// can't go DOWN if we just went UP
			trace("DOWN");
			_lastKeyboardButton = Keyboard.DOWN;
		}
	}
}

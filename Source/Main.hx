package;

import api.IUpdatable;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.events.KeyboardEvent;
import openfl.utils.Timer;
import openfl.events.TimerEvent;
import openfl.ui.Keyboard;

class Main extends Sprite
{	
	private var _isInitialzed:Bool;

	private var _snake:Snake;
	private var _food:Food;
	private var _scoring:Scoring;
	private var _timer:Timer;

	private var _updateList:List<IUpdatable> = new List<IUpdatable>();
	private var _lastKeyboardButton:Int;
	private var _canAcceptInput:Bool;
	private var _inputProcessor:InputProcessor;

	// private var _inputBuffer:List<InputData> = new List<InputData>();

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
		_canAcceptInput = true;
		_updateList.clear();

		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(Event.ENTER_FRAME, onUpdate);

		_inputProcessor = new InputProcessor();

		// TODO: take a look at IOC via minject

		_scoring = new Scoring();
		this.addChild(_scoring);

		_snake = new Snake(Constants.MIN_SNAKE_SECTIONS_COUNT);
        this.addChild(_snake);

		_food = new Food(0xFF0000, _snake.Model);
		this.addChild(_food);

		_snake.Food = _food;
		_snake.SnakeDiedSignal.add(onSnakeDied);
		_snake.InputProcessedSignal.add(onInputProcessed);
		_snake.setInputProcessor(_inputProcessor);

		_inputProcessor.acceptInput();
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

		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.removeEventListener(Event.ENTER_FRAME, onUpdate);
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
			inputData.TurnPositionX = _snake.Model.getHead().x;
			inputData.TurnPositionY = _snake.Model.getHead().y;
			_canAcceptInput = false;
		}
		else if (evt.keyCode == Keyboard.RIGHT && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.LEFT)
		{
			// can't go RIGHT if we just went LEFT
			trace("RIGHT");
			_lastKeyboardButton = Keyboard.RIGHT;
			inputData.Direction = Constants.DIRECTION_RIGHT;
			inputData.TurnPositionX = _snake.Model.getHead().x;
			inputData.TurnPositionY = _snake.Model.getHead().y;
			_canAcceptInput = false;
		}
		else if (evt.keyCode == Keyboard.UP && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.DOWN)
		{
			// can't go UP if we just went DOWN
			trace("UP");
			_lastKeyboardButton = Keyboard.UP;
			inputData.Direction = Constants.DIRECTION_UP;
			inputData.TurnPositionX = _snake.Model.getHead().x;
			inputData.TurnPositionY = _snake.Model.getHead().y;
			_canAcceptInput = false;
		}
		else if (evt.keyCode == Keyboard.DOWN && _lastKeyboardButton != evt.keyCode && _lastKeyboardButton != Keyboard.UP)
		{
			// can't go DOWN if we just went UP
			trace("DOWN");
			_lastKeyboardButton = Keyboard.DOWN;
			inputData.Direction = Constants.DIRECTION_DOWN;
			inputData.TurnPositionX = _snake.Model.getHead().x;
			inputData.TurnPositionY = _snake.Model.getHead().y;
			_canAcceptInput = false;
		}

		// _inputBuffer.add(inputData);
		moveSnake(inputData);
	}

	private function moveSnake(data:InputData):Void
	{
		if (_snake != null)
		{
			trace("moveSnake: " + _snake);
			_snake.processInput(data);
		}
	}
}

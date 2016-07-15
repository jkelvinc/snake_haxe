package;

import api.IUpdatable;
import api.IInputProcessorAdapter;

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
	private var _inputProcessor:IInputProcessorAdapter;


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
		_updateList.clear();

		stage.addEventListener(Event.ENTER_FRAME, onUpdate);

		_inputProcessor = new KeyboardInputProcessor();

		// TODO: take a look at IOC via minject

		_scoring = new Scoring();
		this.addChild(_scoring);

		_snake = new Snake(Constants.MIN_SNAKE_SECTIONS_COUNT);
        this.addChild(_snake);

		_food = new Food(0xFF0000, _snake.Model);
		this.addChild(_food);

		_snake.Food = _food;
		_snake.SnakeDiedSignal.add(onSnakeDied);
		
		_inputProcessor.enable();
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
		// stop all input
		if (_inputProcessor != null)
		{
			_inputProcessor.disable();
		}

		// remove snake

		// generate food

		// start game

		// accept input
		if (_inputProcessor != null)
		{
			_inputProcessor.enable();
		}
		
		stage.removeEventListener(Event.ENTER_FRAME, onUpdate);
	}
}

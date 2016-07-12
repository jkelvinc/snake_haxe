package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.events.KeyboardEvent;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

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

		// TODO: take a look at IOC via minject

		_scoring = new Scoring();
		this.addChild(_scoring);

		_snake = new Snake(Constants.MIN_SNAKE_SECTIONS_COUNT);
        this.addChild(_snake);

		_food = new Food(0xFF0000, _snake.Model);
		this.addChild(_food);

		_snake.Food = _food;
		// _snake.DiedSignal.add(onSnakeDied);

		_timer = new Timer(33);
		_timer.addEventListener(TimerEvent.TIMER, timerTick);
		_timer.start();
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

	private function timerTick(timerEvent:TimerEvent):Void
	{
		if (_snake != null)
		{
			_snake.tick(timerEvent);
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
}

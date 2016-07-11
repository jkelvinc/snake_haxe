package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

enum GameState {
	Paused;
	Playing;
}

class Main extends Sprite
{
	private var _isInitialzed:Bool;

	private var _snake:Snake;
	
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

		_snake = new Snake(5);
		trace("Created new snake");

        this.addChild(_snake);
	}

	/* SETUP */

	public function new()
	{
		super();

		trace("Main");
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	function onAddedToStage(e)
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		stage.addEventListener(Event.RESIZE, onResize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}

	public static function main()
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
		//
	}
}

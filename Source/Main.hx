package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

class Main extends Sprite
{
	var _isInitialized:Bool;

	/* ENTRY POINT */

	function resize(e)
	{
		if (!_isInitialized)
        {
            init();
        }
		// else (resize or orientation change)
	}

	function init()
	{
		if (_isInitialized)
        {
            return;
        }

		_isInitialized = true;

		// code
	}

	/* SETUP */

	public function new()
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e)
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
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

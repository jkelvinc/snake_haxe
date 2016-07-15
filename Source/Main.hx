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

enum GameState
{
	Paused;
	GameOver;
	Playing;
}

class Main extends Sprite
{	
	private var _isInitialzed:Bool;

	private var _currentGameState:GameState;

	private var _snake:Snake;
	private var _food:Food;
	private var _scoring:Scoring;
	private var _timer:Timer;

	private var _updateList:List<IUpdatable> = new List<IUpdatable>();
	private var _inputProcessor:IInputProcessorAdapter;


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

	private function onResize(e)
	{
		if (!_isInitialzed)
		{
			init();
		}
		// else (resize or orientation change)
	}

	private function init()
	{
		if (_isInitialzed)
		{
			return;
		}
		_isInitialzed = true;
		_updateList.clear();

		stage.addEventListener(Event.ENTER_FRAME, onUpdate);

		_inputProcessor = new KeyboardInputProcessor();

		_scoring = new Scoring();
		this.addChild(_scoring);

		createNewGame();
		setGameState(GameState.Playing);
	}

	private function setGameState(gameState:GameState)
	{
		_currentGameState = gameState;
		switch (_currentGameState)
		{
			case GameState.Paused:
			{

			}

			case GameState.GameOver:
			{
				resetGame();
			}

			case GameState.Playing:
			{

			}
		}
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
		init();
	}

	private function onSnakeDied()
	{
		setGameState(GameState.GameOver);
	}

	private function resetGame()
	{
		// stop all input
		if (_inputProcessor != null)
		{
			_inputProcessor.disable();
		}

		// clear update list
		_updateList.clear();

		// stop update
		stage.removeEventListener(Event.ENTER_FRAME, onUpdate);

		// remove snake
		this.removeChild(_snake);

		// generate food
		this.removeChild(_food);

		// start new game
		createNewGame();	
	}

	private function createNewGame()
	{
		// reset score

		// create new game elements
		_snake = new Snake(Constants.MIN_SNAKE_SECTIONS_COUNT);
        this.addChild(_snake);

		_food = new Food(0xFF0000, _snake.Model);
		this.addChild(_food);

		_snake.Food = _food;
		_snake.SnakeDiedSignal.add(onSnakeDied);
		
		_updateList.add(_snake);

		// accept input
		if (_inputProcessor != null)
		{
			_inputProcessor.enable();
		}

		// start update
		stage.addEventListener(Event.ENTER_FRAME, onUpdate);
	}
}

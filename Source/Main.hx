package;

import api.IUpdatable;
import api.IInputProcessorAdapter;
import api.IDisposable;

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
	private var _disposableList:List<IDisposable> = new List<IDisposable>();
	private var _inputProcessor:IInputProcessorAdapter;


	public function new()
	{
		super();

		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		Signals.foodConsumedSignal.add(onFoodConsumed);
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

	private function onFoodConsumed()
	{
		if (_food != null)
		{
			this.removeChild(_food);
		}

		generateFood();
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

		// dispose objects and clear list
		for (obj in _disposableList)
		{
			obj.dispose();
		}
		_disposableList.clear();

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
		Signals.resetScoreSignal.dispatch();
		
		// create new game elements
		_snake = new Snake(Constants.MIN_SNAKE_SECTIONS_COUNT);
        this.addChild(_snake);

		generateFood();

		_snake.foodModel = _food.model;
		_snake.snakeDiedSignal.add(onSnakeDied);
		
		_updateList.add(_snake);

		_disposableList.add(_snake);
		_disposableList.add(_food);

		// accept input
		if (_inputProcessor != null)
		{
			_inputProcessor.enable();
		}

		// start update
		stage.addEventListener(Event.ENTER_FRAME, onUpdate);
	}

	private function generateFood()
	{
		_food = new Food(0xFF0000, _snake.model);
		this.addChild(_food);

		if (_snake != null)
		{
			_snake.updateFood(_food.model);
		}
	}
}

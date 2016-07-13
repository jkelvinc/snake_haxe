package;

import api.IUpdatable;
import msignal.Signal;

import openfl.display.Sprite;
import openfl.utils.Timer;
import openfl.events.TimerEvent;
import openfl.Lib;

class Snake extends Sprite implements IUpdatable
{
    public var Model(get, null):SnakeModel;

    public var SnakeDiedSignal(default, null):Signal0;
    public var InputProcessedSignal(default, null):Signal0;

    // look into minject to inject that later
    public var Food(default, default):Food;
    private var _model:SnakeModel;
    private var _inputData:InputData;
    private var _inputProcessor:InputProcessor;

    public function new(length:Int)
    {
        super();
        init(length);
    }

    public function init(length:Int):Void
    {
        SnakeDiedSignal = new Signal0();
        InputProcessedSignal = new Signal0();

        _model = new SnakeModel();
        _model.Colour = 0x00AAFF;
        
        createSections(length);
    }

    public function update():Void
    {
        move();
    }

    public function setInputProcessor(inputProcessor:InputProcessor)
    {
        _inputProcessor = inputProcessor;
    }

    public function processInput(data:InputData)
    {
        if (data == null)
        {
            return;
        }

trace("Process snake input");
        _inputData = data;
    }

    private function move():Void
    {
        // detect collision between food and snake
        var head = _model.getHead();
        if (head == null)
        {
            return;
        }

        if (Food != null && head.x == Food.x && head.y == Food.y)
        {
            collectFood();
        }
        
        // detect out of bounds
        if (head.x > Lib.current.stage.stageWidth - head.width || 
            head.x < 0 || 
            head.y > Lib.current.stage.stageHeight - head.height || 
            head.y < 0)
        {
            killSnake();
        }
        
        var snakeSection:SnakeSection = null;
        for (i in 0..._model.SectionsCount)
        {  
            snakeSection = _model.getSectionByIndex(i);
            if (snakeSection == null)
            {
                break;
            }

            // set direction of the sections
            if (_inputData != null)
            {
                trace("snake section x " + snakeSection.x + "| turn X: " + _inputData.TurnPositionX + ", section y: " + snakeSection.y + "| turn Y: " + _inputData.TurnPositionY);

                if (snakeSection.x == _inputData.TurnPositionX && snakeSection.y == _inputData.TurnPositionY)
                {
                    snakeSection.Direction = _inputData.Direction;
                }
            }

            if (_model.getSectionByIndex(i) != head && 
                (head.x == snakeSection.x && head.y == snakeSection.y))
            {
                // if head is the same as any section, this means we collided with ourself
                killSnake();
            }

            // update snake sections    
            var direction:String = _model.getSectionByIndex(i).Direction;
            switch (direction)
            {
                case Constants.DIRECTION_RIGHT:
                {
                    snakeSection.x += Constants.GRID_ELEMENT_WIDTH + Constants.GRID_ELEMENT_SPACING;
                }

                case Constants.DIRECTION_LEFT:
                {
                    snakeSection.x -= Constants.GRID_ELEMENT_WIDTH + Constants.GRID_ELEMENT_SPACING;
                }

                case Constants.DIRECTION_DOWN:
                {
                    snakeSection.y += Constants.GRID_ELEMENT_HEIGHT + Constants.GRID_ELEMENT_SPACING;
                }

                case Constants.DIRECTION_UP:
                {
                    snakeSection.y -= Constants.GRID_ELEMENT_HEIGHT + Constants.GRID_ELEMENT_SPACING;
                }
            }
        }

        // consumeInputData();
    }

    private function consumeInputData()
    {
        if (_inputData == null)
        {
            return;
        }

trace("consume input data");
        // check to see if all sections have turned before consuming the data
        var turnCount:Int = 0;
        for (i in 0..._model.SectionsCount)
        { 
            if (_model.getSectionByIndex(i) == null)
            {
                break;
            }

            if (_model.getSectionByIndex(i).Direction == _inputData.Direction)
            {
                ++turnCount;
            }
        }

        if (turnCount == _model.SectionsCount)
        {
            trace("consume input data 2");
             _inputData = null;
            InputProcessedSignal.dispatch();            
        }
    }

    private function killSnake()
    {
        SnakeDiedSignal.dispatch();
    }

    private function collectFood()
    {

    }

    private function get_Model():SnakeModel
    {
        return _model;
    }

    /**
    * Ideally direction should be an enum but for some reason the compiler can't seem to access the enum declared
    * in another file    
    **/
    private function attachSection(section:SnakeSection, lastSectionXPos:Float, lastSectionYPos:Float, direction:String)
    {
        switch (direction)
        {
            case Constants.DIRECTION_RIGHT:
            {
                section.x = lastSectionXPos - Constants.GRID_ELEMENT_WIDTH - Constants.GRID_ELEMENT_SPACING;
                section.y = lastSectionYPos;
            }

            case Constants.DIRECTION_LEFT:
            {
                section.x = lastSectionXPos + Constants.GRID_ELEMENT_WIDTH + Constants.GRID_ELEMENT_SPACING;
                section.y = lastSectionYPos;
            }

            case Constants.DIRECTION_UP:
            {
                section.x = lastSectionXPos;
                section.y = lastSectionYPos + Constants.GRID_ELEMENT_WIDTH + Constants.GRID_ELEMENT_SPACING;
            }

            case Constants.DIRECTION_DOWN:
            {
                section.x = lastSectionXPos;
                section.y = lastSectionYPos - Constants.GRID_ELEMENT_WIDTH - Constants.GRID_ELEMENT_SPACING;
            }
        }

        this.addChild(section);
    }

    private function createSections(length:Int):Void
    {
        for (i in 0...length)
        {   
            var s = new SnakeSection(_model.Colour, Constants.GRID_ELEMENT_WIDTH, Constants.GRID_ELEMENT_HEIGHT);
            s.Direction = "Right";
            _model.addSection(s, i);
            if (i == 0)
            {
                // head
                s.alpha = 0.6;
                attachSection(s, 
                            (s.width + Constants.GRID_ELEMENT_SPACING) * Constants.SNAKE_STARTING_XPOS, 
                            (s.height + Constants.GRID_ELEMENT_SPACING) * Constants.SNAKE_STARTING_YPOS, 
                            s.Direction);
            }
            else
            {
                // rest of body
                var previousSection = _model.getSectionByIndex(i - 1);

                attachSection(s, previousSection.x, previousSection.y, previousSection.Direction);
            }
        }
    }
}

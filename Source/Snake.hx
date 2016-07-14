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

        _inputData = data;
    }

    private function move():Void
    { 
        var previousSectionPosition = { x:0.0, y:0.0 };
        var tempSectionPosition = { x:0.0, y:0.0 };

        for (i in 0..._model.SectionsCount)
        {
            var section = _model.getSectionByIndex(i);
            if (section == null)
            {
                break;
            }

            if (i == 0)
            {
                // process head

                // process input
                if (_inputData != null)
                {
                    section.Direction = _inputData.Direction;
                }

                previousSectionPosition.x = section.x;
                previousSectionPosition.y = section.y;

                // move head
                switch (section.Direction)
                {
                    case Constants.DIRECTION_RIGHT:
                    {
                        section.x += Constants.GRID_ELEMENT_WIDTH + Constants.GRID_ELEMENT_SPACING;
                    }

                    case Constants.DIRECTION_LEFT:
                    {
                        section.x -= Constants.GRID_ELEMENT_WIDTH + Constants.GRID_ELEMENT_SPACING;
                    }

                    case Constants.DIRECTION_DOWN:
                    {
                        section.y += Constants.GRID_ELEMENT_HEIGHT + Constants.GRID_ELEMENT_SPACING;
                    }

                    case Constants.DIRECTION_UP:
                    {
                        section.y -= Constants.GRID_ELEMENT_HEIGHT + Constants.GRID_ELEMENT_SPACING;
                    }
                }

                // detect collision with food
                if (Food != null && section.x == Food.x && section.y == Food.y)
                {
                    collectFood();
                }
                
                // detect collision with game borders
                if (section.x > Lib.current.stage.stageWidth - section.width || 
                    section.x < 0 || 
                    section.y > Lib.current.stage.stageHeight - section.height || 
                    section.y < 0)
                {
                    die();
                }

                //Detect collission with body
                for (j in 1..._model.SectionsCount)
                {
                    var bodySection = _model.getSectionByIndex(j);
                    if (bodySection == null)
                    {
                        break;
                    }

                    if (section.x == bodySection.x && section.y == bodySection.y)
                    {
                        die();
                    }
                }
            }
            else
            {
                // process body

                tempSectionPosition.x = previousSectionPosition.x;
                tempSectionPosition.y = previousSectionPosition.y;

                previousSectionPosition.x = section.x;
                previousSectionPosition.y = section.y;

                // move body
                section.x = tempSectionPosition.x;
                section.y = tempSectionPosition.y;
            }
        }

        consumeInputData();
    }

    private function consumeInputData()
    {
        if (_inputData == null)
        {
            return;
        }

        _inputData = null;
        InputProcessedSignal.dispatch();
    }

    private function die()
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

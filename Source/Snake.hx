package;

import api.IUpdatable;
import api.IDisposable;
import api.IFoodModel;

import msignal.Signal;

import openfl.display.Sprite;
import openfl.utils.Timer;
import openfl.events.TimerEvent;
import openfl.Lib;

class Snake extends Sprite implements IUpdatable implements IDisposable
{
    public var model(get, null):SnakeModel;
    public var snakeDiedSignal(default, null):Signal0;
    
    // look into minject to inject that later
    public var foodModel(default, default):IFoodModel;
    private var _model:SnakeModel;
    private var _inputData:InputData;
    

    public function new(length:Int)
    {
        super();
        
        snakeDiedSignal = new Signal0();
        Signals.inputChangedSignal.add(processInput);

        _model = new SnakeModel();
        _model.colour = 0x00AAFF;
        
        createSections(length);
    }

    public function dispose()
    {
        Signals.inputChangedSignal.remove(processInput);
    }

    public function update():Void
    {
        move();
    }

    public function updateFood(foodModel:IFoodModel)
    {
        this.foodModel = foodModel;
    }


    private function processInput(data:InputData)
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

        for (i in 0..._model.length)
        {
            var section = _model.getSectionByIndex(i);

            // process input
            if (_inputData != null)
            {
                var isNewDirectionValid = validateInput(section.direction);
                if (isNewDirectionValid)
                {
                    section.direction = _inputData.direction;
                }
            }

            if (i == 0)
            {
                // process head

                previousSectionPosition.x = section.x;
                previousSectionPosition.y = section.y;

                // move head
                switch (section.direction)
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
                if (foodModel != null && section.x == foodModel.positionX && section.y == foodModel.positionY)
                {
                    collectFood();
                }
                
                // detect collision with game borders
                if (section.x > Lib.current.stage.stageWidth - section.width || 
                    section.x < 0 || 
                    section.y > Lib.current.stage.stageHeight - section.height || 
                    section.y < 0)
                {
                    // trace("collision with border");
                    die();
                }

                // detect collission with body
                for (j in 1..._model.length)
                {
                    var bodySection = _model.getSectionByIndex(j);

                    if (section.x == bodySection.x && section.y == bodySection.y)
                    {
                        // trace("collision with body - head x: " + section.x + ", head y: " + section.y + " | body x: " + bodySection.x + ", body y: " + bodySection.y);
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

    private function validateInput(currentDirection:String):Bool
    {
        if (_inputData == null)
        {
            return false;
        }

        switch (_inputData.direction)
        {
            case Constants.DIRECTION_LEFT:
            {
                return (currentDirection != Constants.DIRECTION_RIGHT);
            }

            case Constants.DIRECTION_RIGHT:
            {
                return (currentDirection != Constants.DIRECTION_LEFT);
            }

            case Constants.DIRECTION_UP:
            {
                return (currentDirection != Constants.DIRECTION_DOWN);
            }

            case Constants.DIRECTION_DOWN:
            {
                return (currentDirection != Constants.DIRECTION_UP);
            }
        }

        return true;
    }

    private function consumeInputData()
    {
        if (_inputData == null)
        {
            return;
        }

        _inputData = null;
        
        Signals.inputProcessedSignal.dispatch();
    }

    private function die()
    {
        snakeDiedSignal.dispatch();
    }

    private function collectFood()
    {
        trace("collectFood()");

        // attach a new section
        var snakeTail = _model.getTail();
        var s = new SnakeSection(_model.colour, Constants.GRID_ELEMENT_WIDTH, Constants.GRID_ELEMENT_HEIGHT);
        s.direction = Constants.DIRECTION_RIGHT;
        
        attachSection(s, snakeTail.x, snakeTail.y, snakeTail.direction);

        Signals.foodConsumedSignal.dispatch();
    }

    private function get_model():SnakeModel
    {
        return _model;
    }

    /**
    * Ideally direction should be an enum but for some reason the compiler can't seem to access the enum declared
    * in another file    
    **/
    private function attachSection(section:SnakeSection, lastSectionXPos:Float, lastSectionYPos:Float, direction:String)
    {
        _model.addSection(section);

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
            var s = new SnakeSection(_model.colour, Constants.GRID_ELEMENT_WIDTH, Constants.GRID_ELEMENT_HEIGHT);
            s.direction = Constants.DIRECTION_RIGHT;
            
            if (i == 0)
            {
                // head
                s.alpha = 0.6;
                attachSection(s, 
                            (s.width + Constants.GRID_ELEMENT_SPACING) * Constants.SNAKE_STARTING_XPOS, 
                            (s.height + Constants.GRID_ELEMENT_SPACING) * Constants.SNAKE_STARTING_YPOS, 
                            s.direction);
            }
            else
            {
                // rest of body
                var previousSection = _model.getSectionByIndex(i - 1);
                attachSection(s, previousSection.x, previousSection.y, previousSection.direction);
            }
        }
    }
}

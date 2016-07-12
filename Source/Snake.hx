package;

import openfl.display.Sprite;

class Snake extends Sprite
{
    public var Model(get, null):SnakeModel;
    private var _model:SnakeModel;

    public function new(length:Int)
    {
        super();
        init(length);
    }

    public function init(length:Int)
    {
        _model = new SnakeModel();
        _model.Colour = 0x00AAFF;
        
        createSections(length);
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

    private function createSections(length:Int)
    {
        for (i in 0...length)
        {   
            var s = new SnakeSection(_model.Colour, Constants.GRID_ELEMENT_WIDTH, Constants.GRID_ELEMENT_HEIGHT);
            s.Direction = "Right";
            _model.AddSection(s, i);
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
                var previousSection = _model.GetSectionByIndex(i - 1);

                attachSection(s, previousSection.x, previousSection.y, previousSection.Direction);
            }
        }
    }
}

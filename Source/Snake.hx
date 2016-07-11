package;

import openfl.display.Sprite;

class Snake extends Sprite
{
    private var _model:SnakeModel;
    private var _minSectionsCount:Int;
    private var _sectionsSpacing:Int;
    private var _snakeColour:Int;
    private var _snakeSectionWidth:Int;
    private var _snakeSectionHeight:Int;

    private var _startinglastSectionXPos:Int;
    private var _startinglastSectionYPos:Int;

    public function new(length:Int)
    {
        super();
        init(length);
    }

    public function init(length:Int)
    {
        _sectionsSpacing = 2;
        _minSectionsCount = 4;
        _snakeSectionWidth = 10;
        _snakeSectionHeight = 10;
        _snakeColour = 0x00AAFF;

        _startinglastSectionXPos = 20;
        _startinglastSectionYPos = 20;

        _model = new SnakeModel();
        createSections(length);
    }

    /**
    * Ideally direction should be an enum but for some reason the compiler can't seem to access the enum declared
    * in another file    
    **/
    private function attachSection(section:SnakeSection, lastSectionXPos:Float, lastSectionYPos:Float, direction:String)
    {
        switch (direction)
        {
            case "Right":
            {
                section.x = lastSectionXPos - _snakeSectionWidth - _sectionsSpacing;
                section.y = lastSectionYPos;

                trace("snake x: " + section.x);
                trace("snake y: " + section.y);
            }

            case "Left":
            {
                section.x = lastSectionXPos + _snakeSectionWidth + _sectionsSpacing;
                section.y = lastSectionYPos;
            }

            case "Up":
            {
                section.x = lastSectionXPos;
                section.y = lastSectionYPos + _snakeSectionHeight + _sectionsSpacing;
            }

            case "Down":
            {
                section.x = lastSectionXPos;
                section.y = lastSectionYPos - _snakeSectionHeight - _sectionsSpacing;
            }
        }

        this.addChild(section);
    }

    private function createSections(length:Int)
    {
        for (i in 0...length)
        {   
            var s = new SnakeSection(_snakeColour, _snakeSectionWidth, _snakeSectionHeight);
            s.Direction = "Right";
            _model.AddSection(s, i);
            if (i == 0)
            {
                // head
                s.alpha = 0.6;
                attachSection(s, 
                            (s.width + _sectionsSpacing) * _startinglastSectionXPos, 
                            (s.height + _sectionsSpacing) * _startinglastSectionYPos, 
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

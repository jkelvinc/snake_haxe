package;

import openfl.display.Sprite;

class Snake extends Sprite
{
    private var _model:SnakeModel;

    private var _snakeSectionWidth:Int;
    private var _snakeSectionHeight:Int;


    public function new(length:Int)
    {
        super();
        init(length);
    }

    public function init(length:Int)
    {
        _snakeSectionWidth = 10;
        _snakeSectionHeight = 10;
        
        _model = new SnakeModel();
        _model.SectionsSpacing = 2;
        _model.Colour = 0x00AAFF;

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
                section.x = lastSectionXPos - _snakeSectionWidth - _model.SectionsSpacing;
                section.y = lastSectionYPos;
            }

            case "Left":
            {
                section.x = lastSectionXPos + _snakeSectionWidth + _model.SectionsSpacing;
                section.y = lastSectionYPos;
            }

            case "Up":
            {
                section.x = lastSectionXPos;
                section.y = lastSectionYPos + _snakeSectionHeight + _model.SectionsSpacing;
            }

            case "Down":
            {
                section.x = lastSectionXPos;
                section.y = lastSectionYPos - _snakeSectionHeight - _model.SectionsSpacing;
            }
        }

        this.addChild(section);
    }

    private function createSections(length:Int)
    {
        for (i in 0...length)
        {   
            var s = new SnakeSection(_model.Colour, _snakeSectionWidth, _snakeSectionHeight);
            s.Direction = "Right";
            _model.AddSection(s, i);
            if (i == 0)
            {
                // head
                s.alpha = 0.6;
                attachSection(s, 
                            (s.width + _model.SectionsSpacing) * SnakeModel.STARTING_XPOS, 
                            (s.height + _model.SectionsSpacing) * SnakeModel.STARTING_YPOS, 
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

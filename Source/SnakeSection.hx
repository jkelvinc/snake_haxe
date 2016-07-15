package;

import openfl.display.Sprite;

class SnakeSection extends Sprite
{
    public var direction(default, default):String;
    
    public function new(colour:Int, width:Int, height:Int)
    {
        super();

        this.graphics.beginFill(colour);
        this.graphics.drawRect(0, 0, width, height);
        this.graphics.endFill();
    }
}

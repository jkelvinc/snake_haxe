package;

import openfl.display.Sprite;

class Food extends Sprite
{
    public function new(colour:Int, size:Int,)
    {
        super();
        this.graphics.beginFill(colour);
        this.graphics.drawCircle(0, 0, size);
        this.graphics.endFill();
    }}
}

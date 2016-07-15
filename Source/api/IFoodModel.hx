package api;

interface IFoodModel
{
    public var colour(default, null):Int;
    public var positionX(default, null):Int;
    public var positionY(default, null):Int;
    public var width(default, null):Int;
    public var height(default, null):Int;
    public var snakeModel(default, null):SnakeModel;
    
    public function generateFoodPosition():Void;
}
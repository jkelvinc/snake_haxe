package;

import api.IFoodModel;
import api.IDisposable;

import openfl.display.Sprite;

class Food extends Sprite implements IDisposable
{
    public var model(get, null):IFoodModel;
    private var _model:IFoodModel;

    public function new(colour:Int, snakeModel:SnakeModel)
    {
        super();
        
        Signals.generateFoodSignal.add(onGenerateFood);

        _model = new FoodModel(colour, snakeModel, Constants.GRID_ELEMENT_WIDTH, Constants.GRID_ELEMENT_HEIGHT);
        
        onGenerateFood();
    }

    public function dispose()
    {
        Signals.generateFoodSignal.remove(onGenerateFood);
    }

    private function onGenerateFood()
    {
        generateFoodPosition();
        render();
    }

    private function generateFoodPosition()
    {
        _model.generateFoodPosition();
    }

    private function render()
    {
        this.graphics.beginFill(_model.colour);
        this.graphics.drawRect(_model.positionX, _model.positionY, _model.width, _model.height);
        this.graphics.endFill();
    }

    private function get_model()
    {
        return _model;
    }
}

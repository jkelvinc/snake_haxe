package;

import openfl.display.Sprite;

class Food extends Sprite
{
    private var _model:FoodModel;

    public function new(colour:Int, snakeModel:SnakeModel)
    {
        super();
        
        this.graphics.beginFill(colour);
        this.graphics.drawRect(0, 0, Constants.GRID_ELEMENT_WIDTH, Constants.GRID_ELEMENT_HEIGHT);
        this.graphics.endFill();

        _model = new FoodModel();
        _model.Colour = colour;
        _model.SnakeModel = snakeModel;

        this.width = Constants.GRID_ELEMENT_WIDTH;
        this.height = Constants.GRID_ELEMENT_HEIGHT;

        init();
    }

    private function init()
    {
        generatePosition();
    }

    private function generatePosition()
    {
        var stage = openfl.Lib.current.stage;

        var snakeSectionAndSpacingWidth = Constants.GRID_ELEMENT_WIDTH + Constants.GRID_ELEMENT_SPACING;

        var boundsX:Int = (Math.floor(stage.stageWidth / snakeSectionAndSpacingWidth)) - 1;
        var randomX:Int = Math.floor(Math.random() * boundsX);
            
        var snakeSectionAndSpacingHeight = Constants.GRID_ELEMENT_HEIGHT + Constants.GRID_ELEMENT_SPACING;

        var boundsY:Int = (Math.floor(stage.stageHeight / snakeSectionAndSpacingHeight)) - 1;
        var randomY:Int = Math.floor(Math.random() * boundsY);
    
        this.x = randomX * (this.width + Constants.GRID_ELEMENT_SPACING);
        this.y = randomY * (this.height + Constants.GRID_ELEMENT_SPACING);
        
        // check if food is on part of the snake
        if (_model.SnakeModel != null)
        {   
            for (i in 0..._model.SnakeModel.SectionsCount)
            {
                var snakeSection = _model.SnakeModel.GetSectionByIndex(i);
                // ugly for now because of stupid vector
                if (snakeSection != null && snakeSection.x == this.x && snakeSection.y == this.y)
                {
                    generatePosition();
                }
            }
        }
    }
}

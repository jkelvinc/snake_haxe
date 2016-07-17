package;

import api.IFoodModel;

class FoodModel implements IFoodModel
{
    public var colour(default, null):Int;
    public var positionX(default, null):Int;
    public var positionY(default, null):Int;
    public var width(default, null):Int;
    public var height(default, null):Int;
    public var snakeModel(default, null):SnakeModel;
    
    public function new(colour:Int, snakeModel:SnakeModel, width:Int, height:Int)
    {
        this.colour = colour;
        this.snakeModel = snakeModel;
        this.width = width;
        this.height = height;
    }

    public function generateFoodPosition()
    {
        var stage = openfl.Lib.current.stage;

        var snakeSectionAndSpacingWidth = Constants.GRID_ELEMENT_WIDTH + Constants.GRID_ELEMENT_SPACING;

        var boundsX:Int = (Math.floor(stage.stageWidth / snakeSectionAndSpacingWidth)) - 1;
        var randomX:Int = Math.floor(Math.random() * boundsX);
            
        var snakeSectionAndSpacingHeight = Constants.GRID_ELEMENT_HEIGHT + Constants.GRID_ELEMENT_SPACING;

        var boundsY:Int = (Math.floor(stage.stageHeight / snakeSectionAndSpacingHeight)) - 1;
        var randomY:Int = Math.floor(Math.random() * boundsY);
    
        this.positionX = randomX * (this.width + Constants.GRID_ELEMENT_SPACING);
        this.positionY = randomY * (this.height + Constants.GRID_ELEMENT_SPACING);
        
        // check if food is on part of the snake
        if (this.snakeModel != null)
        {   
            for (i in 0...this.snakeModel.length)
            {
                var snakeSection = this.snakeModel.getSectionByIndex(i);
                // ugly for now because of stupid vector
                if (snakeSection != null && snakeSection.x == this.positionX && snakeSection.y == this.positionY)
                {
                    generateFoodPosition();
                }
            }
        }
    }
}
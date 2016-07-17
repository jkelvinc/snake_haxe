package;

class SnakeModel
{
    public var colour(default, default):Int;
    public var length(get, null):Int;

    private var _sections:Array<SnakeSection>;

    public function new()
    {
        _sections = new Array<SnakeSection>();
    }

    public function getSectionByIndex(index:Int):SnakeSection
    {
        return _sections[index];
    }

    public function addSection(section:SnakeSection)
    {
        _sections.push(section);
    }

    public function getHead():SnakeSection
    {
        return _sections[0];
    }

    public function getTail():SnakeSection
    {
        return _sections[length - 1];
    }

    private function get_length():Int
    {
        return _sections.length;
    }
}

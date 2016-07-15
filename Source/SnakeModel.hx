package;

class SnakeModel
{
    public var colour(default, default):Int;
    public var sectionsCount(get, null):Int;

    private var _sections:haxe.ds.Vector<SnakeSection>;

    public function new()
    {
        // find another data structure
        // arbitrary value
        // ideally should have used List but Haxe List is weird and
        // functions move like a Queue/Stack?
        _sections = new haxe.ds.Vector<SnakeSection>(200);
    }

    public function getSectionByIndex(index:Int):SnakeSection
    {
        return _sections[index];
    }

    public function addSection(section:SnakeSection, index:Int)
    {
        if (index < _sections.length)
        {
            _sections[index] = section;
        }
    }

    public function getHead():SnakeSection
    {
        return _sections[0];
    }

    private function get_sectionsCount():Int
    {
        return _sections.length;
    }
}

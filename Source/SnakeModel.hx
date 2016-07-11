package;

class SnakeModel
{
    public var IsAlive(default, null):Bool;
    
    private var _sections:haxe.ds.Vector<SnakeSection>;

    public function new()
    {
        IsAlive = true;

        // arbitrary value
        // ideally should have used List but Haxe List is weird and
        // functions move like a Queue/Stack?
        _sections = new haxe.ds.Vector<SnakeSection>(200);
    }

    public function GetSectionByIndex(index:Int) : SnakeSection
    {
        return _sections[index];
    }

    public function AddSection(section:SnakeSection, index:Int)
    {
        if (index < _sections.length)
        {
            _sections[index] = section;
        }
    }
}

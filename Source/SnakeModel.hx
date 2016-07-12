package;

class SnakeModel
{
    public static inline var MIN_SECTIONS_COUNT = 4;
    public static inline var STARTING_XPOS = 20;
    public static inline var STARTING_YPOS  = 20;

    public var IsAlive(default, null):Bool;
    public var SectionsSpacing(default, default):Int;
    public var Colour(default, default):Int;
        
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

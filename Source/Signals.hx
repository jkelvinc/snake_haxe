package;

import msignal.Signal;

class Signals
{
    public static var FoodConsumedSignal(default, null):Signal0 = new Signal0();

    public static var InputChangedSignal(default, null):Signal1<InputData>= new Signal1<InputData>();
    public static var InputProcessedSignal(default, null):Signal0 = new Signal0();
}
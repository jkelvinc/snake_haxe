package;

import msignal.Signal;

class Signals
{
    public static var resetScoreSignal(default, null):Signal0 = new Signal0();
    public static var foodConsumedSignal(default, null):Signal0 = new Signal0();

    public static var inputChangedSignal(default, null):Signal1<InputData>= new Signal1<InputData>();
    public static var inputProcessedSignal(default, null):Signal0 = new Signal0();

    public static var generateFoodSignal(default, null):Signal0 = new Signal0();
}
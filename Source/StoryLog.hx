 

import engine.Scene;

 class StoryLog {

	public static var timeOfDay:String;
	public static var hasBook:Bool = false;

	public static var hasSymbol1:Bool = false;
	public static var hasSymbol2:Bool = false;
	public static var hasSymbol3:Bool = false;
	public static var hasSymbol4:Bool = false;
	public static var hasSymbol5:Bool = false;

	public static function reset() {
		timeOfDay = "day";
		hasBook = false;

		hasSymbol1 = false;
		hasSymbol2 = false;
		hasSymbol3 = false;
		hasSymbol4 = false;
		hasSymbol5 = false;
	}

	public static function hasAllSymbols():Bool {
		return hasSymbol1 && hasSymbol2 && hasSymbol3 && hasSymbol4 && hasSymbol5;
	}

	public static function checkIfAllSymbols(scene:Scene) {
		if (hasAllSymbols()) {
			Game.playMusic("will_my_soul");
		}
	}
}


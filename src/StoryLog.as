package {
	import engine.Scene;

	public class StoryLog {

		public static var timeOfDay:String;
		public static var hasBook:Boolean;

		public static var hasSymbol1:Boolean;
		public static var hasSymbol2:Boolean;
		public static var hasSymbol3:Boolean;
		public static var hasSymbol4:Boolean;
		public static var hasSymbol5:Boolean;

		public static function reset():void {
			timeOfDay = "day";
			hasBook = false;

			hasSymbol1 = false;
			hasSymbol2 = false;
			hasSymbol3 = false;
			hasSymbol4 = false;
			hasSymbol5 = false;
		}

		public static function hasAllSymbols():Boolean {
			return hasSymbol1 && hasSymbol2 && hasSymbol3 && hasSymbol4 && hasSymbol5;
		}

		public static function checkIfAllSymbols(scene:Scene):void {
			if(hasAllSymbols()) {
				Game.playMusic("will_my_soul");
			}
		}
	}
}

package engine {
	import org.flixel.FlxG;

	public class SFX {

		[Embed(source="../../assets/sfx/key.mp3")]
		public static var SFX_CLICK:Class;
		[Embed(source="../../assets/sfx/move.mp3")]
		public static var SFX_USE:Class;
		[Embed(source="../../assets/sfx/select1.mp3")]
		public static var SFX_PICK:Class;
		[Embed(source="../../assets/sfx/select2.mp3")]
		public static var SFX_BELL:Class;
		[Embed(source="../../assets/sfx/scrolling.mp3")]
		public static var SFX_SCROLL:Class;
		[Embed(source="../../assets/sfx/taunt.mp3")]
		public static var SFX_TAUNT:Class;

		public static function play(name:String):void {
			var sound:Class = SFX["SFX_"+name.toUpperCase()];

			if(!sound || !(sound is Class)) {
				trace("Invalid SFX! ", name, sound);
				return;
			}

			trace("SFX: ", sound);
			FlxG.play( sound, 0.5 );
		}

	}
}

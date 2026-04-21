package engine ;

import org.flixel.FlxG;

 class SFX {

	public static var SFX_CLICK:String = "assets/sfx/key.mp3";
	public static var SFX_USE:String = "assets/sfx/move.mp3";
	public static var SFX_PICK:String = "assets/sfx/select1.mp3";
	public static var SFX_BELL:String = "assets/sfx/select2.mp3";
	public static var SFX_SCROLL:String = "assets/sfx/scrolling.mp3";
	public static var SFX_TAUNT:String = "assets/sfx/taunt.mp3";

	public static function play(name:String) {
		var sound:String = (SFX : ASAny)["SFX_" + name.toUpperCase()];

		if (sound == null) {
			trace("Invalid SFX! ", name, sound);
			return;
		}

		trace("SFX: ", sound);
		FlxG.play(sound, 0.5);
	}

}


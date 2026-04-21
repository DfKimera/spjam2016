package engine ;

import org.flixel.FlxG;

 class SFX {

	@:meta(Embed(source="../../assets/sfx/key.mp3"))
	public static var SFX_CLICK:Class<Dynamic>;
	@:meta(Embed(source="../../assets/sfx/move.mp3"))
	public static var SFX_USE:Class<Dynamic>;
	@:meta(Embed(source="../../assets/sfx/select1.mp3"))
	public static var SFX_PICK:Class<Dynamic>;
	@:meta(Embed(source="../../assets/sfx/select2.mp3"))
	public static var SFX_BELL:Class<Dynamic>;
	@:meta(Embed(source="../../assets/sfx/scrolling.mp3"))
	public static var SFX_SCROLL:Class<Dynamic>;
	@:meta(Embed(source="../../assets/sfx/taunt.mp3"))
	public static var SFX_TAUNT:Class<Dynamic>;

	public static function play(name:String) {
		var sound:Class<Dynamic> = (SFX : ASAny)["SFX_" + name.toUpperCase()];

		if (sound == null || !Std.is(sound , Class)) {
			trace("Invalid SFX! ", name, sound);
			return;
		}

		trace("SFX: ", sound);
		FlxG.play(sound, 0.5);
	}

}


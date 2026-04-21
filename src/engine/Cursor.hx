package engine ;

import org.flixel.FlxG;

 class Cursor {

	@:meta(Embed(source="../../assets/cursor_skip.png"))
	public static var SPRITE_SKIP:Class<Dynamic>;

	@:meta(Embed(source="../../assets/cursor_arrow_bk.png"))
	public static var SPRITE_ARROW:Class<Dynamic>;

	@:meta(Embed(source="../../assets/cursor_hand_bk.png"))
	public static var SPRITE_HAND:Class<Dynamic>;

	@:meta(Embed(source="../../assets/cursor_eye_bk.png"))
	public static var SPRITE_EYE:Class<Dynamic>;

	@:meta(Embed(source="../../assets/cursor_door_bk.png"))
	public static var SPRITE_DOOR:Class<Dynamic>;

	public static var isVisible:Bool = true;

	public static var shouldUseSkip:Bool = false;
	public static var shouldUseHand:Bool = false;
	public static var shouldUseDoor:Bool = false;
	public static var shouldUseEye:Bool = false;

	public static function useArrow() {
		shouldUseSkip = false;
		shouldUseHand = false;
		shouldUseDoor = false;
		shouldUseEye = false;
	}

	public static function useSkip() {
		shouldUseSkip = true;
	}

	public static function useHand() {
		shouldUseHand = true;
	}

	public static function useDoor() {
		shouldUseDoor = true;
	}

	public static function useEye() {
		shouldUseEye = true;
	}

	public static function hide() {
		Cursor.isVisible = false;
	}

	public static function show() {
		Cursor.isVisible = true;
	}

	public static function reset() {
		Cursor.useArrow();
	}

	public static function update() {

		if (Cursor.isVisible) {
			if (shouldUseSkip) {
				FlxG.mouse.show(SPRITE_SKIP);
			} else if (shouldUseHand && !Inventory.isMouseOver()) {
				FlxG.mouse.show(SPRITE_HAND);
			} else if (shouldUseDoor && !Inventory.isMouseOver()) {
				FlxG.mouse.show(SPRITE_DOOR);
			} else if (shouldUseEye && !Inventory.isMouseOver()) {
				FlxG.mouse.show(SPRITE_EYE);
			} else {
				FlxG.mouse.show(SPRITE_ARROW);
			}
		} else {
			FlxG.mouse.hide();
		}

	}

}


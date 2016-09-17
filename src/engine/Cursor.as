package engine {
	import org.flixel.FlxG;

	public class Cursor {

		[Embed(source="../../assets/cursor_skip.png")]
		public static var SPRITE_SKIP:Class;

		[Embed(source="../../assets/cursor_arrow_bk.png")]
		public static var SPRITE_ARROW:Class;

		[Embed(source="../../assets/cursor_hand_bk.png")]
		public static var SPRITE_HAND:Class;

		[Embed(source="../../assets/cursor_eye_bk.png")]
		public static var SPRITE_EYE:Class;

		[Embed(source="../../assets/cursor_door_bk.png")]
		public static var SPRITE_DOOR:Class;

		public static var isVisible:Boolean = true;

		public static var shouldUseSkip:Boolean = false;
		public static var shouldUseHand:Boolean = false;
		public static var shouldUseDoor:Boolean = false;
		public static var shouldUseEye:Boolean = false;

		public static function useArrow():void {
			shouldUseSkip = false;
			shouldUseHand = false;
			shouldUseDoor = false;
			shouldUseEye = false;
		}

		public static function useSkip():void {
			shouldUseSkip = true;
		}

		public static function useHand():void {
			shouldUseHand = true;
		}

		public static function useDoor():void {
			shouldUseDoor = true;
		}

		public static function useEye():void {
			shouldUseEye = true;
		}

		public static function hide():void {
			Cursor.isVisible = false;
		}

		public static function show():void {
			Cursor.isVisible = true;
		}

		public static function reset():void {
			Cursor.useArrow();
		}

		public static function update():void {

			if(Cursor.isVisible) {
				if(shouldUseSkip) {
					FlxG.mouse.show(SPRITE_SKIP);
				} else if(shouldUseHand && !Inventory.isMouseOver()) {
					FlxG.mouse.show(SPRITE_HAND);
				} else if(shouldUseDoor && !Inventory.isMouseOver()) {
					FlxG.mouse.show(SPRITE_DOOR);
				} else if(shouldUseEye && !Inventory.isMouseOver()) {
					FlxG.mouse.show(SPRITE_EYE);
				} else {
					FlxG.mouse.show(SPRITE_ARROW);
				}
			} else {
				FlxG.mouse.hide();
			}

		}

	}
}

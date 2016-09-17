package engine {
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;

	public class Character extends Prop {

		public var characterName:String = "Unknown";
		public var textColor:uint = 0xFFFFFF;

		private var portraits:Array = [];
		private var portraitSprites:Array = [];

		public function Character():void {
			setCharacterInfo();
		}

		public function setCharacterInfo():void {

		}

		/**
		 * Sets the list of portrait expressions for this character.
		 * @param portraitList Expected format:
		 * {<expression_name>: [<bitmap_class>, <is_animated>]}
		 */
		public function setPortraits(portraitList:Object):void {
			for(var i:String in portraitList) {
				addPortrait(i, portraitList[i][0], Boolean(portraitList[i][1]));
			}
		}

		/**
		 * Adds a portrait to the list of portrait expressions.
		 * @param expression String The portrait expression.
		 * @param graphic Class The bitmap graphic class.
		 * @param isAnimated Boolean Is the portrait animated?
		 */
		public function addPortrait(expression:String, graphic:Class, isAnimated:Boolean = false):void {
			portraits[expression] = graphic;
			portraitSprites[expression] = new FlxSprite(0,0);
			portraitSprites[expression].loadGraphic(graphic, isAnimated, false);
		}

		/**
		 * Gets the portrait sprite for a certain expression
		 * @param expression String The expression.
		 * @return FlxSprite The portrait sprite.
		 */
		public function getPortrait(expression:String):FlxSprite {
			return portraitSprites[expression];
		}

		public function playSound(soundName:String):FlxSound {
			var sound:Class = this["SOUND_" + soundName.toUpperCase()];
			trace("Voice: ", sound);
			return FlxG.play(sound, 0.5);
		}

	}
}

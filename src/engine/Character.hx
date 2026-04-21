package engine ;

import org.flixel.FlxG;
import org.flixel.FlxSound;
import org.flixel.FlxSprite;

 class Character extends Prop {

	public var characterName:String = "Unknown";
	public var textColor:UInt = 0xFFFFFF;

	var portraits:ASAny = {};
	var portraitSprites:ASAny = {};

	public function new(){
		super();
		setCharacterInfo();
	}

	public function setCharacterInfo() {

	}

	/**
	 * Sets the list of portrait expressions for this character.
	 * @param portraitList Expected format:
	 * {<expression_name>: [<bitmap_class>, <is_animated>]}
	 */
	public function setPortraits(portraitList:ASAny) {
		for (i in Reflect.fields(portraitList)) {
			addPortrait(i, portraitList[i][0], ASCompat.toBool(portraitList[i][1]));
		}
	}

	/**
	 * Adds a portrait to the list of portrait expressions.
	 * @param expression String The portrait expression.
	 * @param graphic Class The bitmap graphic class.
	 * @param isAnimated Boolean Is the portrait animated?
	 */
	public function addPortrait(expression:String, graphic:Class<Dynamic>, isAnimated:Bool = false) {
		portraits[expression] = graphic;
		portraitSprites[expression] = new FlxSprite(0, 0);
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
		var sound:Class<Dynamic> = (this : ASAny)["SOUND_" + soundName.toUpperCase()];
		trace("Voice: ", sound);
		return FlxG.play(sound, 0.5);
	}

}


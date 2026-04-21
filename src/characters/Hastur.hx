package characters ;

import engine.Character;

 class Hastur extends Character {

	@:meta(Embed(source="../../assets/portrait_testcharacter.jpg"))
	public static var PORTRAIT_DEFAULT:Class<Dynamic>;

	override public function setCharacterInfo() {
		this.characterName = "Hastur";
		this.textColor = 0xFF0000;
		this.setPortraits({
			'default': ([PORTRAIT_DEFAULT, (false : Dynamic)] : Array<Dynamic>)
		});
	}
}


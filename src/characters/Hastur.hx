package characters ;

import engine.Character;

 class Hastur extends Character {

	public static var PORTRAIT_DEFAULT:String = "assets/portrait_testcharacter.jpg";

	override public function setCharacterInfo() {
		this.characterName = "Hastur";
		this.textColor = 0xFF0000;
		this.setPortraits({
			'default': ([PORTRAIT_DEFAULT, (false : Dynamic)] : Array<Dynamic>)
		});
	}
}


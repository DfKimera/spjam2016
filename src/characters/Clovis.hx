package characters ;

import engine.Character;

 class Clovis extends Character {

	public static var PORTRAIT_DEFAULT:String = "assets/portrait_testcharacter.jpg";

	override public function setCharacterInfo() {
		this.characterName = "Clóvis";
		this.textColor = 0x00FFFF;
		this.setPortraits({
			'default': ([PORTRAIT_DEFAULT, (false : Dynamic)] : Array<Dynamic>)
		});
	}
}


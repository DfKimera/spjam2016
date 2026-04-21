package characters ;

import engine.Character;

 class Clovis extends Character {

	@:meta(Embed(source="../../assets/portrait_testcharacter.jpg"))
	public static var PORTRAIT_DEFAULT:Class<Dynamic>;

	override public function setCharacterInfo() {
		this.characterName = "Clóvis";
		this.textColor = 0x00FFFF;
		this.setPortraits({
			'default': [PORTRAIT_DEFAULT, false]
		});
	}
}


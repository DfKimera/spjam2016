package characters {
	import engine.Character;

	public class Hastur extends Character {

		[Embed(source="../../assets/portrait_testcharacter.jpg")]
		public static var PORTRAIT_DEFAULT:Class;

		override public function setCharacterInfo():void {
			this.characterName = "Hastur";
			this.textColor = 0xFF0000;
			this.setPortraits({
				'default': [PORTRAIT_DEFAULT, false]
			});
		}
	}
}

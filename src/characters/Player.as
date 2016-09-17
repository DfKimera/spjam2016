package characters {
	import engine.Character;

	public class Player extends Character {

		[Embed(source="../../assets/portrait_testcharacter.jpg")]
		public static var PORTRAIT_DEFAULT:Class;

		override public function setCharacterInfo():void {
			this.characterName = "Jogador";
			this.textColor = 0x00FFFF;
			this.setPortraits({
				'default': [PORTRAIT_DEFAULT, false]
			});
		}
	}
}

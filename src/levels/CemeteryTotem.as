package levels {
	import characters.Hastur;
	import characters.Clovis;

	import engine.InteractiveArea;
	import engine.Level;
	import engine.Portal;

	public class CemeteryTotem extends Level {

		public var BACKGROUND_SPRITE_NIGHT:Class = Assets.BG_CEMETERY_TOTEM;
		public var BACKGROUND_SPRITE_DAY:Class = Assets.BG_CEMETERY_TOTEM_DAY;
		public var BACKGROUND_HIGHLIGHT:Class = Assets.BG_CEMETERY_TOTEM_HIGHLIGHT;
		public var BACKGROUND_ENDING:Class = Assets.BG_CEMETERY_TOTEM_ENDING;

		public static var hasSeenOnce:Boolean = false;

		public function CemeteryTotem() {
		}

		public override function prepare():void {
			setBackground((StoryLog.timeOfDay == "day") ? BACKGROUND_SPRITE_DAY : BACKGROUND_SPRITE_NIGHT);
		}

		public override function create():void {
			super.create();

			Portal.placeOnScene(this, "back_to_tombs_a", 0, 0, 200, 680, CemeteryTombs);
			Portal.placeOnScene(this, "back_to_tombs_b", 0, 600, 200, 680, CemeteryTombs);

			if(!CemeteryTotem.hasSeenOnce) {
				InteractiveArea.placeOnScene(this, "push_hands", 393, 247, 80, 54, pushStatueHands);
			}

			// TODO: solve-able puzzle that triggers outro
		}

		public function pushStatueHands(area:InteractiveArea):void {
			createEventChain("push_statue")
				.addDialog(Clovis, "Apertei a mão da estátua, e um pequeno totem saiu da abertura em baixo.") // TODO: audio SFX
				.addBackground(BACKGROUND_HIGHLIGHT)
				.addBackground(BACKGROUND_SPRITE_NIGHT)
				.addDialog(Hastur, "VOCÊ VEIO ATÉ MIM")
				.addDialog(Hastur, "SUA MALDADE FOI ATRAÍDA ATÉ MINHA PRESENÇA")
				.addDialog(Clovis, "Poderoso Hastur, diga-me o que é necessário para torná-lo livre!")
				.addDialog(Hastur, "QUANDO DENTRO DE VOCÊ, NUNCA SEREMOS SEPARADOS")
				.addDialog(Hastur, "APRENDA AS PALAVRAS, QUEBRE O SELO")
				.addCallback(playerBlacksOut)
				.start();
		}

		public function playerBlacksOut():void {
			CemeteryTotem.hasSeenOnce = true;
			StoryLog.timeOfDay = "night";

			TrainStation.justWokenUp = true;
			TrainStation.setExit(PUCGate);
			Game.transitionToScene(new TrainStation());
		}
	}
}

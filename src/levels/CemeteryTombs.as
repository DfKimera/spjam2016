package levels {
	import characters.Clovis;

	import engine.Dialog;
	import engine.InteractiveArea;

	import engine.Level;
	import engine.Portal;
	import engine.visualnovel.EventChain;

	public class CemeteryTombs extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_CEMETERY_TOMBS;

		public static var isFirstTime:Boolean = true;
		public var tombsDialogChain:EventChain;

		public function CemeteryTombs() {
			tombsDialogChain = createEventChain("tombs_dialog")
				.addDialog(Clovis, "“Arthur Eugênio. Sempre foi um espírito livre.” Tão livre que fugiu da vida").addBreak()
				.addDialog(Clovis, "“Joaquina Fernanda. Sempre sorridente” ainda bem que sua caveira vai continuar sorrindo").addBreak()
				.addDialog(Clovis, "“Erick Santos. Uma fé que será lembrada” Pena que a alma dele pertence ao mestre agora").addBreak()
				.addDialog(Clovis, "“Diane Porto. Vívida e alegre.” Não tão vívida agora").addBreak()
				.addDialog(Clovis, "“Joaquim Ribeiro. Um ótimo marido.” Será que viúva sabia tudo sobre ele?").addBreak()
				.addDialog(Clovis, "“Vanessa Silveira. Filha exemplar.” Moça, sua filha morreu para faltar na aula.").addBreak()
				.addDialog(Clovis, "“Tomás Turbando.” Primo distante de Jacinto Pinto.").addBreak()
				.addDialog(Clovis, "“Asriel Dreemur.” A lápide está cheia de flores amarelas.").addBreak();

		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();

			if(isFirstTime) {
				isFirstTime = false;
				showDialog(Clovis, "Porra, me arranhei todo!"); // TODO: audio SFX
				showDialog(Clovis, "Será que eu serei preso por invadir um cemitério?");
			}

			Portal.placeOnScene(this, "zoom_in_tomb", 473, 92, 75, 149, CemeteryTotem);
			Portal.placeOnScene(this, "back_to_gate", 0, 500, 800, 100, CemeteryGate);

			InteractiveArea.placeOnScene(this, "tomb_1", 115, 274, 56, 83, tombsDialog);
			InteractiveArea.placeOnScene(this, "tomb_2", 189, 215, 47, 75, tombsDialog);
			InteractiveArea.placeOnScene(this, "tomb_3", 269, 183, 30, 79, tombsDialog);
			InteractiveArea.placeOnScene(this, "tomb_4", 525, 210, 47, 86, tombsDialog);
			InteractiveArea.placeOnScene(this, "tomb_5", 581, 293, 68, 90, tombsDialog);
			InteractiveArea.placeOnScene(this, "tomb_6", 677, 342, 56, 125, tombsDialog);

		}

		public function tombsDialog(area:InteractiveArea):void {
			if(tombsDialogChain.events.length > 0) {
				tombsDialogChain.start();
				return;
			}

			showDialog(Clovis, "São todos iguais.");
		}
	}
}

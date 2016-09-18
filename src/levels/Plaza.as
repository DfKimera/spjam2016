package levels {

	import characters.Clovis;

	import engine.InteractiveArea;
	import engine.Item;
	import engine.Level;
	import engine.Portal;
	import engine.Prop;

	import items.Crowbar;

	public class Plaza extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_PLAZA;

		public function Plaza():void {
			super();
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();

			TrainStation.setExit(Plaza);
			Portal.placeOnScene(this, "enter_train_station", 0, 470, 170, 130, TrainStation);

			InteractiveArea.placeOnScene(this, "sewer", 289, 554, 125, 40, onSewerInteract);
		}

		public function onSewerInteract(area:InteractiveArea):void {
			showDialog(Clovis, "Um bueiro. Imundo, como todos os bueiros.");
		}

		public override function onItemUse(prop:Prop, item:Item):void {
			if(prop.name == "sewer" && item is Crowbar) {
				showDialog(Clovis, "*com o pé de cabra, abre o bueiro*");
				showDialog(Clovis, "... ah, Mestre, o que eu não faço por ti...");
				showDialog(Clovis, "Mais um símbolo! Sinto cada vez mais a presença do Mestre!");

				// TODO: give symbol

				item.consume();
			}
		}
	}
}

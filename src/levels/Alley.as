package levels {

	import characters.Clovis;

	import engine.InteractiveArea;
	import engine.Inventory;
	import engine.Item;
	import engine.Level;
	import engine.Portal;
	import engine.Prop;

	import items.BrokenSpyglass;

	import items.Lens;

	import items.Shovel;
	import items.Spyglass;

	public class Alley extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_ALLEY;

		public var hasSeenSymbol:Boolean = false;

		public function Alley():void {
			super();
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();

			TrainStation.setExit(Alley);
			Portal.placeOnScene(this, "enter_train_station", 270, 535, 530, 65, TrainStation);

			if(!Inventory.hasItemOfType("items::Shovel")) {
				Item.placeOnScene(this, new Shovel, 411, 406);
			}

			InteractiveArea.placeOnScene(this, "graffitti", 23, 321, 228, 198, onGraffittiInteract);
		}

		public function onGraffittiInteract(area:InteractiveArea):void {
			if(hasSeenSymbol) {
				showDialog(Clovis, "O magnífico símbolo de Hastur, escondido no meio desse graffitti imundo.");
				return;
			}

			showDialog(Clovis, "Seria fácil esconder um símbolo no meio de todos esse graffittis.");
		}

		public override function onItemUse(prop:Prop, item:Item):void {

			if(item is BrokenSpyglass) {
				return showDialog(Clovis, "Nada de diferente... por que a luneta não tem uma lente...");
			}

			if(item is Lens) {
				return showDialog(Clovis, "Sinto algo diferente, mas a imagem está embaçada demais... A lente precisa estar na distância exata.");
			}

			if(prop.name == "graffitti" && item is Spyglass) {
				showDialog(Clovis, "Bingo! O símbolo parece... vivo!");

				item.consume();
				hasSeenSymbol = true;

				// TODO: give symbol
			}
		}
	}
}

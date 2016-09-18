package levels {

	import characters.Clovis;

	import engine.InteractiveArea;

	import engine.Inventory;
	import engine.Item;
	import engine.Level;
	import engine.Portal;
	import engine.Prop;
	import engine.visualnovel.EventChain;

	import items.BrokenSpyglass;
	import items.Key;
	import items.Shovel;

	import props.ParkDigging;

	public class Park extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_PARK;

		public static var isDigged:Boolean = false;

		public function Park():void {
			super();
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();

			TrainStation.setExit(Park);
			Portal.placeOnScene(this, "enter_train_station", 230, 530, 570, 70, TrainStation);

			if(!Inventory.hasItemOfType("items::BrokenSpyglass") && !Inventory.hasItemOfType("items::Spyglass")) {
				Item.placeOnScene(this, new BrokenSpyglass, 8, 411);
			}

			if(isDigged) {
				Prop.placeOnScene(this, new ParkDigging(), 287, 384);
				return;
			}

			if(Inventory.hasItemOfType("items::Shovel")) {
				InteractiveArea.placeOnScene(this, "diggable_area", 287, 384, 225, 95, onDiggableInteract);
			}
		}

		public override function onBackgroundClick(x:int, y:int):void {
			if(StoryLog.hasBook) {
				showDialog(Clovis, "Olha o tamanho desse lugar! Eu vou ficar horas procurando pelo símbolo!");
				return;
			}

			showDialog(Clovis, "Grande e decadente.");
		}

		public function onDiggableInteract(area:InteractiveArea):void {
			showDialog(Clovis, "O símbolo deve estar por aqui. Há uma marcação no livro, deve estar debaixo da terra.");
		}

		public override function onItemUse(prop:Prop, item:Item):void {
			if(prop.name == "diggable_area" && item is Shovel) {
				Prop.placeOnScene(this, new ParkDigging(), 287, 384);

				showDialog(Clovis, "*cava um buraco raso no chão do parque*");
				showDialog(Clovis, "Mais um local público que vandalizo. Sou mesmo um cidadão exemplar.");
				showDialog(Clovis, "*com a lente, localiza o símbolo em uma placa de pedra*");
				showDialog(Clovis, "É isso! Sinto uma atração inexplicável por esse símbolo. Mestre, estou próximo!");
				showDialog(Clovis, "Junto da placa, há uma chave. O que será que ela abre?");

				isDigged = true;

				Inventory.addToInventory(new Key());
				item.consume();

				// TODO: give symbol
			}
		}
	}
}

package levels {

	import characters.Clovis;

	import engine.InteractiveArea;
	import engine.Inventory;
	import engine.Level;
	import engine.Portal;

	import items.Lens;

	public class Library extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_LIBRARY;

		public function Library():void {
			super();
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();

			TrainStation.setExit(Library);
			Portal.placeOnScene(this, "enter_train_station", 675, 0, 125, 600, TrainStation);

			InteractiveArea.placeOnScene(this, "yellow_bookcase", 347, 50, 21, 69, onBookcaseInteract);
		}

		public function onBookcaseInteract(area:InteractiveArea):void {
			if(StoryLog.hasBook) return;

			if(area.name == "yellow_bookcase") {

				showDialog(Clovis, "Encontrei! Encontrei!");
				showDialog(Clovis, "O 'NECROMICON'!");
				showDialog(Clovis, "Diz aqui que tenho que achar 5 símbolos, e que os 5 foram escondidos aqui em São Paulo.");
				showDialog(Clovis, "Há alguns rabiscos e nomes, mas está tudo muito confuso. O servo que o escreveu devia estar a beira da loucura.");
				showDialog(Clovis, "Hmm... MASP, Parque da Augusta, Beco do Batman, Viaduto do Chá, Praça da Sé...");
				showDialog(Clovis, "O Mestre gosta de cartões postais...");
				showDialog(Clovis, "*abre o livro* Hm, há uma lente aqui também. Através da lente, tudo fica borrado, mas o livro parece brilhar com energia.");

				StoryLog.hasBook = true;
				Inventory.addToInventory(new Lens());
				// TODO: found book
			}

			// TODO: sequence of funny dialogs
		}
	}
}

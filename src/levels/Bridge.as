package levels {

	import characters.Clovis;

	import engine.Book;

	import engine.InteractiveArea;
	import engine.Item;
	import engine.Level;
	import engine.Portal;
	import engine.Prop;

	import items.Hammer;

	public class Bridge extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_BRIDGE;

		public static var isCrackOpen:Boolean = false;

		public function Bridge():void {
			super();
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();

			TrainStation.setExit(Bridge);
			Portal.placeOnScene(this, "enter_train_station", 618, 227, 182, 374, TrainStation);

			InteractiveArea.placeOnScene(this, "crack_on_wall", 473, 534, 51, 63, onCrackInteract);
		}

		public function onCrackInteract(area:InteractiveArea):void {
			if(isCrackOpen) {
				showDialog(Clovis, "Quem será que colocou o símbolo aqui? Seriam os fundadores dessa cidade, servos do Mestre?");
				return;
			}

			showDialog(Clovis, "Há uma rachadura nessa parede... sinto que há algo aqui...");
		}

		public override function onItemUse(prop:Prop, item:Item):void {
			if(!StoryLog.hasBook) return;

			if(item is Hammer) {

				createEventChain("get_symbol", giveSymbol3)
					.addDialog(Clovis,"Tenho que tentar não fazer muito barulho...")
					.addDialog(Clovis,"*bate na parede com o martelo* *CRACK!*")
					.addDialog(Clovis,"É isso! Encontrei um dos símbolos!")
					.start();

				isCrackOpen = true;
				item.consume();
			}
		}

		public function giveSymbol3():void {
			StoryLog.hasSymbol3 = true;
			StoryLog.checkIfAllSymbols(this);

			Book.open();
		}
	}
}

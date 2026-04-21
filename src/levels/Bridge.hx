package levels ;

import characters.Clovis;

import engine.Book;

import engine.InteractiveArea;
import engine.Item;
import engine.Level;
import engine.Portal;
import engine.Prop;

import items.Hammer;

 class Bridge extends Level {

	public var BACKGROUND_SPRITE:String = Assets.BG_BRIDGE;

	public static var isCrackOpen:Bool = false;

	public function new(){
		super();
	}

	public override function prepare() {
		setBackground(BACKGROUND_SPRITE);
	}

	public override function create() {
		super.create();

		TrainStation.setExit(Bridge);
		Portal.placeOnScene(this, "enter_train_station", 618, 227, 182, 374, TrainStation);

		InteractiveArea.placeOnScene(this, "crack_on_wall", 473, 534, 51, 63, onCrackInteract);
	}

	public function onCrackInteract(area:InteractiveArea) {
		if (isCrackOpen) {
			showDialog(Clovis, "Quem será que colocou o símbolo aqui? Seriam os fundadores dessa cidade, servos do Mestre?");
			return;
		}

		showDialog(Clovis, "Há uma rachadura nessa parede... sinto que há algo aqui...");
	}

	public override function onItemUse(prop:Prop, item:Item) {
		if (!StoryLog.hasBook) {
			return;
		}

		if (Std.is(item , Hammer)) {

			createEventChain("get_symbol", giveSymbol3)
					.addDialog(Clovis, "Tenho que tentar não fazer muito barulho...")
					.addDialog(Clovis, "*bate na parede com o martelo* *CRACK!*")
					.addDialog(Clovis, "É isso! Encontrei um dos símbolos!")
					.start();

			isCrackOpen = true;
			item.consume();
		}
	}

	public function giveSymbol3() {
		StoryLog.hasSymbol3 = true;
		StoryLog.checkIfAllSymbols(this);

		Book.open();
	}
}


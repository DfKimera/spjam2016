package levels ;

import characters.Clovis;

import engine.Book;

import engine.InteractiveArea;

import engine.Inventory;
import engine.Item;
import engine.Level;
import engine.Portal;
import engine.Prop;

import items.BrokenSpyglass;
import items.Key;
import items.Shovel;

import props.ParkDigging;

 class Park extends Level {

	public var BACKGROUND_SPRITE:Class<Dynamic> = Assets.BG_PARK;

	public static var isDigged:Bool = false;

	public function new(){
		super();
	}

	public override function prepare() {
		setBackground(BACKGROUND_SPRITE);
	}

	public override function create() {
		super.create();

		TrainStation.setExit(Park);
		Portal.placeOnScene(this, "enter_train_station", 230, 530, 570, 70, TrainStation);

		if (!Inventory.hasItemOfType("items::BrokenSpyglass") && !Inventory.hasItemOfType("items::Spyglass")) {
			Item.placeOnScene(this, new BrokenSpyglass(), 8, 411);
		}

		if (isDigged) {
			Prop.placeOnScene(this, new ParkDigging(), 287, 384);
			return;
		}

		if (Inventory.hasItemOfType("items::Shovel")) {
			InteractiveArea.placeOnScene(this, "diggable_area", 287, 384, 225, 95, onDiggableInteract);
		}
	}

	public override function onBackgroundClick(x:Int, y:Int) {
		if (StoryLog.hasBook && !isDigged) {
			showDialog(Clovis, "Olha o tamanho desse lugar! Eu vou ficar horas procurando pelo símbolo!");
			return;
		}

		showDialog(Clovis, "Grande e decadente.");
	}

	public function onDiggableInteract(area:InteractiveArea) {
		if (isDigged) {
			return;
		}
		showDialog(Clovis, "O símbolo deve estar por aqui. Há uma marcação no livro, deve estar debaixo da terra.");
	}

	public override function onItemUse(prop:Prop, item:Item) {
		if (!StoryLog.hasBook) {
			return;
		}

		if (prop.name == "diggable_area" && Std.is(item , Shovel)) {
			Prop.placeOnScene(this, new ParkDigging(), 287, 384);

			createEventChain("dig_hole", giveSymbol4)
					.addDialog(Clovis, "*cava um buraco raso no chão do parque*")
					.addDialog(Clovis, "Mais um local público que vandalizo. Sou mesmo um cidadão exemplar.")
					.addDialog(Clovis, "*com a lente, localiza o símbolo em uma placa de pedra*")
					.addDialog(Clovis, "É isso! Sinto uma atração inexplicável por esse símbolo. Mestre, estou próximo!")
					.addDialog(Clovis, "Junto da placa, há uma chave. O que será que ela abre?")
					.start();

			isDigged = true;
			item.consume();
		}
	}

	public function giveSymbol4() {
		Inventory.addToInventory(new Key());

		StoryLog.hasSymbol4 = true;
		StoryLog.checkIfAllSymbols(this);

		Book.open();
	}
}


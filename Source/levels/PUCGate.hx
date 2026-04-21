package levels ;

import engine.Inventory;
import engine.Item;
import engine.Level;
import engine.Portal;

import items.Crowbar;

 class PUCGate extends Level {

	public var BACKGROUND_SPRITE:Class<Dynamic> = Assets.BG_PUC_GATE;

	public function new(){
		super();
	}

	public override function prepare() {
		setBackground(BACKGROUND_SPRITE);
	}

	public override function create() {
		super.create();

		Portal.placeOnScene(this, "enter_puc", 500, 140, 170, 380, PUCClassRoom);
		Portal.placeOnScene(this, "leave_station", 0, 320, 75, 280, TrainStation);

		if (!Inventory.hasItemOfType("items::Crowbar")) {
			Item.placeOnScene(this, new Crowbar(), 146, 371);
		}
	}
}


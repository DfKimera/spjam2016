package items ;

import engine.Inventory;
import engine.Item;

 class Lens extends Item {

	public function new() {
		super("assets/items/lens_inventory.png", "assets/items/lens_placed.png");
	}
	public override function onCombine(item:Item) {
		if (Std.is(item , BrokenSpyglass)) {
			item.consume();
			this.consume();
			Inventory.addToInventory(new Spyglass());
		}
	}

}

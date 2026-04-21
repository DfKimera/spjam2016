package items ;

import characters.Clovis;
import engine.Inventory;
import engine.Item;
import engine.Level;

 class BrokenSpyglass extends Item {

	public function new() {
		super("assets/items/broken_spyglass_inventory.png", "assets/items/broken_spyglass_placed.png");
	}
	public override function onCombine(item:Item) {
		if (Std.is(item , Lens)) {
			item.consume();
			this.consume();
			Inventory.addToInventory(new Spyglass());

			Level.getCurrent().showDialog(Clovis, "Pronto, agora posso usar a lente especial.");
		}
	}

}

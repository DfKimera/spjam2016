package items ;

import characters.Clovis;

import engine.Inventory;
import engine.Item;
import engine.Level;

 class BrokenSpyglass extends Item {

	@:meta(Embed(source="../../assets/items/broken_spyglass_inventory.png"))
	public var ICON_SPRITE:Class<Dynamic>;

	@:meta(Embed(source="../../assets/items/broken_spyglass_placed.png"))
	public var PLACED_SPRITE:Class<Dynamic>;

	public function new() {
		super(ICON_SPRITE, PLACED_SPRITE);
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


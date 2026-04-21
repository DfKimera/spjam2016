package items ;

import engine.Inventory;
import engine.Item;

 class Lens extends Item {

	@:meta(Embed(source="../../assets/items/lens_inventory.png"))
	public var ICON_SPRITE:Class<Dynamic>;

	@:meta(Embed(source="../../assets/items/lens_placed.png"))
	public var PLACED_SPRITE:Class<Dynamic>;

	public function new() {
		super(ICON_SPRITE, PLACED_SPRITE);
	}

	public override function onCombine(item:Item) {
		if (Std.is(item , BrokenSpyglass)) {
			item.consume();
			this.consume();
			Inventory.addToInventory(new Spyglass());
		}
	}

}


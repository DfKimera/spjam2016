package items ;

import engine.Item;

 class Spyglass extends Item {

	@:meta(Embed(source="../../assets/items/spyglass_inventory.png"))
	public var ICON_SPRITE:Class<Dynamic>;

	@:meta(Embed(source="../../assets/items/spyglass_placed.png"))
	public var PLACED_SPRITE:Class<Dynamic>;

	public function new() {
		super(ICON_SPRITE, PLACED_SPRITE);
	}

}


package items ;

import engine.Item;

 class Hammer extends Item {

	@:meta(Embed(source="../../assets/items/hammer_inventory.png"))
	public var ICON_SPRITE:Class<Dynamic>;

	@:meta(Embed(source="../../assets/items/hammer_placed.png"))
	public var PLACED_SPRITE:Class<Dynamic>;

	public function new() {
		super(ICON_SPRITE, PLACED_SPRITE);
	}

}


package items ;

import engine.Item;

 class Crowbar extends Item {

	@:meta(Embed(source="../../assets/items/crowbar_inventory.png"))
	public var ICON_SPRITE:Class<Dynamic>;

	@:meta(Embed(source="../../assets/items/crowbar_placed.png"))
	public var PLACED_SPRITE:Class<Dynamic>;

	public function new() {
		super(ICON_SPRITE, PLACED_SPRITE);
	}

}


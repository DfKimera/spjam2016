package items ;

import engine.Item;

 class Knife extends Item {

	@:meta(Embed(source="../../assets/item_knife.png"))
	public var ICON_SPRITE:Class<Dynamic>;

	@:meta(Embed(source="../../assets/item_knife.png"))
	public var PLACED_SPRITE:Class<Dynamic>;

	public function new() {
		super(ICON_SPRITE, PLACED_SPRITE);
	}

}


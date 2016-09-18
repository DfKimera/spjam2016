package items {

	import engine.Item;

	public class Hammer extends Item {

		[Embed(source="../../assets/items/hammer_inventory.png")]
		public var ICON_SPRITE:Class;

		[Embed(source="../../assets/items/hammer_placed.png")]
		public var PLACED_SPRITE:Class;

		public function Hammer() {
			super(ICON_SPRITE, PLACED_SPRITE);
		}

	}
}

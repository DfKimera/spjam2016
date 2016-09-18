package items {

	import engine.Item;

	public class Shovel extends Item {

		[Embed(source="../../assets/items/shovel_inventory.png")]
		public var ICON_SPRITE:Class;

		[Embed(source="../../assets/items/shovel_placed.png")]
		public var PLACED_SPRITE:Class;

		public function Shovel() {
			super(ICON_SPRITE, PLACED_SPRITE);
		}

	}
}

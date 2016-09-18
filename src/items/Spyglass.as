package items {

	import engine.Item;

	public class Spyglass extends Item {

		[Embed(source="../../assets/items/spyglass_inventory.png")]
		public var ICON_SPRITE:Class;

		[Embed(source="../../assets/items/spyglass_placed.png")]
		public var PLACED_SPRITE:Class;

		public function Spyglass() {
			super(ICON_SPRITE, PLACED_SPRITE);
		}

	}
}

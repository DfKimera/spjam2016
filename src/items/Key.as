package items {

	import engine.Item;

	public class Key extends Item {

		[Embed(source="../../assets/items/key_inventory.png")]
		public var ICON_SPRITE:Class;

		[Embed(source="../../assets/items/key_placed.png")]
		public var PLACED_SPRITE:Class;

		public function Key() {
			super(ICON_SPRITE, PLACED_SPRITE);
		}

	}
}

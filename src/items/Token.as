package items {

	import engine.Item;

	public class Token extends Item {

		[Embed(source="../../assets/items/token_inventory.png")]
		public var ICON_SPRITE:Class;

		[Embed(source="../../assets/items/token_inventory.png")]
		public var PLACED_SPRITE:Class;

		public function Token() {
			super(ICON_SPRITE, PLACED_SPRITE);
		}

	}
}

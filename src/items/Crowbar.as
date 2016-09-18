package items {

	import engine.Item;

	public class Crowbar extends Item {

		[Embed(source="../../assets/items/crowbar_inventory.png")]
		public var ICON_SPRITE:Class;

		[Embed(source="../../assets/items/crowbar_placed.png")]
		public var PLACED_SPRITE:Class;

		public function Crowbar() {
			super(ICON_SPRITE, PLACED_SPRITE);
		}

	}
}

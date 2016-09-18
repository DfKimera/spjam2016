package items {

	import engine.Item;

	public class Knife extends Item {

		[Embed(source="../../assets/item_knife.png")]
		public var ICON_SPRITE:Class;

		[Embed(source="../../assets/item_knife.png")]
		public var PLACED_SPRITE:Class;

		public function Knife() {
			super(ICON_SPRITE, PLACED_SPRITE);
		}

	}
}

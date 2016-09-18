package items {

	import engine.Inventory;
	import engine.Item;

	public class Lens extends Item {

		[Embed(source="../../assets/items/lens_inventory.png")]
		public var ICON_SPRITE:Class;

		[Embed(source="../../assets/items/lens_placed.png")]
		public var PLACED_SPRITE:Class;

		public function Lens() {
			super(ICON_SPRITE, PLACED_SPRITE);
		}

		public override function onCombine(item:Item):void {
			if(item is BrokenSpyglass) {
				item.consume();
				this.consume();
				Inventory.addToInventory(new Spyglass());
			}
		}

	}
}

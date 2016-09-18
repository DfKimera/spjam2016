package items {

	import characters.Clovis;

	import engine.Inventory;
	import engine.Item;
	import engine.Level;

	public class BrokenSpyglass extends Item {

		[Embed(source="../../assets/items/broken_spyglass_inventory.png")]
		public var ICON_SPRITE:Class;

		[Embed(source="../../assets/items/broken_spyglass_placed.png")]
		public var PLACED_SPRITE:Class;

		public function BrokenSpyglass() {
			super(ICON_SPRITE, PLACED_SPRITE);
		}

		public override function onCombine(item:Item):void {
			if(item is Lens) {
				item.consume();
				this.consume();
				Inventory.addToInventory(new Spyglass());

				Level.getCurrent().showDialog(Clovis, "Pronto, agora posso usar a lente especial.");
			}
		}

	}
}

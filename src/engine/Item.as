package engine {

	import flash.utils.getQualifiedClassName;

	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Item extends FlxBasic {

		private var graphicIcon:Class;
		private var graphicPlaced:Class;

		protected var icon:FlxExtendedSprite;
		public var placed:FlxExtendedSprite;

		public function Item(graphicIcon:Class, graphicPlaced:Class) {
			this.graphicIcon = graphicIcon;
			this.graphicPlaced = graphicPlaced;

			icon = generateIcon();

			placed = new FlxExtendedSprite(0,0);
			placed.loadGraphic(graphicPlaced, false, false);
			placed.mouseReleasedCallback = this._onPick;
			placed.onUpdate = function():void {
				if(placed.mouseOver) {
					Cursor.useHand();
				}
			};

		}

		/**
		 * Generates a sprite icon to represent this item.
		 * @return FlxExtendedSprite
		 */
		public function generateIcon():FlxExtendedSprite {
			var icon:FlxExtendedSprite = new FlxExtendedSprite(0,0);
			icon.loadGraphic(graphicIcon, false, false, 80, 80);
			icon.name = getQualifiedClassName(this);
			return icon;
		}

		/**
		 * Gets the item's grid icon
		 * @return FlxExtendedSprite
		 */
		public function getIcon():FlxExtendedSprite {
			if(!icon.offset) {
				icon = generateIcon();
			}

			return icon;
		}

		/**
		 * @abstract
		 * Called when this item is picked from the scene.
		 */
		public function onPick():void {}

		/**
		 * @abstract
		 * Called when this item (target) is combined with another (origin).
		 * @param item Item
		 */
		public function onCombine(item:Item):void {}

		/**
		 * @abstract
		 * Called when this item is consumed.
		 */
		public function onConsume():void {}

		/**
		 * Consumes this item, removing it from the inventory and game.
		 */
		public function consume():void {
			trace("Item consumed: ", this);

			Inventory.releaseItemOnCursor();

			this.onConsume();
			Inventory.removeFromInventory(this);

			icon.kill();
			icon.destroy();

			placed.kill();
			placed.destroy();

			this.kill();
			this.destroy();

		}

		/**
		 * @internal
		 * Internal handler for item pick.
		 * @param spr
		 * @param x
		 * @param y
		 */
		public function _onPick(spr:FlxExtendedSprite, x:int, y:int):void {

			SFX.play("pick");

			if(Inventory.isHoldingItem()) {
				return;
			}

			trace("Item added to inventory: ",this);

			Inventory.addToInventory(this);

			this.onPick();

			if(FlxG.state is Scene) {
				trace("Item removed from scene: ", FlxG.state);
				(FlxG.state as Scene).items.remove(placed);
				(FlxG.state as Scene).onItemPick(this);
			}

		}

		/**
		 * @internal
		 * Internal handler for item combine.
		 * @param item
		 */
		public function _onCombine(item:Item):void {
			trace("Combining items: ", this, item);
			Inventory.releaseItemOnCursor();
			SFX.play("bell");
			this.onCombine(item);
			(FlxG.state as Scene).onItemCombine(this, item);
			Inventory.redrawGrid();
		}

		/**
		 * @internal
		 * Internal handler for item use.
		 */
		public function _onUse():void {
			Inventory.hide();
		}

		// -------------------------------------------------------------------------------------------------------------

		/**
		 * Places an item instance on the scene, but only if the player hasn't picked it yet.
		 * @param scene Scene The scene.
		 * @param item Item The item.
		 * @param x int The position of the item on the scene.
		 * @param y int
		 */
		public static function placeOnScene(scene:Scene, item:Item, x:int, y:int):Item {

			if(Inventory.hasItem(item)) {
				trace("Skipping scene placement of item: ", item, "(player already picked)");
				return item;
			}

			item.placed.x = x;
			item.placed.y = y;
			scene.items.add(item.placed);

			trace("Item placed: ", scene, item, x, y, item.ID);

			return item;

		}
	}
}

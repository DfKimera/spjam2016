package engine {

	import flash.utils.getQualifiedClassName;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Inventory extends FlxGroup {

		[Embed(source="../../assets/inventory_grid_vertical.png")]
		public static var BACKGROUND:Class;

		[Embed(source="../../assets/inventory_icon.png")]
		public static var BUTTON:Class;

		[Embed(source="../../assets/inventory_icon_open.png")]
		public static var BUTTON_OPEN:Class;

		public var button:FlxExtendedSprite;

		private var scene:Scene;
		public var $items:FlxGroup = new FlxGroup();
		public var background:FlxExtendedSprite;

		public var isOpen:Boolean = false;

		public var position:Array = [FlxG.width - 230, FlxG.height - 565];

		public var itemPositionOffset:Array = [636,87]; //[285,437];
		public var itemMargin:int = 9;
		public var currentItem:int = 0;
		public var maxItemsPerRow:int = 1;

		private static var itemIndex:int = 0;

		public function Inventory(scene:Scene) {
			Inventory.invGrid =  this;

			button = new FlxExtendedSprite(FlxG.width - 100, FlxG.height - 100);
			button.loadGraphic(BUTTON);
			button.mouseReleasedCallback = this.onButtonClick;
			scene.ui.add(button);

			button.ID = int.MAX_VALUE - 1;

			this.scene = scene;

			trace("Inventory registered on scene: ", scene);

			background = new FlxExtendedSprite(position[0],position[1]);
			background.loadGraphic(BACKGROUND);

			add(background);
			add($items);

			this.generateGrid();
		}

		private function generateGrid():void {
			for(var itemType:String in Inventory.items) {
				if(!Inventory.items[itemType]) { continue; }
				placeItemOnGrid(Inventory.items[itemType]);
			}
		}

		private function redrawGrid():void {
			$items.clear();
			currentItem = 0;
			this.generateGrid();
		}

		private function placeItemOnGrid(item:Item):void {

			var icon:FlxExtendedSprite = item.getIcon();
			icon.name = getQualifiedClassName(item);
			icon.mouseReleasedCallback = this.onGridIconPick;

			var col:int = (currentItem % maxItemsPerRow);
			var row:int = Math.floor(currentItem / maxItemsPerRow);

			icon.x = itemPositionOffset[0] + (col * (80 + itemMargin));
			icon.y = itemPositionOffset[1] + (row * (80 + itemMargin));

			$items.add(icon);
			icon.ID = 10000 + (++itemIndex);

			currentItem++;

		}

		private function onGridIconPick(icon:FlxExtendedSprite, x:int, y:int):void {
			var itemType:String = icon.name;
			var item:Item = Inventory.getItemOfType(itemType);

			if(Inventory.isHoldingItem()) {
				item._onCombine( Inventory.getHeldItem() );
				return;
			}

			trace("Picked item from grid: ", item);

			Inventory.holdItemOnCursor(item);

		}

		public override function kill():void {
			$items.clear();
		}

		private function show():void {
			trace("Opening inventory: ", this,  this.scene);
			this.scene.invLayer.add(this);
			this.isOpen = true;
			this.button.loadGraphic(BUTTON_OPEN);
		}

		private function hide():void {
			trace("Hiding inventory: ", this,  this.scene);
			this.scene.invLayer.remove(this);
			this.isOpen = false;
			this.button.loadGraphic(BUTTON);
		}

		private function onButtonClick(btn:FlxExtendedSprite, x:int, y:int):void {
			if(this.isOpen) {
				this.hide();
			} else {
				this.show();
			}
		}

		// -------------------------------------------------------------------------------------------------------------

		private static var invGrid:Inventory;
		private static var items:Array = [];

		/**
		 * Adds an item to the player's inventory.
		 * @param item Item The item to be added.
		 */
		public static function addToInventory(item:Item):void {
			Inventory.items[getQualifiedClassName(item)] = item;
			invGrid.placeItemOnGrid(item);
		}

		/**
		 * Removes an item from the player's inventory.
		 * @param item Item The item to be removed.
		 */
		public static function removeFromInventory(item:Item):void {
			Inventory.items[getQualifiedClassName(item)] = null;
			invGrid.redrawGrid();
		}

		/**
		 * Checks if a player has an item in his inventory.
		 * @param item Item The item to check.
		 * @return Boolean
		 */
		public static function hasItem(item:Item):Boolean {
			var i:Item = Inventory.items[getQualifiedClassName(item)];
			return (i != null);
		}

		/**
		 * Checks if a player has an item of a certain qualified class name.
		 * @param type String The item's qualified class name.
		 * @return Boolean
		 */
		public static function hasItemOfType(type:String):Boolean {
			return Inventory.items.hasOwnProperty(type);
		}

		/**
		 * Gets an item from the inventory by it's qualified class name.
		 * @param type String The item's qualified class name.
		 * @return
		 */
		public static function getItemOfType(type:String):Item {
			return Inventory.items[type];
		}

		/**
		 * Shows the inventory grid.
		 */
		public static function show():void {
			if(Inventory.invGrid is Inventory) {
				Inventory.invGrid.redrawGrid();
				Inventory.invGrid.show();
			}
		}

		/**
		 * Hides the inventory grid.
		 */
		public static function hide():void {
			if(Inventory.invGrid is Inventory) {
				Inventory.invGrid.hide();
			}
		}

		/**
		 * Checks if the inventory grid is open.
		 * @return Boolean
		 */
		public static function isOpen():Boolean {
			return (Inventory.invGrid is Inventory && Inventory.invGrid.isOpen);
		}

		/**
		 * Forces an inventory grid redraw.
		 */
		public static function redrawGrid():void {
			if(Inventory.invGrid is Inventory) {
				Inventory.invGrid.redrawGrid();
			}
		}

		/**
		 * Checks if the mouse is over the inventory grid
		 * @return Boolean
		 */
		public static function isMouseOver():Boolean {
			return (Inventory.isOpen() && Inventory.invGrid.background.mouseOver);
		}

		/**
		 * Check if the player is holding an item from the inventory.
		 * @return Boolean
		 */
		public static function isHoldingItem():Boolean {
			if(FlxG.state is Scene) {
				return ((FlxG.state as Scene).selectedItemIcon != null);
			}

			return false;
		}

		/**
		 * Returns the item currently being held by the player, or null if none.
		 * @return Boolean
		 */
		public static function getHeldItem():Item {
			if(!Inventory.isHoldingItem()) { return null; }
			if(!(FlxG.state is Scene)) { return null; }
			return Inventory.getItemOfType( (FlxG.state as Scene).selectedItemIcon.name );
		}

		/**
		 * Returns the currently being held item's icon, or null if no item is being held.
		 * @return Boolean
		 */
		public static function getHeldItemIcon():FlxExtendedSprite {
			if(!(FlxG.state is Scene)) { return null; }
			return (FlxG.state as Scene).selectedItemIcon;
		}

		/**
		 * Holds an item in the player's cursor.
		 * @param item Item The item to be held.
		 */
		public static function holdItemOnCursor(item:Item):void {
			(FlxG.state as Scene).holdItemOnCursor(item);
		}

		/**
		 * Releases whichever item is being held on the player's cursor.
		 */
		public static function releaseItemOnCursor():void {
			(FlxG.state as Scene).releaseItemOnCursor();
		}
	}

}

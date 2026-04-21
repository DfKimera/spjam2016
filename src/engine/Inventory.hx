package engine;

import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.plugin.photonstorm.FlxExtendedSprite;

class Inventory extends FlxGroup {

    @:meta(Embed(source = "../../assets/inventory_grid_vertical_v2.png"))
    public static var BACKGROUND:Class<Dynamic>;

    @:meta(Embed(source = "../../assets/inventory_icon.png"))
    public static var BUTTON:Class<Dynamic>;

    @:meta(Embed(source = "../../assets/inventory_icon.png"))
    public static var BUTTON_OPEN:Class<Dynamic>;

    public var button:FlxExtendedSprite;

    var scene:Scene;
    public var _items:FlxGroup = new FlxGroup();
    public var background:FlxExtendedSprite;

    public var _isOpen:Bool = false;

    public var position:Array<ASAny> = [FlxG.width - 313, FlxG.height - 600];

    public var itemPositionOffset:Array<ASAny> = [544, 69]; //[285,437];
    public var itemMargin:Int = 11;
    public var currentItem:Int = 0;
    public var maxItemsPerRow:Int = 1;

    static var itemIndex:Int = 0;

    public function new(scene:Scene) {
        super();
        Inventory._invGrid = this;

        button = new FlxExtendedSprite(FlxG.width - 100, FlxG.height - 100);
        button.loadGraphic(BUTTON);
        button.mouseReleasedCallback = this.onButtonClick;
        scene.ui.add(button);

        button.ID = ASCompat.MAX_INT - 1;

        this.scene = scene;

        trace("Inventory registered on scene: ", scene);

        background = new FlxExtendedSprite(position[0], position[1]);
        background.loadGraphic(BACKGROUND);

        add(background);
        add(_items);

        this.generateGrid();
    }

    function generateGrid() {
        for (itemType in Reflect.fields(Inventory.items)) {
            if (!Inventory.items[itemType]) {
                continue;
            }
            placeItemOnGrid(Inventory.items[itemType]);
        }
    }

    function _redrawGrid() {
        _items.clear();
        currentItem = 0;
        this.generateGrid();
    }

    function placeItemOnGrid(item:Item) {

        var icon = item.getIcon();
        icon.name = getQualifiedClassName(item);
        icon.mouseReleasedCallback = this.onGridIconPick;

        var col = (currentItem % maxItemsPerRow);
        var row = Math.floor(currentItem / maxItemsPerRow);

        icon.x = ASCompat.toNumber(itemPositionOffset[0]) + (col * (80 + itemMargin));
        icon.y = ASCompat.toNumber(itemPositionOffset[1]) + (row * (80 + itemMargin));

        _items.add(icon);
        icon.ID = 10000 + (++itemIndex);

        currentItem++;

    }

    function onGridIconPick(icon:FlxExtendedSprite, x:Int, y:Int) {
        var itemType = icon.name;
        var item = Inventory.getItemOfType(itemType);

        if (Inventory.isHoldingItem()) {
            item._onCombine(Inventory.getHeldItem());
            return;
        }

        trace("Picked item from grid: ", item);

        Inventory.holdItemOnCursor(item);

    }

    public override function kill() {
        _items.clear();
    }

    function _show() {
        trace("Opening inventory: ", this, this.scene);
        this.scene.invLayer.add(this);
        this._isOpen = true;
        this.button.loadGraphic(BUTTON_OPEN);
    }

    function _hide() {
        trace("Hiding inventory: ", this, this.scene);
        this.scene.invLayer.remove(this);
        this._isOpen = false;
        this.button.loadGraphic(BUTTON);
    }

    function onButtonClick(btn:FlxExtendedSprite, x:Int, y:Int) {
        if (this._isOpen) {
            this._hide();
        } else {
            this._show();
        }
    }

    // -------------------------------------------------------------------------------------------------------------

    static var _invGrid:Inventory;
    static var items:ASAny = {};

    /**
	 * Adds an item to the player's inventory.
	 * @param item Item The item to be added.
	 */
    public static function addToInventory(item:Item) {
        Inventory.items[getQualifiedClassName(item)] = item;
        _invGrid.placeItemOnGrid(item);
    }

    /**
	 * Removes an item from the player's inventory.
	 * @param item Item The item to be removed.
	 */
    public static function removeFromInventory(item:Item) {
        Inventory.items[getQualifiedClassName(item)] = null;
        _invGrid._redrawGrid();
    }

    /**
	 * Checks if a player has an item in his inventory.
	 * @param item Item The item to check.
	 * @return Boolean
	 */
    public static function hasItem(item:Item):Bool {
        var i:Item = Inventory.items[getQualifiedClassName(item)];
        return (i != null);
    }

    /**
	 * Checks if a player has an item of a certain qualified class name.
	 * @param type String The item's qualified class name.
	 * @return Boolean
	 */
    public static function hasItemOfType(type:String):Bool {
        return Utils.hasItemOfType(Inventory.items, type);
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
    public static function show() {
        if (Std.is(Inventory._invGrid, Inventory)) {
            Inventory._invGrid._redrawGrid();
            Inventory._invGrid._show();
        }
    }

    /**
	 * Hides the inventory grid.
	 */
    public static function hide() {
        if (Std.is(Inventory._invGrid, Inventory)) {
            Inventory._invGrid._hide();
        }
    }

    /**
	 * Checks if the inventory grid is open.
	 * @return Boolean
	 */
    public static function isOpen():Bool {
        return (Std.is(Inventory._invGrid, Inventory) && Inventory._invGrid._isOpen);
    }

    /**
	 * Forces an inventory grid redraw.
	 */
    public static function redrawGrid() {
        if (Std.is(Inventory._invGrid, Inventory)) {
            Inventory._invGrid._redrawGrid();
        }
    }

    /**
	 * Checks if the mouse is over the inventory grid
	 * @return Boolean
	 */
    public static function isMouseOver():Bool {
        return (Inventory.isOpen() && Inventory._invGrid.background.mouseOver);
    }

    /**
	 * Check if the player is holding an item from the inventory.
	 * @return Boolean
	 */
    public static function isHoldingItem():Bool {
        if (Std.is(FlxG.state, Scene)) {
            return (Std.downcast(FlxG.state, Scene).selectedItemIcon != null);
        }

        return false;
    }

    /**
	 * Returns the item currently being held by the player, or null if none.
	 * @return Boolean
	 */
    public static function getHeldItem():Item {
        if (!Inventory.isHoldingItem()) {
            return null;
        }
        if (!Std.is(FlxG.state, Scene)) {
            return null;
        }
        return Inventory.getItemOfType(Std.downcast(FlxG.state, Scene).selectedItemIcon.name);
    }

    /**
	 * Returns the currently being held item's icon, or null if no item is being held.
	 * @return Boolean
	 */
    public static function getHeldItemIcon():FlxExtendedSprite {
        if (!Std.is(FlxG.state, Scene)) {
            return null;
        }
        return Std.downcast(FlxG.state, Scene).selectedItemIcon;
    }

    /**
	 * Holds an item in the player's cursor.
	 * @param item Item The item to be held.
	 */
    public static function holdItemOnCursor(item:Item) {
        Std.downcast(FlxG.state, Scene).holdItemOnCursor(item);
    }

    /**
	 * Releases whichever item is being held on the player's cursor.
	 */
    public static function releaseItemOnCursor() {
        Std.downcast(FlxG.state, Scene).releaseItemOnCursor();
    }
}



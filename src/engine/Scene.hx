package engine ;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.plugin.photonstorm.FlxExtendedSprite;

 class Scene extends FlxState {

	public var game:Game;
	public var background:FlxSprite;
	public var inventory:Inventory;
	public var book:Book;

	public var props:FlxGroup = new FlxGroup();
	public var items:FlxGroup = new FlxGroup();
	public var invLayer:FlxGroup = new FlxGroup();
	public var ui:FlxGroup = new FlxGroup();
	public var dialog:FlxGroup = new FlxGroup();

	public var selectedItemIcon:FlxExtendedSprite;

	var fadeInDelay:Float = Config.SCENE_FADE_DELAY;
	var isReady:Bool = false;

	public function new(){
		super();
		trace("Preparing scene...");
		this.prepare();
	}

	/**
	 * @abstract
	 * Called before the scene is created; should be used to set background and fade delays.
	 */
	public function prepare() {
		trace("No scene preparation necessary");
	}

	/**
	 * Called when the scene is created.
	 * If overridden, don't forget to call super.create();.
	 */
	public override function create() {

		trace("Creating scene: ", this);

		this.game = Game.instance;

		if (background == null) {
			background = new FlxSprite(0, 0);
		} else {
			trace("Scene has background: ", background, background.ID);
		}

		add(background);

		add(props);
		add(items);
		add(invLayer);
		add(ui);
		add(dialog);

		trace("Done, displaying...");

		var scene= this;

		if (hasInventoryEnabled()) {
			inventory = new Inventory(this);
		}

		book = new Book(this);

		FlxG.flash(0xff000000, this.fadeInDelay, function () {
			isReady = true;
		});
	}

	function hasInventoryEnabled():Bool {
		return true;
	}

	/**
	 * Called at every frame.
	 * If overridden, don't forget to call super.update();.
	 */
	public override function update() {
		super.update();

		if (!isReady) {
			return;
		}

		if (FlxG.keys.justPressed("I")) {
			if (!Inventory.isOpen()) {
				Inventory.show();
			} else {
				Inventory.hide();
			}
		}

		if (FlxG.keys.justPressed("B")) {
			if (!Book.isOpen()) {
				Book.open();
			} else {
				Book.close();
			}
		}

		if (Inventory.isHoldingItem()) {
			selectedItemIcon.x = FlxG.mouse.x + 2;
			selectedItemIcon.y = FlxG.mouse.y + 2;
		}

	}

	/**
	 * Holds an item in the player's cursor.
	 * @param item Item
	 */
	public function holdItemOnCursor(item:Item) {
		selectedItemIcon = item.generateIcon();
		add(selectedItemIcon);

		trace("Holding item on cursor: ", selectedItemIcon);
	}

	/**
	 * Releases whichever item is on the player's cursor.
	 */
	public function releaseItemOnCursor() {

		if (Std.is(selectedItemIcon , FlxExtendedSprite)) {
			remove(selectedItemIcon);
		}

		selectedItemIcon = null;
	}

	/**
	 * Sets the fade-in/fade-out delay for this scene.
	 * @param delay Number The delay in seconds.
	 */
	public function setFadeInDelay(delay:Float) {
		fadeInDelay = delay;
	}

	/**
	 * Sets the scene's background bitmap class.
	 * @param backgroundBitmap Class
	 */
	public function setBackground(backgroundBitmap:Class<Dynamic>) {
		background = new Background(backgroundBitmap, this);
	}

	/**
	 * @abstract
	 * Called when the player interacts with a prop.
	 * @param prop Prop The interacted prop.
	 */
	public function onPropInteract(prop:Prop) {
	}

	/**
	 * @abstract
	 * Called when the player uses an item on a prop.
	 * @param prop Prop The prop triggered.
	 * @param item Item The item used.
	 */
	public function onItemUse(prop:Prop, item:Item) {
	}

	/**
	 * @abstract
	 * Called when the player picks an item.
	 * @param item Item The picked item.
	 */
	public function onItemPick(item:Item) {
	}

	/**
	 * @abstract
	 * Called when two items are combined together
	 * @param item1 Item The first item (target).
	 * @param item2 Item The second item (origin).
	 */
	public function onItemCombine(item1:Item, item2:Item) {
	}

	/**
	 * @abstract
	 * Called when a player clicks on the background (not on any prop/item).
	 * @param x int The X position.
	 * @param y int The Y position.
	 */
	public function onBackgroundClick(x:Int, y:Int) {
	}

	/**
	 * @internal
	 * Internal background click handling
	 * @param x
	 * @param y
	 */
	public function _onBackgroundClick(x:Int, y:Int) {
		trace("Triggered background @ ", x, y);
		this.releaseItemOnCursor();
	}

}


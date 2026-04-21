package engine ;

import chapters.Outro;

import characters.Clovis;

import engine.*;

import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;

import levels.CemeteryTotem;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.plugin.photonstorm.FlxExtendedSprite;

 class Book extends FlxGroup {

	public static var BACKGROUND:String = "assets/book_background.png";
	public static var BUTTON:String = "assets/book_icon.png";
	public static var BUTTON_OPEN:String = "assets/book_icon.png";
	public static var SUMMON_BTN:String = "assets/btn_summon_hastur.png";

	public static var instance:Book;
	public static var button:FlxExtendedSprite;

	var scene:Scene;
	public var background:FlxExtendedSprite;
	public var grid:FlxExtendedSprite;

	public var symbol1:FlxExtendedSprite;
	public var symbol2:FlxExtendedSprite;
	public var symbol3:FlxExtendedSprite;
	public var symbol4:FlxExtendedSprite;
	public var symbol5:FlxExtendedSprite;

	public var summonBtn:FlxExtendedSprite;

	public var _isOpen:Bool = false;

	public var position:Array<ASAny> = [0, 0];

	public function new(scene:Scene) {
		super();

		Book.instance = this;

		button = new FlxExtendedSprite(FlxG.width - 100, FlxG.height - 200);
		button.loadGraphic(BUTTON);
		button.mouseReleasedCallback = this.onButtonClick;

		grid = new FlxExtendedSprite(94, 196, Assets.BOOK_SYMBOL_GRID);

		symbol1 = new FlxExtendedSprite(94 + 39, 196 + 6, Assets.SYMBOL_1);
		symbol2 = new FlxExtendedSprite(94 + 7, 196 + 83, Assets.SYMBOL_2);
		symbol3 = new FlxExtendedSprite(94 + 138, 196 + 6, Assets.SYMBOL_3);
		symbol4 = new FlxExtendedSprite(94 + 169, 196 + 85, Assets.SYMBOL_4);
		symbol5 = new FlxExtendedSprite(94 + 91, 196 + 148, Assets.SYMBOL_5);

		summonBtn = new FlxExtendedSprite(73, 448, SUMMON_BTN);
		summonBtn.mouseReleasedCallback = onSummonClick;
		summonBtn.ID = 10000;

		this.scene = scene;

		background = new FlxExtendedSprite(position[0], position[1]);
		background.loadGraphic(BACKGROUND);

		add(background);
		add(grid);

		if (StoryLog.hasBook) {
			addButton();
		}
	}

	public function setupSymbolGrid() {
		clearSymbolGrid();

		if (StoryLog.hasSymbol1) {
			add(symbol1);
		}
		if (StoryLog.hasSymbol2) {
			add(symbol2);
		}
		if (StoryLog.hasSymbol3) {
			add(symbol3);
		}
		if (StoryLog.hasSymbol4) {
			add(symbol4);
		}
		if (StoryLog.hasSymbol5) {
			add(symbol5);
		}

		if (StoryLog.hasAllSymbols()) {
			scene.ui.add(summonBtn);
			summonBtn.ID = 10000;
		}
	}

	public function clearSymbolGrid() {
		scene.ui.remove(summonBtn);

		remove(symbol1);
		remove(symbol2);
		remove(symbol3);
		remove(symbol4);
		remove(symbol5);
	}

	public function addButton() {
		trace("Button registered on scene: ", scene);
		scene.ui.add(button);
		button.ID = ASCompat.MAX_INT - 2;
	}

	public function onSummonClick(spr:FlxExtendedSprite, x:Int, y:Int) {
		trace("Attempting to summon HASTUR... currentLevel= " + Level.getCurrent());

		if (Std.is(Level.getCurrent() , CemeteryTotem)) {
			trace("SUMMON SUCCESSFUL!");
			close();
			Game.transitionToScene(new Outro());
			return;
		}

		trace("Failed, not in correct level");
		Level.getCurrent().showDialog(Clovis, "Hm, não aconteceu nada. Será que estou no lugar certo?");
	}

	public static function enable() {
		Level.getCurrent().ui.add(button);
	}

	function show() {
		trace("Opening book: ", this, this.scene);

		this.scene.invLayer.add(this);
		this._isOpen = true;

		setupSymbolGrid();

		button.loadGraphic(BUTTON_OPEN);
	}

	function hide() {
		trace("Hiding book: ", this, this.scene);

		this._isOpen = false;
		this.scene.invLayer.remove(this);

		clearSymbolGrid();

		button.loadGraphic(BUTTON);
	}

	function onButtonClick(btn:FlxExtendedSprite, x:Int, y:Int) {
		if (this._isOpen) {
			this.hide();
		} else {
			this.show();
		}
	}

	public static function showButton() {
		if (Std.is(Book.instance , Book)) {
			trace("[static] Enabling book button");
			Book.instance.addButton();
		} else {
			trace("[static] error: book not ready; book=" + Book.instance);
		}
	}

	/**
	 * Shows the book.
	 */
	public static function open() {
		if (Std.is(Book.instance , Book)) {
			trace("[static] Opening book");
			Book.instance.show();
		} else {
			trace("[static] error: book not ready to be open; book=" + Book.instance);
		}
	}

	/**
	 * Hides the book.
	 */
	public static function close() {
		if (Std.is(Book.instance , Book)) {
			trace("[static] Hiding book");
			Book.instance.hide();
		} else {
			trace("[static] error: book not ready to be hidden; book=" + Book.instance);
		}
	}

	/**
	 * Checks if the bookis open.
	 * @return Boolean
	 */
	public static function isOpen():Bool {
		return (Std.is(Book.instance , Book) && Book.instance._isOpen);
	}

	/**
	 * Checks if the mouse is over the book
	 * @return Boolean
	 */
	public static function isMouseOver():Bool {
		return (Book.isOpen() && Book.instance.background.mouseOver);
	}

}



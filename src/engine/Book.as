package engine {
	import chapters.Outro;

	import characters.Clovis;

	import engine.*;
	import engine.ui.UIButton;

	import flash.utils.getQualifiedClassName;

	import levels.CemeteryTotem;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Book extends FlxGroup {

		[Embed(source="../../assets/book_background.png")]
		public static var BACKGROUND:Class;

		[Embed(source="../../assets/book_icon.png")]
		public static var BUTTON:Class;

		[Embed(source="../../assets/book_icon.png")]
		public static var BUTTON_OPEN:Class;

		[Embed(source="../../assets/btn_summon_hastur.png")]
		public static var SUMMON_BTN:Class;

		public static var instance:Book;
		public static var button:FlxExtendedSprite;

		private var scene:Scene;
		public var background:FlxExtendedSprite;
		public var grid:FlxExtendedSprite;

		public var symbol1:FlxExtendedSprite;
		public var symbol2:FlxExtendedSprite;
		public var symbol3:FlxExtendedSprite;
		public var symbol4:FlxExtendedSprite;
		public var symbol5:FlxExtendedSprite;

		public var summonBtn:FlxExtendedSprite;

		public var isOpen:Boolean = false;

		public var position:Array = [0, 0];

		public function Book(scene:Scene) {

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

			background = new FlxExtendedSprite(position[0],position[1]);
			background.loadGraphic(BACKGROUND);

			add(background);
			add(grid);

			if(StoryLog.hasBook) {
				addButton();
			}
		}

		public function setupSymbolGrid():void {
			clearSymbolGrid();

			if(StoryLog.hasSymbol1) add(symbol1);
			if(StoryLog.hasSymbol2) add(symbol2);
			if(StoryLog.hasSymbol3) add(symbol3);
			if(StoryLog.hasSymbol4) add(symbol4);
			if(StoryLog.hasSymbol5) add(symbol5);

			if(StoryLog.hasAllSymbols()) {
				scene.ui.add(summonBtn);
				summonBtn.ID = 10000;
			}
		}

		public function clearSymbolGrid():void {
			scene.ui.remove(summonBtn);

			remove(symbol1);
			remove(symbol2);
			remove(symbol3);
			remove(symbol4);
			remove(symbol5);
		}

		public function addButton():void {
			trace("Button registered on scene: ", scene);
			scene.ui.add(button);
			button.ID = int.MAX_VALUE - 2;
		}

		public function onSummonClick(spr:FlxExtendedSprite, x:int, y:int):void {
			trace("Attempting to summon HASTUR... currentLevel= " + Level.getCurrent());

			if(Level.getCurrent() is CemeteryTotem) {
				trace("SUMMON SUCCESSFUL!");
				close();
				Game.transitionToScene(new Outro);
				return;
			}

			trace("Failed, not in correct level");
			Level.getCurrent().showDialog(Clovis, "Hm, não aconteceu nada. Será que estou no lugar certo?");
		}

		public static function enable():void {
			Level.getCurrent().ui.add(button);
		}

		private function show():void {
			trace("Opening book: ", this,  this.scene);

			this.scene.invLayer.add(this);
			this.isOpen = true;

			setupSymbolGrid();

			button.loadGraphic(BUTTON_OPEN);
		}

		private function hide():void {
			trace("Hiding book: ", this,  this.scene);

			this.isOpen = false;
			this.scene.invLayer.remove(this);

			clearSymbolGrid();

			button.loadGraphic(BUTTON);
		}

		private function onButtonClick(btn:FlxExtendedSprite, x:int, y:int):void {
			if(this.isOpen) {
				this.hide();
			} else {
				this.show();
			}
		}

		public static function showButton():void {
			if(Book.instance is Book) {
				trace("[static] Enabling book button");
				Book.instance.addButton();
			} else {
				trace("[static] error: book not ready; book=" + Book.instance);
			}
		}

		/**
		 * Shows the book.
		 */
		public static function open():void {
			if(Book.instance is Book) {
				trace("[static] Opening book");
				Book.instance.show();
			} else {
				trace("[static] error: book not ready to be open; book=" + Book.instance);
			}
		}

		/**
		 * Hides the book.
		 */
		public static function close():void {
			if(Book.instance is Book) {
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
		public static function isOpen():Boolean {
			return (Book.instance is Book && Book.instance.isOpen);
		}

		/**
		 * Checks if the mouse is over the book
		 * @return Boolean
		 */
		public static function isMouseOver():Boolean {
			return (Book.isOpen() && Book.instance.background.mouseOver);
		}

	}

}

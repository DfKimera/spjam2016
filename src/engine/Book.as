package engine {
	import engine.*;

	import flash.utils.getQualifiedClassName;

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

		public static var instance:Book;
		public static var button:FlxExtendedSprite;

		private var scene:Scene;
		public var background:FlxExtendedSprite;

		public var isOpen:Boolean = false;

		public var position:Array = [0, 0];

		public function Book(scene:Scene) {

			instance = this;

			button = new FlxExtendedSprite(FlxG.width - 100, FlxG.height - 200);
			button.loadGraphic(BUTTON);
			button.mouseReleasedCallback = this.onButtonClick;

			if(StoryLog.hasBook) {
				scene.ui.add(button);
			}

			button.ID = int.MAX_VALUE - 2;

			this.scene = scene;

			trace("Button registered on scene: ", scene);

			background = new FlxExtendedSprite(position[0],position[1]);
			background.loadGraphic(BACKGROUND);

			add(background);
		}

		public static function enable():void {
			Level.getCurrent().ui.add(button);
		}

		private function show():void {
			trace("Opening book: ", this,  this.scene);
			this.isOpen = true;
			button.loadGraphic(BUTTON_OPEN);
		}

		private function hide():void {
			trace("Hiding book: ", this,  this.scene);
			this.isOpen = false;
			button.loadGraphic(BUTTON);
		}

		private function onButtonClick(btn:FlxExtendedSprite, x:int, y:int):void {
			if(this.isOpen) {
				this.hide();
			} else {
				this.show();
			}
		}

		/**
		 * Shows the book.
		 */
		public static function show():void {
			if(Book.instance is Book) {
				Book.instance.show();
			}
		}

		/**
		 * Hides the book.
		 */
		public static function hide():void {
			if(Book.instance is Book) {
				Book.instance.hide();
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

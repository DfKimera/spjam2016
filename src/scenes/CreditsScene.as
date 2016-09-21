package scenes {

	import engine.Cursor;
	import engine.InteractiveArea;
	import engine.SFX;
	import engine.Scene;
	import engine.UIScene;

	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	public class CreditsScene extends Scene {

		[Embed(source="../../assets/credits_screen.png")]
		public var BACKGROUND_SPRITE:Class;

		public var gump:FlxSprite;

		public function CreditsScene():void {
			StoryLog.reset();
			super();
		}

		public override function create():void {
			super.create();

			InteractiveArea.placeOnScene(this, "back_to_menu", 0, 0, 800, 600, backToMenu);
			InteractiveArea.placeOnScene(this, "easter_egg", 620, 400, 100, 100, onXeroxClick);
		}

		public override function prepare():void {
			super.prepare();

			setBackground(BACKGROUND_SPRITE);
			Game.playMusic("griefing_gunners");
		}

		public override function update():void {
			super.update();
			Cursor.useSkip();
		}

		public function backToMenu(area:InteractiveArea):void {
			trace("Going back to menu");
			Game.goToMainMenu();
		}

		protected override function hasInventoryEnabled():Boolean {
			return false;
		}

		public function onXeroxClick(area:InteractiveArea):void {
			trace("Elementar, meu caro Epson!");

			SFX.play("taunt");

			gump = new FlxSprite(900, 290, Assets.GUMP);
			gump.acceleration = new FlxPoint(-150, 25);
			add(gump);
		}

	}
}

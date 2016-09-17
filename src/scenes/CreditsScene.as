package scenes {

	import engine.Cursor;
	import engine.UIScene;

	import org.flixel.FlxG;

	public class CreditsScene extends UIScene {

		[Embed(source="../../assets/credits_screen.png")]
		public var BACKGROUND_SPRITE:Class;

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
			Game.playMusic("griefing_gunners");
		}

		public override function update():void {
			super.update();

			Cursor.useSkip();

			if(FlxG.keys.any() || FlxG.mouse.justPressed()) {
				Game.goToMainMenu();
			}
		}

	}
}

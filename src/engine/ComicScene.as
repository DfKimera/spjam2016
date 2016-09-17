package engine {

	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class ComicScene extends UIScene {

		public var pages:Array = [];
		public var comic:FlxSprite;
		public var transitioning:Boolean = false;

		public override function create():void {
			super.create();

			comic = new FlxSprite(0, 0);
			comic.loadGraphic(pages.shift());
			add(comic);
		}

		public function nextPage():void {
			transitioning = true;
			Utils.fadeOut(comic, Config.SCENE_FADE_DELAY, function():void {

				if(pages.length <= 0) {
					onFinish();
					return;
				}

				comic.loadGraphic(pages.shift());
				Utils.fadeIn(comic, Config.SCENE_FADE_DELAY, function():void {
					transitioning = false;
				});
			});
		}

		public function onFinish():void {}

		public override function update():void {
			super.update();

			Cursor.useSkip();

			if(FlxG.keys.any() || FlxG.mouse.justPressed()) {
				if(!transitioning) {
					nextPage();
				}
			}
		}

	}
}

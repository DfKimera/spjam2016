package engine ;

import org.flixel.FlxG;
import org.flixel.FlxSprite;

 class ComicScene extends UIScene {

	public var pages:Array<ASAny> = [];
	public var comic:FlxSprite;
	public var transitioning:Bool = false;

	public override function create() {
		super.create();

		comic = new FlxSprite(0, 0);
		comic.loadGraphic(pages.shift());
		add(comic);
	}

	public function nextPage() {
		transitioning = true;
		Utils.fadeOut(comic, Config.SCENE_FADE_DELAY, function () {

			if (pages.length <= 0) {
				onFinish();
				return;
			}

			comic.loadGraphic(pages.shift());
			Utils.fadeIn(comic, Config.SCENE_FADE_DELAY, function () {
				transitioning = false;
			});
		});
	}

	public function onFinish() {
	}

	public override function update() {
		super.update();

		Cursor.useSkip();

		if (FlxG.keys.any() || FlxG.mouse.justPressed()) {
			if (!transitioning) {
				nextPage();
			}
		}
	}

}


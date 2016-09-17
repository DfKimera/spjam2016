package engine {
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Background extends FlxExtendedSprite {

		public var scene:Scene;

		public function Background(bitmap:Class, scene:Scene) {
			loadGraphic(bitmap, false, false, 800, 600, false);
			this.mouseReleasedCallback = this.onClicked;
			this.scene = scene;
		}

		private function onClicked(spr:FlxExtendedSprite, x:int, y:int):void {
			this.scene._onBackgroundClick(x, y);
			this.scene.onBackgroundClick(x, y);
		}
	}
}

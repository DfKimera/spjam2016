package engine ;
import org.flixel.plugin.photonstorm.FlxExtendedSprite;

 class Background extends FlxExtendedSprite {

	public var scene:Scene;

	public function new(bitmap:String, scene:Scene) {
		super();
		loadGraphic(bitmap, false, false, 800, 600, false);
		this.mouseReleasedCallback = this.onClicked;
		this.scene = scene;
	}

	function onClicked(spr:FlxExtendedSprite, x:Int, y:Int) {
		this.scene._onBackgroundClick(x, y);
		this.scene.onBackgroundClick(x, y);
	}
}


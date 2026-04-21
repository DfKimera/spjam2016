package engine ;

import org.flixel.FlxG;

 class UIScene extends Scene {

	public override function update() {
		if (!isReady) {
			return;
		}
		if (FlxG.keys.justPressed("ESCAPE")) {
			Game.goToMainMenu();
		}
	}

	override function hasInventoryEnabled():Bool {
		return false;
	}

}


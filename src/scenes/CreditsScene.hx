package scenes ;

import engine.Cursor;
import engine.InteractiveArea;
import engine.SFX;
import engine.Scene;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;

 class CreditsScene extends Scene {

	public var BACKGROUND_SPRITE:String = "assets/credits_screen.png";

	public var gump:FlxSprite;

	public function new(){
		StoryLog.reset();
		super();
	}

	public override function create() {
		super.create();

		InteractiveArea.placeOnScene(this, "back_to_menu", 0, 0, 800, 600, backToMenu);
		InteractiveArea.placeOnScene(this, "easter_egg", 620, 400, 100, 100, onXeroxClick);
	}

	public override function prepare() {
		super.prepare();

		setBackground(BACKGROUND_SPRITE);
		Game.playMusic("griefing_gunners");
	}

	public override function update() {
		super.update();
		Cursor.useSkip();
	}

	public function backToMenu(area:InteractiveArea) {
		trace("Going back to menu");
		Game.goToMainMenu();
	}

	override function hasInventoryEnabled():Bool {
		return false;
	}

	public function onXeroxClick(area:InteractiveArea) {
		trace("Elementar, meu caro Epson!");

		SFX.play("taunt");

		gump = new FlxSprite(900, 290, Assets.GUMP);
		gump.acceleration = new FlxPoint(-150, 25);
		add(gump);
	}

}


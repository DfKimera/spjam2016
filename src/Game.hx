 

import chapters.Intro;

import engine.Cursor;
import engine.Dialog;

import flash.system.Security;

import org.flixel.FlxG;
import org.flixel.FlxGame;
import org.flixel.FlxState;
import org.flixel.plugin.photonstorm.FlxMouseControl;

import scenes.CreditsScene;

 class Game extends FlxGame {

	public static var instance:Game;

	public static var currentBGM:String = null;

	public function new() {

		Security.allowDomain("*");

		Game.instance = this;

		super(800, 600, Menu, 1, 60, 30, false);

		Cursor.useArrow();

		if (FlxG.getPlugin(FlxMouseControl) == null) {
			FlxG.addPlugin(new FlxMouseControl());
		}

	}

	override function update() {
		Cursor.reset();
		super.update();
		Cursor.update();
	}

	/**
	 * Switches to the main menu
	 */
	public static function goToMainMenu() {
		Game.transitionToScene(new Menu());
	}

	/**
	 * Switches to the game's starting scene
	 */
	public static function start() {
		Game.transitionToScene(new Intro());
	}

	/**
	 * Switches to the settings menu
	 */
	public static function openSettings() {
		Game.transitionToScene(new Settings());
	}

	/**
	 * Switches to the credits scene
	 */
	public static function openCredits() {
		Game.transitionToScene(new CreditsScene());
	}

	/**
	 * Plays a background music
	 * @param name String
	 */
	public static function playMusic(name:String) {
		trace("Playing BGM: ", name);
		if (currentBGM == name) {
			trace("Already plahing BGM: ", name);
			return;
		}
		currentBGM = name;

		var bgm:String = (Assets : ASAny)["BGM_" + name.toUpperCase()];
		if (bgm == null) {
			trace("Invalid BGM! ", name, bgm);
			return;
		}

		FlxG.playMusic(bgm, 1);
	}

	/**
	 * Transitions the game to another scene.
	 * @param scene Scene The scene instance.
	 * @param delay Number The transition delay, in seconds.
	 */
	public static function transitionToScene(scene:FlxState, delay:Float = Config.SCENE_FADE_DELAY) {
		trace("------------------ END SCENE ---------------------");
		Dialog.clearAll();
		FlxG.fade(0xff000000, delay, function () {
			FlxG.switchState(scene);
		});
	}

	public static function setArrowCursor() {
		FlxG.mouse.load()
;	}

}


package engine ;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSound;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxTimer;
import org.flixel.plugin.photonstorm.FlxExtendedSprite;

 class Dialog extends FlxGroup {

	@:meta(Embed(source="../../assets/Merriweather-Regular.ttf", fontFamily="merriweather", embedAsCFF="false"))
	public static var FONT_SERIF:Class<Dynamic>;

	@:meta(Embed(source="../../assets/Raleway-Regular.ttf", fontFamily="raleway", embedAsCFF="false"))
	public static var FONT_GENERIC:Class<Dynamic>;

	var BACKGROUND_TOP:String = "assets/character_dialog_box.png";
	var BACKGROUND_BOTTOM:String = "assets/character_dialog_box_bottom.png";

	public var isActive:Bool = false;
	public var isCompleted:Bool = false;
	public var scene:Scene;

	public var character:Character;
	public var message:String;
	public var expression:String;
	public var position:String;

	var fxTimer:FlxTimer = new FlxTimer();
	var fxDisplay:String;
	var fxBuffer:Array<ASAny>;

	public var offsetY:Int = 0;

	public var background:FlxExtendedSprite;
	public var portrait:FlxSprite;
	public var portraitOffset:Array<ASAny> = [-20, 130];

	public var title:FlxText;
	public var titleOffset:Array<ASAny> = [15, 10, 500];

	public var text:FlxText;
	public var textOffset:Array<ASAny> = [15, 55, 500];

	static var currentSFX:FlxSound = null;
	var soundToPlay:String = null;

	public var onCloseCallback:ASFunction = null;

	public function new(scene:Scene, character:Character, message:String, expression:String = "default", position:String = "bottom") {
		super();

		trace("Dialog: ", scene, character, message, expression);

		this.scene = scene;
		this.character = character;
		this.message = message;
		this.position = position;

		this.fxDisplay = "";
		this.fxBuffer = Utils.reverseArray((cast message.split('')));

		this.expression = expression;
		this.offsetY = (this.position == "bottom") ? (FlxG.height - 130) : 0;

		var sprite= (this.position == "bottom") ? BACKGROUND_BOTTOM : BACKGROUND_TOP;

		if (Config.ENABLE_PORTRAITS) {
			portrait = character.getPortrait(expression);
			resetPortraitPosition();
			add(portrait);
		}

		background = new FlxExtendedSprite(0, 0);
		background.loadGraphic(sprite, false, false, 800, 600);
		background.mouseReleasedCallback = this.skipDialog;
		add(background);
		background.ID = ASCompat.MAX_INT - 2;

		title = new FlxText(titleOffset[0], ASCompat.toNumber(titleOffset[1]) + offsetY, titleOffset[2], character.characterName);
		title.setFormat("merriweather", 18, character.textColor, "left", 0xFF000000);
		add(title);

		text = new FlxText(textOffset[0], ASCompat.toNumber(textOffset[1]) + offsetY, textOffset[2], "");
		text.setFormat("merriweather", 14, 0xFFFFFF, "left", 0xFF000000);
		add(text);


	}

	function resetPortraitPosition() {
		if (!Config.ENABLE_PORTRAITS) {
			return;
		}

		portrait.x = FlxG.stage.width - portrait.width - ASCompat.toNumber(portraitOffset[0]);
		portrait.y = ASCompat.toNumber(portraitOffset[1]) + offsetY;
		portrait.y = portrait.y - portrait.height;
	}

	public function sound(name:String):Dialog {
		soundToPlay = name;
		return this;
	}

	public override function update() {

		super.update();

		if (background.mouseOver) {
			Cursor.useSkip();
		}

		if ((FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE")) && isActive) {
			this.skipDialog();
		}

	}

	public function skipDialog(spr:FlxExtendedSprite = null, x:Int = 0, y:Int = 0) {

		if (!isCompleted) {
			this.completeMessage();
			return;
		}

		SFX.play("pick");

		isActive = false;
		var dialog= this;

		Utils.fadeOutGroup(dialog, Config.DIALOG_FADE_DELAY, function () {
			scene.ui.remove(dialog);
			openDialog = null;

			if (Reflect.isFunction(dialog.onCloseCallback )) {
				dialog.onCloseCallback();
			}

			Dialog.advanceQueue();

			dialog.kill();
			dialog.destroy();
		});
	}

	public function completeMessage() {
		this.fxDisplay = this.message;
		this.text.text = this.fxDisplay;
		this.isCompleted = true;
		this.fxTimer.stop();
		SFX.play("click");
	}

	function displayMoreCharacters(timer:FlxTimer = null) {
		if (this.fxBuffer.length > 0) {
			this.fxDisplay += this.fxBuffer.pop();
			this.text.text = this.fxDisplay;
		} else {
			this.completeMessage();
		}

	}

	public override function kill() {
		isActive = false;

		if (portrait != null) {
			this.remove(portrait);
		}

		portrait = null;

		super.kill();
	}

	function _show() {
		if (Config.ENABLE_PORTRAITS) {
			resetPortraitPosition();
		}

		scene.dialog.add(this);
		isActive = true;
		fxTimer.start(Config.DIALOG_CHARACTER_DELAY, 0, this.displayMoreCharacters);
	}

	// -------------------------------------------------------------------------------------------------------------

	public static var openDialog:Dialog = null;
	public static var dialogQueue:Vector<Dialog> = new Vector();

	/**
	 * Shows a dialog box.
	 * @param scene Scene The scene to display on.
	 * @param character Character The talking character.
	 * @param message String The dialog message.
	 * @param expression String The character's portrait expression (as defined on the character).
	 * @param position String The box position ("top" or "bottom")
	 * @return Dialog
	 */
	public static function show(scene:Scene, character:Character, message:String, expression:String = "default", position:String = "bottom"):Dialog {
		var dialog= new Dialog(scene, character, message, expression, position);

		if (openDialog != null) {
			trace("Added dialog to queue: ", dialog);
			dialogQueue.push(dialog);
		} else {
			Dialog.showDialog(dialog);
		}

		return dialog;
	}

	public static function showDialog(dialog:Dialog) {
		openDialog = dialog;

		dialog.setAll("alpha", 0);
		dialog._show();

		ASCompat.setTimeout(function () {
			if (dialog.soundToPlay != null) {
				if (Std.is(Dialog.currentSFX , FlxSound)) {
					Dialog.currentSFX.stop();
				}
				Dialog.currentSFX = dialog.character.playSound(dialog.soundToPlay);
			}
		}, 1);

		Utils.fadeInGroup(dialog, Config.DIALOG_FADE_DELAY);
	}

	static function advanceQueue() {

		if (dialogQueue.length > 0) {
			var dialog= dialogQueue.shift();
			trace("Showing dialog from queue: ", dialog, "(" + dialogQueue.length + " left in queue)");

			Dialog.showDialog(dialog);
		}

	}

	/**
	 * Checks if there are any pending dialogs waiting to be displayed
	 * @return Boolean
	 */
	public static function isPending():Bool {
		return (Dialog.dialogQueue.length > 0) || Std.is(openDialog , Dialog);
	}

	/**
	 * Clears the dialog box queue
	 */
	public static function clearAll() {

		if (Std.is(openDialog , Dialog)) {
			openDialog.fxTimer.stop();
			openDialog.fxTimer.destroy();
			openDialog.kill();
			openDialog.destroy();
		}

		openDialog = null;
		Dialog.dialogQueue = new Vector<Dialog>();

		trace("Dialog: cleared all dialog boxes from queue");
	}

	public static function Quick(scene:Scene, characterClass:Class<Dynamic>, message:String, expression:String = "default", position:String = "bottom"):ASFunction {
		return function () {
			Dialog.show(scene, Type.createInstance(characterClass, []), message, expression, position);
		}
;	}


}


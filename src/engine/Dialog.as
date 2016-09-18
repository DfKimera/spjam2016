package engine {

	import flash.utils.setTimeout;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTimer;
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Dialog extends FlxGroup {

		[Embed(source="../../assets/Merriweather-Regular.ttf", fontFamily="merriweather", embedAsCFF="false")]
		public static var FONT_SERIF:Class;

		[Embed(source="../../assets/Raleway-Regular.ttf", fontFamily="raleway", embedAsCFF="false")]
		public static var FONT_GENERIC:Class;

		[Embed(source="../../assets/character_dialog_box.png")]
		private var BACKGROUND_TOP:Class;

		[Embed(source="../../assets/character_dialog_box_bottom.png")]
		private var BACKGROUND_BOTTOM:Class;

		public var isActive:Boolean = false;
		public var isCompleted:Boolean = false;
		public var scene:Scene;

		public var character:Character;
		public var message:String;
		public var expression:String;
		public var position:String;

		private var fxTimer:FlxTimer = new FlxTimer();
		private var fxDisplay:String;
		private var fxBuffer:Array;

		public var offsetY:int = 0;

		public var background:FlxExtendedSprite;
		public var portrait:FlxSprite;
		public var portraitOffset:Array = [-20, 130];

		public var title:FlxText;
		public var titleOffset:Array = [15, 10, 500];

		public var text:FlxText;
		public var textOffset:Array = [15, 55, 500];

		private static var currentSFX:FlxSound = null;
		private var soundToPlay:String = null;

		public var onCloseCallback:Function = null;

		public function Dialog(scene:Scene, character:Character, message:String, expression:String = "default", position:String = "bottom") {

			trace("Dialog: ", scene, character, message, expression);

			this.scene = scene;
			this.character = character;
			this.message = message;
			this.position = position;

			this.fxDisplay = "";
			this.fxBuffer = message.split('').reverse();

			this.expression = expression;
			this.offsetY = (this.position == "bottom") ? (FlxG.height - 130) : 0;

			var sprite:Class = (this.position == "bottom") ? BACKGROUND_BOTTOM : BACKGROUND_TOP;

			if(Config.ENABLE_PORTRAITS) {
				portrait = character.getPortrait(expression);
				resetPortraitPosition();
				add(portrait);
			}

			background = new FlxExtendedSprite(0, 0);
			background.loadGraphic(sprite, false, false, 800, 600);
			background.mouseReleasedCallback = this.skipDialog;
			add(background);
			background.ID = int.MAX_VALUE-2;

			title = new FlxText(titleOffset[0], titleOffset[1] + offsetY, titleOffset[2], character.characterName);
			title.setFormat("merriweather", 18, character.textColor, "left", 0xFF000000);
			add(title);

			text = new FlxText(textOffset[0], textOffset[1] + offsetY, textOffset[2], "");
			text.setFormat("merriweather", 14, 0xFFFFFF, "left", 0xFF000000);
			add(text);


		}

		private function resetPortraitPosition():void {
			if(!Config.ENABLE_PORTRAITS) return;

			portrait.x = FlxG.stage.width - portrait.width - portraitOffset[0];
			portrait.y = portraitOffset[1] + offsetY;
			portrait.y -= portrait.height;
		}

		public function sound(name:String):Dialog {
			soundToPlay = name;
			return this;
		}

		public override function update():void {

			super.update();

			if(background.mouseOver) {
				Cursor.useSkip();
			}

			if((FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE")) && isActive) {
				this.skipDialog();
			}

		}

		public function skipDialog(spr:FlxExtendedSprite = null, x:int = 0, y:int = 0):void {

			if(!isCompleted) {
				this.completeMessage();
				return;
			}

			SFX.play("pick");

			isActive = false;
			var dialog:Dialog = this;

			Utils.fadeOutGroup(dialog, Config.DIALOG_FADE_DELAY, function():void {
				scene.ui.remove(dialog);
				openDialog = null;

				if(dialog.onCloseCallback is Function) {
					dialog.onCloseCallback.apply();
				}

				Dialog.advanceQueue();

				dialog.kill();
				dialog.destroy();
			});
		}

		public function completeMessage():void {
			this.fxDisplay = this.message;
			this.text.text = this.fxDisplay;
			this.isCompleted = true;
			this.fxTimer.stop();
			SFX.play("click");
		}

		private function displayMoreCharacters(timer:FlxTimer = null):void {
			if(this.fxBuffer.length > 0) {
				this.fxDisplay += this.fxBuffer.pop();
				this.text.text = this.fxDisplay;
			} else {
				this.completeMessage();
			}

		}

		public override function kill():void {
			isActive = false;

			if(portrait) {
				this.remove(portrait);
			}

			portrait = null;

			super.kill();
		}

		private function show():void {
			if(Config.ENABLE_PORTRAITS) {
				resetPortraitPosition();
			}

			scene.dialog.add(this);
			isActive = true;
			fxTimer.start(Config.DIALOG_CHARACTER_DELAY, 0, this.displayMoreCharacters);
		}

		// -------------------------------------------------------------------------------------------------------------

		public static var openDialog:Dialog = null;
		public static var dialogQueue:Vector.<Dialog> = new Vector.<Dialog>();

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
			var dialog:Dialog = new Dialog(scene,  character, message, expression, position);

			if(openDialog != null) {
				trace("Added dialog to queue: ", dialog);
				dialogQueue.push(dialog);
			} else {
				Dialog.showDialog(dialog);
			}

			return dialog;
		}

		public static function showDialog(dialog:Dialog):void {
			openDialog = dialog;

			dialog.setAll("alpha", 0);
			dialog.show();

			setTimeout(function():void {
				if(dialog.soundToPlay != null) {
					if(Dialog.currentSFX is FlxSound) {
						Dialog.currentSFX.stop();
					}
					Dialog.currentSFX = dialog.character.playSound(dialog.soundToPlay);
				}
			}, 1);

			Utils.fadeInGroup(dialog, Config.DIALOG_FADE_DELAY);
		}

		private static function advanceQueue():void {

			if(dialogQueue.length > 0) {
				var dialog:Dialog = dialogQueue.shift();
				trace("Showing dialog from queue: ", dialog, "("+dialogQueue.length+" left in queue)");

				Dialog.showDialog(dialog);
			}

		}

		/**
		 * Checks if there are any pending dialogs waiting to be displayed
		 * @return Boolean
		 */
		public static function isPending():Boolean {
			return (Dialog.dialogQueue.length > 0) || (openDialog is Dialog);
		}

		/**
		 * Clears the dialog box queue
		 */
		public static function clearAll():void {

			if(openDialog is Dialog) {
				openDialog.fxTimer.stop();
				openDialog.fxTimer.destroy();
				openDialog.kill();
				openDialog.destroy();
			}

			openDialog = null;
			Dialog.dialogQueue = new Vector.<Dialog>();

			trace("Dialog: cleared all dialog boxes from queue");
		}


	}
}

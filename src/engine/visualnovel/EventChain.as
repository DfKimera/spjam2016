package engine.visualnovel {
	import engine.Cursor;
	import engine.Dialog;
	import engine.Scene;

	import org.flixel.FlxG;

	import org.flixel.FlxSprite;

	public class EventChain {

		public var isActive:Boolean = false;
		public var events:Array = [];
		public var scene:Scene;

		public var currentEvent:Event;
		public var currentQuestion:Question;
		public var currentDialog:Dialog;

		public var transitioning:Boolean = false;

		public var onFinishCallback:Function = null;

		public function EventChain(scene:Scene, onFinishCallback:Function = null):void {
			this.scene = scene;
			this.onFinishCallback = onFinishCallback;
		}

		public function start():void {
			isActive = true;
			nextEvent();
		}

		public function addEvent(event:Event):EventChain {
			events.push(event);
			return this;
		}

		public function addQuestion(title:String):Question {
			var event:Event = (new Event()).setEventChain(this);
			var question:Question = event.question(title);

			events.push(event);

			return question;
		}

		public function addDialog(characterClass:Class, message:String, expression:String = "default", position:String = "bottom"):EventChain {
			this.addEvent(Event.newDialog(this, characterClass, message, expression, position));
			return this;
		}

		public function addBreak():EventChain {
			this.addEvent(Event.newBreak(this).setDeactivateChain(true));
			return this;
		}

		public function nextEvent():void {
			if(!isActive) return;

			if(currentEvent) {
				currentEvent.finish();
			}

			currentQuestion = null;
			currentDialog = null;

			var event:Event = events.shift();

			if(!event) {
				trace("No more events, finished!");
				onFinish();
				return;
			}

			trace("--> Event", event);
			currentEvent = event;

			if(event.newBackground != null) { displayBackground(event.newBackground); }
			if(event.newBGM != null) { Game.playMusic(event.newBGM); }
			if(event.newDialog != null) { displayDialog(event.newDialog); }
			if(event.newQuestion != null) { displayQuestion(event.newQuestion); }

			if(event.deactivateChain) {
				trace("[deactivating chain] ", this);
				isActive = false;
			}

			if(event.doLoadNext) {
				trace("[event has load next]");
				nextEvent();
			}
		}

		public function displayBackground(newBackground:Class):void {
			transitioning = true;

			Utils.fadeOut(scene.background, Config.SCENE_FADE_DELAY, function():void {

				scene.background.loadGraphic(newBackground);

				Utils.fadeIn(scene.background, Config.SCENE_FADE_DELAY, function():void {
					transitioning = false;
				});

			});
		}

		public function displayDialog(dialog:Dialog):void {
			if(currentDialog && currentDialog.isActive) {
				currentDialog.kill();
			}

			currentDialog = dialog;
			Dialog.showDialog(dialog);
		}

		public function displayQuestion(question:Question):void {
			if(currentQuestion) {
				currentQuestion.kill();
			}

			currentQuestion = question;
			scene.add(question);
		}

		public function onFinish():void {
			isActive = false;

			if(this.onFinishCallback is Function) {
				this.onFinishCallback.call();
			}
		}

		public function update():void {

			if(!isActive) return;

			Cursor.useSkip();

			if(currentQuestion) {
				Cursor.useArrow();
			}

			if(FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("ENTER") || FlxG.mouse.justPressed()) {
				if(transitioning) { return; }
				if(currentQuestion) { return; }
				if(currentDialog && currentDialog.isActive && !currentDialog.isCompleted) { return; }

				nextEvent();
			}
		}

		public static function create(scene:Scene, onFinishCallback:Function = null):EventChain {
			return (new EventChain(scene, onFinishCallback));
		}
	}
}

package engine.visualnovel ;

import engine.Cursor;
import engine.Dialog;
import engine.Scene;

import org.flixel.FlxG;

 class EventChain {

	public var isActive:Bool = false;
	public var events:Array<ASAny> = [];
	public var scene:Scene;

	public var currentEvent:Event;
	public var currentQuestion:Question;
	public var currentDialog:Dialog;

	public var transitioning:Bool = false;

	public var onFinishCallback:ASFunction = null;

	public function new(scene:Scene, onFinishCallback:ASFunction = null){
		this.scene = scene;
		this.onFinishCallback = onFinishCallback;
	}

	public function start() {
		isActive = true;
		nextEvent();
	}

	public function addEvent(event:Event):EventChain {
		events.push(event);
		return this;
	}

	public function addQuestion(title:String):Question {
		var event= new Event().setEventChain(this);
		var question= event.question(title);

		events.push(event);

		return question;
	}

	public function addDialog(characterClass:Class<Dynamic>, message:String, expression:String = "default", position:String = "bottom"):EventChain {
		this.addEvent(Event.newDialog(this, characterClass, message, expression, position));
		return this;
	}

	public function addBreak():EventChain {
		this.addEvent(Event.newBreak(this).setDeactivateChain(true));
		return this;
	}

	public function addBackground(background:String):EventChain {
		this.addEvent(Event.newBackground(this, background));
		return this;
	}

	public function addCallback(callback:ASFunction, deactivateChain:Bool = false):EventChain {
		this.addEvent(Event.newCallback(this, callback).setDeactivateChain(deactivateChain));
		return this;
	}

	public function nextEvent() {
		if (!isActive) {
			return;
		}

		if (currentEvent != null) {
			currentEvent.finish();
		}

		currentQuestion = null;
		currentDialog = null;

		var event:Event = events.shift();

		if (event == null) {
			trace("No more events, finished!");
			onFinish();
			return;
		}

		trace("--> Event", event);
		currentEvent = event;

		if (event._newBackground != null) {
			displayBackground(event._newBackground);
		}
		if (event._newBGM != null) {
			Game.playMusic(event._newBGM);
		}
		if (event._newDialog != null) {
			displayDialog(event._newDialog);
		}
		if (event._newQuestion != null) {
			displayQuestion(event._newQuestion);
		}

		if (event._deactivateChain) {
			trace("[deactivating chain] ", this);
			isActive = false;
		}

		if (event._callback != null) {
			event._callback();
		}

		if (event._doLoadNext) {
			trace("[event has load next]");
			nextEvent();
		}
	}

	public function displayBackground(newBackground:String) {
		transitioning = true;

		Utils.fadeOut(scene.background, Config.SCENE_FADE_DELAY, function () {

			scene.background.loadGraphic(newBackground);

			Utils.fadeIn(scene.background, Config.SCENE_FADE_DELAY, function () {
				transitioning = false;
			});

		});
	}

	public function displayDialog(dialog:Dialog) {
		if (currentDialog != null && currentDialog.isActive) {
			currentDialog.kill();
		}

		currentDialog = dialog;
		Dialog.showDialog(dialog);
	}

	public function displayQuestion(question:Question) {
		if (currentQuestion != null) {
			currentQuestion.kill();
		}

		currentQuestion = question;
		scene.add(question);
	}

	public function onFinish() {
		isActive = false;

		if (Reflect.isFunction(this.onFinishCallback )) {
			this.onFinishCallback();
		}
	}

	public function update() {

		if (!isActive) {
			return;
		}

		Cursor.useSkip();

		if (currentQuestion != null) {
			Cursor.useArrow();
		}

		if (FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("ENTER") || FlxG.mouse.justPressed()) {
			if (transitioning) {
				return;
			}
			if (currentQuestion != null) {
				return;
			}
			if (currentDialog != null && currentDialog.isActive && !currentDialog.isCompleted) {
				return;
			}

			nextEvent();
		}
	}

	public static function create(scene:Scene, onFinishCallback:ASFunction = null):EventChain {
		return new EventChain(scene, onFinishCallback);
	}
}


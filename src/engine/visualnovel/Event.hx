package engine.visualnovel ;

import engine.Dialog;

 class Event {

	public var _eventChain:EventChain = null;
	public var _newBackground:String = null;
	public var _newBGM:String = null;
	public var _newDialog:Dialog = null;
	public var _newQuestion:Question = null;
	public var _callback:ASFunction = null;

	public var _doLoadNext:Bool = false;
	public var _deactivateChain:Bool = false;

	public function background(background:String):Event {
		this._newBackground = background;
		return this;
	}

	public function bgm(bgm:String):Event {
		this._newBGM = bgm;
		return this;
	}

	public function dialog(charClass:Class<Dynamic>, message:String, expression:String = "default", position:String = "bottom"):Event {
		this._newDialog = new Dialog(_eventChain.scene, Type.createInstance(charClass, []), message, expression, position);
		return this;
	}

	public function question(title:String):Question {
		this._newQuestion = new Question(title, Config.QUESTION_POSITION.x, Config.QUESTION_POSITION.y);
		return this._newQuestion;
	}

	public function finish() {
		if (this._newQuestion != null) {
			this._eventChain.scene.remove(this._newQuestion);
			this._newQuestion.kill();
		}
	}

	public function setEventChain(chain:EventChain):Event {
		this._eventChain = chain;
		return this;
	}

	public function loadNext():Event {
		this._doLoadNext = true;
		return this;
	}

	public function setDeactivateChain(deactivate:Bool = true):Event {
		this._deactivateChain = deactivate;
		return this;
	}

	public function setCallback(callback:ASFunction):Event {
		this._callback = callback;
		return this;
	}

	public static function newBackground(chain:EventChain, background:String):Event {
		return new Event().setEventChain(chain).background(background);
	}

	public static function newBGM(chain:EventChain, bgm:String):Event {
		return new Event().setEventChain(chain).bgm(bgm);
	}

	public static function newDialog(chain:EventChain, charClass:Class<Dynamic>, message:String, expression:String = "default", position:String = "bottom"):Event {
		return new Event().setEventChain(chain).dialog(charClass, message, expression, position);
	}

	public static function newBreak(chain:EventChain):Event {
		return new Event().setEventChain(chain).setDeactivateChain(true);
	}

	public static function newCallback(chain:EventChain, callback:ASFunction):Event {
		return new Event().setEventChain(chain).setCallback(callback);
	}

	public function toString():String {
		return "[Event: bg=" + _newBackground + ", bgm=" + _newBGM + ", dialog=" + _newDialog + ", question=" + _newQuestion + "]";
	}
public function new(){}

}


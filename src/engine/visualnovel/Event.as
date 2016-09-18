package engine.visualnovel {
	import engine.Dialog;

	public class Event {

		public var eventChain:EventChain = null;
		public var newBackground:Class = null;
		public var newBGM:String = null;
		public var newDialog:Dialog = null;
		public var newQuestion:Question = null;
		public var callback:Function = null;

		public var doLoadNext:Boolean = false;
		public var deactivateChain:Boolean = false;

		public function background(background:Class):Event {
			this.newBackground = background;
			return this;
		}

		public function bgm(bgm:String):Event {
			this.newBGM = bgm;
			return this;
		}

		public function dialog(charClass:Class, message:String, expression:String = "default", position:String = "bottom"):Event {
			this.newDialog = new Dialog(eventChain.scene, new charClass, message, expression, position);
			return this;
		}

		public function question(title:String):Question {
			this.newQuestion = new Question(title, Config.QUESTION_POSITION.x, Config.QUESTION_POSITION.y);
			return this.newQuestion;
		}

		public function finish():void {
			if(this.newQuestion) {
				this.eventChain.scene.remove(this.newQuestion);
				this.newQuestion.kill();
			}
		}

		public function setEventChain(chain:EventChain):Event {
			this.eventChain = chain;
			return this;
		}

		public function loadNext():Event {
			this.doLoadNext = true;
			return this;
		}

		public function setDeactivateChain(deactivate:Boolean = true):Event {
			this.deactivateChain = deactivate;
			return this;
		}

		public function setCallback(callback:Function):Event {
			this.callback = callback;
			return this;
		}

		public static function newBackground(chain:EventChain, background:Class):Event {
			return (new Event()).setEventChain(chain).background(background);
		}

		public static function newBGM(chain:EventChain, bgm:String):Event {
			return (new Event()).setEventChain(chain).bgm(bgm);
		}

		public static function newDialog(chain:EventChain, charClass:Class, message:String, expression:String = "default", position:String = "bottom"):Event {
			return (new Event()).setEventChain(chain).dialog(charClass, message, expression, position);
		}

		public static function newBreak(chain:EventChain):Event {
			return (new Event()).setEventChain(chain).setDeactivateChain(true);
		}

		public static function newCallback(chain:EventChain, callback:Function):Event {
			return (new Event()).setEventChain(chain).setCallback(callback);
		}

		public function toString():String {
			return "[Event: bg=" + newBackground + ", bgm=" + newBGM + ", dialog=" + newDialog + ", question=" + newQuestion + "]";
		}

	}
}

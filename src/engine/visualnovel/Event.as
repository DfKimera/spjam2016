package engine.visualnovel {
	import engine.Dialog;

	public class Event {

		public var chapter:Chapter = null;
		public var newBackground:Class = null;
		public var newBGM:String = null;
		public var newDialog:Dialog = null;
		public var newQuestion:Question = null;

		public var doLoadNext:Boolean = false;

		public function background(background:Class):Event {
			this.newBackground = background;
			return this;
		}

		public function bgm(bgm:String):Event {
			this.newBGM = bgm;
			return this;
		}

		public function dialog(charClass:Class, message:String, expression:String = "default", position:String = "bottom"):Event {
			this.newDialog = new Dialog(chapter, new charClass, message, expression, position);
			return this;
		}

		public function question(title:String):Question {
			this.newQuestion = new Question(title, Config.QUESTION_POSITION.x, Config.QUESTION_POSITION.y);
			return this.newQuestion;
		}

		public function finish():void {
			if(this.newQuestion) {
				this.chapter.remove(this.newQuestion);
				this.newQuestion.kill();
			}
		}

		public function setChapter(chapter:Chapter):Event {
			this.chapter = chapter;
			return this;
		}

		public function loadNext():Event {
			this.doLoadNext = true;
			return this;
		}

		public static function newBackground(chapter:Chapter, background:Class):Event {
			return (new Event()).setChapter(chapter).background(background);
		}

		public static function newBGM(chapter:Chapter, bgm:String):Event {
			return (new Event()).setChapter(chapter).bgm(bgm);
		}

		public static function newDialog(chapter:Chapter, charClass:Class, message:String, expression:String = "default", position:String = "bottom"):Event {
			return (new Event()).setChapter(chapter).dialog(charClass, message, expression, position);
		}

		public function toString():String {
			return "[Event: bg=" + newBackground + ", bgm=" + newBGM + ", dialog=" + newDialog + ", question=" + newQuestion + "]";
		}

	}
}

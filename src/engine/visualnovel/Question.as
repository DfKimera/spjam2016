package engine.visualnovel {

	import engine.Cursor;
	import engine.SFX;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;

	public class Question extends FlxGroup {

		private var optionHeight:int = 40;
		private var baseY:int = 90;

		[Embed(source="../../../assets/Merriweather-Regular.ttf", fontFamily="merriweather", embedAsCFF="false")]
		public static var FONT:Class;

		[Embed(source="../../../assets/question_bg.png")]
		public var BACKGROUND_SPRITE:Class;

		public var background:FlxSprite;

		public var optionIndex:Array = [];
		public var options:Array = [];
		public var $options:FlxGroup = new FlxGroup();

		public var selectedOption:int = -1;

		public var title:FlxText;
		public var x:int;
		public var y:int;

		public function Question(title:String, x:int = 0, y:int = 0) {

			trace("Question: ", title);

			this.x = x;
			this.y = y;

			this.background = new FlxSprite(x,y);
			this.background.loadGraphic(BACKGROUND_SPRITE);

			this.title = new FlxText(x, y + 26, 550, title);
			this.title.setFormat("merriweather", 16, 0xFFFFFF, "center", 0xFF000000);

			add(this.background);
			add(this.title);
			add($options);

		}


		public function triggerOption(name:String):void {
			if(!options[name]) { return; }
			trace("Choice (trigger): ", name, options[name]);
			(options[name] as Choice).trigger();
		}

		public function addOption(name:String,  callback:Function):Question {

			var option:Choice = new Choice(name, callback, x + 135, y + baseY);

			options[name] = option;
			optionIndex.push(name);
			$options.add(option);

			baseY += optionHeight;

			return this;

		}

		public function unselectOptions():void {
			for(var i:String in options) {
				(options[i] as Choice).setOff();
			}
		}

		public function selectOption(name:String):void {
			(options[name] as Choice).setOn();
		}

		public override function update():void {

			unselectOptions();

			if(FlxG.keys.justPressed("DOWN")) {

				selectedOption += 1;

				if(selectedOption >= optionIndex.length) {
					selectedOption = 0;
				}

				trace("Menu (down): ", selectedOption, optionIndex[selectedOption], options[optionIndex[selectedOption]]);

			} else if(FlxG.keys.justPressed("UP")) {

				selectedOption -= 1;

				if(selectedOption < 0) {
					selectedOption = optionIndex.length - 1;
				}

				trace("Menu (up): ", selectedOption, optionIndex[selectedOption], options[optionIndex[selectedOption]]);

			} else if(FlxG.keys.justPressed("ENTER")) {
				triggerOption(optionIndex[selectedOption]);
			}

			if(selectedOption != -1) {
				selectOption(optionIndex[selectedOption]);
			}

			super.update();

		}

	}
}

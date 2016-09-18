package {

	import engine.SFX;

	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;

	public class Menu extends FlxState {

		private var buttonOffset:Array = [115, 370];

		[Embed(source="../assets/backgrounds/title_screen.png")]
		public var BACKGROUND_SPRITE:Class;

		public var background:FlxSprite;
		public var optionIndex:Array = [];
		public var options:Array = [];
		public var $options:FlxGroup = new FlxGroup();

		public var selectedOption:int = -1;

		public override function create():void {

			//Game.playMusic("radio_martini");

			background = new FlxSprite(0,0);
			background.loadGraphic(BACKGROUND_SPRITE);
			add(background);

			createOptions();
			add($options);

		}

		public function createOptions():void {

			addOption("Jogar", 0, 0, function():void {
				Game.start();
			});

			addOption("Créditos", 300, 0, function():void {
				Game.openCredits();
			});

		}

		public function triggerOption(name:String):void {
			if(!options[name]) { return; }
			trace("Menu (trigger): ", name, options[name]);
			(options[name] as MenuOption).trigger();
		}

		public function addOption(name:String, x:int, y:int, callback:Function):void {

			var option:MenuOption = new MenuOption(name, callback, buttonOffset[0] + x, buttonOffset[1] + y);

			options[name] = option;
			optionIndex.push(name);
			$options.add(option);

		}

		public function unselectOptions():void {
			for(var i:String in options) {
				(options[i] as MenuOption).setOff();
			}
		}

		public function selectOption(name:String):void {
			(options[name] as MenuOption).setOn();
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

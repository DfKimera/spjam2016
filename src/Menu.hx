 

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxState;

 class Menu extends FlxState {

	var buttonOffset:Array<ASAny> = [115, 370];

	public var BACKGROUND_SPRITE:String = "assets/backgrounds/title_screen.png";

	public var background:FlxSprite;
	public var optionIndex:Array<ASAny> = [];
	public var options:ASAny = {};
	public var _options:FlxGroup = new FlxGroup();

	public var selectedOption:Int = -1;

	public override function create() {

		Game.playMusic("sign_of_magic");

		background = new FlxSprite(0, 0);
		background.loadGraphic(BACKGROUND_SPRITE);
		add(background);

		createOptions();
		add(_options);

	}

	public function createOptions() {

		addOption("Jogar", 0, 0, function () {
			StoryLog.reset();
			Game.start();
		});

		addOption("Créditos", 300, 0, function () {
			Game.openCredits();
		});

	}

	public function triggerOption(name:String) {
		if (!options[name]) {
			return;
		}
		trace("Menu (trigger): ", name, options[name]);
		ASCompat.dynamicAs(options[name] , MenuOption).trigger();
	}

	public function addOption(name:String, x:Int, y:Int, callback:ASFunction) {

		var option= new MenuOption(name, callback, Std.int(ASCompat.toNumber(buttonOffset[0]) + x), Std.int(ASCompat.toNumber(buttonOffset[1]) + y));

		options[name] = option;
		optionIndex.push(name);
		_options.add(option);

	}

	public function unselectOptions() {
		for (_tmp_ in 0...optionIndex.length) {
			ASCompat.dynamicAs(options[optionIndex[_tmp_]] , MenuOption).setOff();
		}
	}

	public function selectOption(name:String) {
		ASCompat.dynamicAs(options[name] , MenuOption).setOn();
	}

	public override function update() {

		unselectOptions();

		if (FlxG.keys.justPressed("DOWN")) {

			selectedOption += 1;

			if (selectedOption >= optionIndex.length) {
				selectedOption = 0;
			}

			trace("Menu (down): ", selectedOption, optionIndex[selectedOption], options[optionIndex[selectedOption]]);

		} else if (FlxG.keys.justPressed("UP")) {

			selectedOption -= 1;

			if (selectedOption < 0) {
				selectedOption = optionIndex.length - 1;
			}

			trace("Menu (up): ", selectedOption, optionIndex[selectedOption], options[optionIndex[selectedOption]]);

		} else if (FlxG.keys.justPressed("ENTER")) {
			triggerOption(optionIndex[selectedOption]);
		}

		if (selectedOption != -1) {
			selectOption(optionIndex[selectedOption]);
		}

		super.update();

	}

}


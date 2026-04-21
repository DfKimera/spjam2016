package engine.visualnovel ;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxText;

 class Question extends FlxGroup {

	var optionHeight:Int = 40;
	var baseY:Int = 90;

	@:meta(Embed(source="../../../assets/Merriweather-Regular.ttf", fontFamily="merriweather", embedAsCFF="false"))
	public static var FONT:Class<Dynamic>;

	public var BACKGROUND_SPRITE:String = "assets/question_bg.png";

	public var background:FlxSprite;

	public var optionIndex:Array<ASAny> = [];
	public var options:ASAny = {};
	public var _options:FlxGroup = new FlxGroup();

	public var selectedOption:Int = -1;

	public var title:FlxText;
	public var x:Int = 0;
	public var y:Int = 0;

	public function new(title:String, x:Int = 0, y:Int = 0) {
		super();

		trace("Question: ", title);

		this.x = x;
		this.y = y;

		this.background = new FlxSprite(x, y);
		this.background.loadGraphic(BACKGROUND_SPRITE);

		this.title = new FlxText(x, y + 26, 550, title);
		this.title.setFormat("merriweather", 16, 0xFFFFFF, "center", 0xFF000000);

		add(this.background);
		add(this.title);
		add(_options);

	}


	public function triggerOption(name:String) {
		if (!options[name]) {
			return;
		}
		trace("Choice (trigger): ", name, options[name]);
		ASCompat.dynamicAs(options[name] , Choice).trigger();
	}

	public function addOption(name:String, callback:ASFunction):Question {

		var option= new Choice(name, callback, x + 135, y + baseY);

		options[name] = option;
		optionIndex.push(name);
		_options.add(option);

		baseY += optionHeight;

		return this;

	}

	public function unselectOptions() {
		for (_tmp_ in 0...optionIndex.length) {
			ASCompat.dynamicAs(options[optionIndex[_tmp_]] , Choice).setOff();
		}
	}

	public function selectOption(name:String) {
		ASCompat.dynamicAs(options[name] , Choice).setOn();
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


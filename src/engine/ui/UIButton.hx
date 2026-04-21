package engine.ui ;
import engine.SFX;

import org.flixel.FlxGroup;

import org.flixel.FlxText;

import org.flixel.plugin.photonstorm.FlxExtendedSprite;

 class UIButton extends FlxGroup {

	@:meta(Embed(source="../../../assets/Raleway-Regular.ttf", fontFamily="raleway", embedAsCFF="false"))
	public static var FONT:Class<Dynamic>;

	@:meta(Embed(source="../../../assets/choice_btn.png"))
	var SPRITE:Class<Dynamic>;

	var btn:FlxExtendedSprite;
	var onTriggerHandler:ASFunction;
	var isOver:Bool = false;

	var current:String = "off";

	public var title:FlxText;

	public function new(item:String, onTriggerHandler:ASFunction, x:Int, y:Int) {
		super();

		btn = new FlxExtendedSprite();
		btn.loadGraphic(SPRITE, true, false, 280, 40);

		this.onTriggerHandler = onTriggerHandler;
		btn.mouseReleasedCallback = this.onClick;
		btn.name = item;
		btn.ID = ASCompat.MAX_INT - 10;

		btn.x = x;
		btn.y = y;

		btn.addAnimation("off", [0]);
		btn.addAnimation("on", [1]);

		btn.play("off");

		add(btn);

		var yOffset= (btn.name.length > 40) ? 0 : 6;

		title = new FlxText(x, y + yOffset, 280, btn.name);
		title.setFormat("raleway", 14, 0xFFFFFF, "center", 0xFF000000);
		add(title);


	}

	function onClick(spr:FlxExtendedSprite, x:Int, y:Int) {
		trace("UIButton click: ", spr, x, y);
		this.trigger();
	}

	public function setOn() {
		this.isOver = true;
	}

	public function setOff() {
		this.isOver = false;
	}

	public function trigger() {
		trace("Choice option trigger: ", this);
		SFX.play("bell");

		if (Reflect.isFunction(this.onTriggerHandler )) {
			this.onTriggerHandler();
		}
	}

	public override function update() {

		super.update();

		if (isOver || btn.mouseOver) {
			if (current == "off") {
				SFX.play("scroll");
			}
			current = "on";
			btn.play("on");
		} else {
			current = "off";
			btn.play("off");
		}
	}
}


package engine.visualnovel {
	import engine.Cursor;
	import engine.SFX;

	import org.flixel.FlxGroup;

	import org.flixel.FlxText;

	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Choice extends FlxGroup {

		[Embed(source="../../../assets/Raleway-Regular.ttf", fontFamily="raleway", embedAsCFF="false")]
		public static var FONT:Class;

		[Embed(source="../../../assets/choice_btn.png")]
		private var SPRITE:Class;

		private var btn:FlxExtendedSprite;
		private var onTriggerHandler:Function;
		private var isOver:Boolean = false;

		private var current:String = "off";

		public var title:FlxText;

		public function Choice(item:String, onTriggerHandler:Function, x:int, y:int) {

			btn = new FlxExtendedSprite();
			btn.loadGraphic(SPRITE, true, false, 280, 40);

			this.onTriggerHandler = onTriggerHandler;
			btn.mouseReleasedCallback = this.onClick;
			btn.name = item;

			btn.x = x;
			btn.y = y;

			btn.addAnimation("off", [0]);
			btn.addAnimation("on", [1]);

			btn.play("off");

			add(btn);

			var yOffset:int = (btn.name.length > 40) ? 0 : 6;

			title = new FlxText(x, y + yOffset, 280, btn.name);
			title.setFormat("raleway", 14, 0xFFFFFF, "center", 0xFF000000);
			add(title);


		}

		private function onClick(spr:FlxExtendedSprite, x:int, y:int):void {
			this.trigger();
		}

		public function setOn():void {
			this.isOver = true;
		}

		public function setOff():void {
			this.isOver = false;
		}

		public function trigger():void {
			trace("Choice option trigger: ", this);
			SFX.play("bell");

			if(this.onTriggerHandler is Function) {
				this.onTriggerHandler.call();
			}
		}

		public override function update():void {

			super.update();

			if(isOver || btn.mouseOver) {
				if(current == "off") { SFX.play("scroll"); }
				current = "on";
				btn.play("on");
			} else {
				current = "off";
				btn.play("off");
			}
		}
	}
}

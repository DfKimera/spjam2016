package engine {
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class InteractiveArea extends Prop {

		private var interactionCallback:Function;

		public function InteractiveArea(name:String, width:int, height:int, interactionCallback:Function = null) {
			super();
			this.name = name;
			this.width = width;
			this.height = height;
			this.interactionCallback = interactionCallback;
		}

		override public function draw():void { /* Prevent drawing */ }

		override public function toString():String {
			return "InteractiveArea(" + name + " @" + x + "," + y + " sz=" + width + "x" + height + ")";
		}

		override public function updateCursor():void {
			Cursor.useEye();
		}

		override protected function _onInteract(spr:FlxExtendedSprite, x:int, y:int):void {
			super._onInteract(spr, x, y);

			SFX.play("click");

			if(this.interactionCallback is Function) {
				interactionCallback.call(null, this);
			}
		}

		// -------------------------------------------------------------------------------------------------------------

		public static function checkIfIs(prop:Prop, name:String):Boolean {
			if(prop is InteractiveArea) {
				if((prop as InteractiveArea).name == name) {
					return true;
				}
			}

			return false;
		}

		public static function placeOnScene(scene:Scene, name:String, x:int, y:int, width:int, height:int, interactionCallback:Function = null):InteractiveArea {
			var portal:InteractiveArea = new InteractiveArea(name, width, height, interactionCallback);
			Prop.placeOnScene(scene, portal, x, y);
			return portal;
		}

	}
}

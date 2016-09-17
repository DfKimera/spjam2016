package engine {
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Portal extends Prop {

		private var nextScene:Class;

		public function Portal(name:String, width:int, height:int, nextScene:Class = null) {
			super();
			this.name = name;
			this.width = width;
			this.height = height;
			this.nextScene = nextScene;
		}

		override public function draw():void { /* Prevent drawing */ }

		override public function toString():String {
			return "Portal(" + name + " @" + x + "," + y + " sz=" + width + "x" + height + ")";
		}

		override public function updateCursor():void {
			if(nextScene is Class) {
				Cursor.useDoor();
			} else {
				Cursor.useEye();
			}
		}

		override protected function _onInteract(spr:FlxExtendedSprite, x:int, y:int):void {
			super._onInteract(spr, x, y);

			SFX.play("click");

			if(this.nextScene is Class) {
				Inventory.releaseItemOnCursor();
				Game.transitionToScene(new this.nextScene());
			}
		}

		// -------------------------------------------------------------------------------------------------------------

		public static function checkIfIs(prop:Prop, name:String):Boolean {
			if(prop is Portal) {
				if((prop as Portal).name == name) {
					return true;
				}
			}

			return false;
		}

		public static function placeOnScene(scene:Scene, name:String, x:int, y:int, width:int, height:int, nextScene:Class = null):Portal {
			var portal:Portal = new Portal(name, width, height, nextScene);
			Prop.placeOnScene(scene, portal, x, y);
			return portal;
		}

	}
}

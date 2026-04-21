package engine ;

import org.flixel.plugin.photonstorm.FlxExtendedSprite;

 class Portal extends Prop {

	var nextScene:Class<Dynamic>;

	public function new(name:String, width:Int, height:Int, nextScene:Class<Dynamic> = null) {
		super();
		this.name = name;
		this.width = width;
		this.height = height;
		this.nextScene = nextScene;
	}

	override public function draw() { /* Prevent drawing */
	}

	override public function toString():String {
		return "Portal(" + name + " @" + x + "," + y + " sz=" + width + "x" + height + ")";
	}

	override public function updateCursor() {
		if (Std.is(nextScene , Class)) {
			Cursor.useDoor();
		} else {
			Cursor.useEye();
		}
	}

	override function _onInteract(spr:FlxExtendedSprite, x:Int, y:Int) {
		super._onInteract(spr, x, y);

		SFX.play("click");

		if (Std.is(this.nextScene , Class)) {
			Inventory.releaseItemOnCursor();
			Game.transitionToScene(Type.createInstance(this.nextScene, []));
		}
	}

	// -------------------------------------------------------------------------------------------------------------

	public static function checkIfIs(prop:Prop, name:String):Bool {
		if (Std.is(prop , Portal)) {
			if (Std.downcast(prop , Portal).name == name) {
				return true;
			}
		}

		return false;
	}

	public static function placeOnScene(scene:Scene, name:String, x:Int, y:Int, width:Int, height:Int, nextScene:Class<Dynamic> = null):Portal {
		var portal= new Portal(name, width, height, nextScene);
		Prop.placeOnScene(scene, portal, x, y);
		return portal;
	}

}


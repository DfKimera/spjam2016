package engine ;

import org.flixel.plugin.photonstorm.FlxExtendedSprite;

 class InteractiveArea extends Prop {

	var interactionCallback:ASFunction;

	public function new(name:String, width:Int, height:Int, interactionCallback:ASFunction = null) {
		super();
		this.name = name;
		this.width = width;
		this.height = height;
		this.interactionCallback = interactionCallback;
	}

	override public function draw() { /* Prevent drawing */
	}

	override public function toString():String {
		return "InteractiveArea(" + name + " @" + x + "," + y + " sz=" + width + "x" + height + ")";
	}

	override public function updateCursor() {
		Cursor.useEye();
	}

	override function _onInteract(spr:FlxExtendedSprite, x:Int, y:Int) {
		super._onInteract(spr, x, y);

		SFX.play("click");

		if (Reflect.isFunction(this.interactionCallback )) {
			interactionCallback(this);
		}
	}

	// -------------------------------------------------------------------------------------------------------------

	public static function checkIfIs(prop:Prop, name:String):Bool {
		if (Std.is(prop , InteractiveArea)) {
			if (Std.downcast(prop , InteractiveArea).name == name) {
				return true;
			}
		}

		return false;
	}

	public static function placeOnScene(scene:Scene, name:String, x:Int, y:Int, width:Int, height:Int, interactionCallback:ASFunction = null):InteractiveArea {
		var portal= new InteractiveArea(name, width, height, interactionCallback);
		Prop.placeOnScene(scene, portal, x, y);
		return portal;
	}

}


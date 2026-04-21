package engine ;

import engine.visualnovel.EventChain;

 class Level extends Scene {

	public static var current:Level = null;

	public var eventChains:ASAny = {};

	public override function create() {
		super.create();
		Level.current = this;
	}

	public static function getCurrent():Level {
		return current;
	}

	public function showDialog(characterClass:Class<Dynamic>, message:String, expression:String = "default", position:String = "bottom") {
		Dialog.show(this, Type.createInstance(characterClass, []), message, expression, position);
	}

	public function createEventChain(id:String, onFinishCallback:ASFunction = null):EventChain {
		if (eventChains[id]) {
			return eventChains[id];
		}

		var chain= EventChain.create(this, onFinishCallback);
		eventChains[id] = chain;

		return chain;
	}

	public override function update() {
		super.update();
		updateEventChains();
	}

	public function updateEventChains() {
		for (_tmp_ in eventChains.___keys()) {
var i:String  = _tmp_;
			eventChains[i].update();
		}
	}

	public static function Teleporter(levelClass:Class<Dynamic>):ASFunction {
		return function () {
			Game.transitionToScene(Type.createInstance(levelClass, []));
		}
;	}

}


package engine.visualnovel ;

import engine.Scene;

 class Chapter extends Scene {

	public var chain:EventChain;

	public function new(){
		super();
		chain = new EventChain(this, onFinish);
	}

	public override function create() {
		super.create();
		chain.start();
	}

	public override function update() {
		super.update();
		chain.update();
	}

	override function hasInventoryEnabled():Bool {
		return false;
	}

	public static function start(chapterClass:Class<Dynamic>) {
		Game.transitionToScene(Type.createInstance(chapterClass, []));
	}

	public function onFinish() {

	}
}


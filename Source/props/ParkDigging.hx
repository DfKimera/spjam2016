package props ;

import engine.Prop;

 class ParkDigging extends Prop {

	@:meta(Embed("../../assets/props/park_digging.png"))
	public var SPRITE:Class<Dynamic>;

	public function new() {
		super();
		loadGraphic(SPRITE);
	}

}


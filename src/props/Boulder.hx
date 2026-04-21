package props ;

import engine.Prop;

 class Boulder extends Prop {

	@:meta(Embed("../../assets/prop_boulder.png"))
	public var SPRITE:Class<Dynamic>;

	public function new() {
		super();
		loadGraphic(SPRITE);
	}

}


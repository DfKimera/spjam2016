package props ;

import engine.Prop;

 class CemeteryGateTrash extends Prop {

	@:meta(Embed("../../assets/props/cemetery_gate_trash.png"))
	public var SPRITE:Class<Dynamic>;

	public function new() {
		super();
		loadGraphic(SPRITE);
	}

}


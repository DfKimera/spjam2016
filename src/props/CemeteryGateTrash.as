package props {

	import engine.Prop;

	public class CemeteryGateTrash extends Prop {

		[Embed("../../assets/props/cemetery_gate_trash.png")]
		public var SPRITE:Class;

		public function CemeteryGateTrash() {
			super();
			loadGraphic(SPRITE);
		}

	}
}

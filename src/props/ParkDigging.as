package props {

	import engine.Prop;

	public class ParkDigging extends Prop {

		[Embed("../../assets/props/park_digging.png")]
		public var SPRITE:Class;

		public function ParkDigging() {
			super();
			loadGraphic(SPRITE);
		}

	}
}

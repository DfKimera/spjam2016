package props {

	import engine.Prop;

	public class Boulder extends Prop {

		[Embed("../../assets/prop_boulder.png")]
		public var SPRITE:Class;

		public function Boulder() {
			super();
			loadGraphic(SPRITE);
		}

	}
}

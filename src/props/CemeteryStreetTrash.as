package props {

	import engine.Prop;

	public class CemeteryStreetTrash extends Prop {

		[Embed("../../assets/props/cemetery_street_trash.png")]
		public var SPRITE:Class;

		public function CemeteryStreetTrash() {
			super();
			loadGraphic(SPRITE);
		}

	}
}

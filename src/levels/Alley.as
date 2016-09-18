package levels {

	import engine.Level;
	import engine.Portal;

	public class Alley extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_ALLEY;

		public function Alley():void {
			super();
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();

			TrainStation.setExit(Alley);
			Portal.placeOnScene(this, "enter_train_station", 270, 535, 530, 65, TrainStation);
		}
	}
}

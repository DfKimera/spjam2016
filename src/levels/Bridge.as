package levels {

	import engine.Level;
	import engine.Portal;

	public class Bridge extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_BRIDGE;

		public function Bridge():void {
			super();
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();

			TrainStation.setExit(Bridge);
			Portal.placeOnScene(this, "enter_train_station", 720, 430, 80, 170, TrainStation);
		}
	}
}

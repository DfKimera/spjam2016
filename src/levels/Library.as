package levels {

	import engine.Level;
	import engine.Portal;

	public class Library extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_LIBRARY;

		public function Library():void {
			super();
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();

			TrainStation.setExit(Library);
			Portal.placeOnScene(this, "enter_train_station", 675, 0, 125, 600, TrainStation);
		}
	}
}

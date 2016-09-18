package levels {

	import engine.Item;
	import engine.Level;
	import engine.Portal;
	import engine.Prop;
	import engine.visualnovel.EventChain;

	public class Plaza extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_PLAZA;

		public function Plaza():void {
			super();
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();

			TrainStation.setExit(Plaza);
			Portal.placeOnScene(this, "enter_train_station", 0, 470, 170, 130, TrainStation);
		}
	}
}

package levels {

	import engine.Item;
	import engine.Level;
	import engine.Portal;
	import engine.Prop;
	import engine.visualnovel.EventChain;

	public class Park extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_PARK;

		public function Park():void {
			super();
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();

			TrainStation.setExit(Park);
			Portal.placeOnScene(this, "enter_train_station", 230, 530, 570, 70, TrainStation);
		}
	}
}

package levels {

	import engine.Item;
	import engine.Level;
	import engine.Portal;
	import engine.Prop;
	import engine.visualnovel.EventChain;

	public class MASP extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_MASP;

		public function MASP():void {
			super();
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();

			TrainStation.setExit(MASP);
			Portal.placeOnScene(this, "enter_train_station", 0, 270, 55, 330, TrainStation);
		}
	}
}

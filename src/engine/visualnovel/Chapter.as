package engine.visualnovel {

	import engine.Scene;

	public class Chapter extends Scene {

		public var chain:EventChain;

		public function Chapter():void {
			chain = new EventChain(this, onFinish);
		}

		public override function create():void {
			super.create();
			chain.start();
		}

		public override function update():void {
			super.update();
			chain.update();
		}

		override protected function hasInventoryEnabled():Boolean {
			return false;
		}

		public static function start(chapterClass:Class):void {
			Game.transitionToScene(new chapterClass);
		}

		public function onFinish():void {

		}
	}
}

package {

	import flash.display.Sprite;

	[SWF(backgroundColor="#000000", frameRate="30", width = "800", height = "600")]
	[Frame(factoryClass="Preloader")]
	public class Bootstrap extends Sprite {

		public static var game:Game;
		public static var instance:Bootstrap;

	    public function Bootstrap() {

		    Bootstrap.instance = this;
			Bootstrap.game = new Game();
		    addChild(Bootstrap.game);

	    }
	}
}

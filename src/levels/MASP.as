package levels {

	import characters.Clovis;

	import engine.InteractiveArea;
	import engine.Item;
	import engine.Level;
	import engine.Portal;
	import engine.Prop;
	import engine.visualnovel.EventChain;

	import items.Key;

	public class MASP extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_MASP;

		public static var hasUsedKey:Boolean = false;

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

			InteractiveArea.placeOnScene(this, "keyhole", 318, 344, 25, 48, onKeyholeInteract);
		}

		public function onKeyholeInteract(area:InteractiveArea):void {
			if(hasUsedKey) {
				showDialog(Clovis, "Passei por aqui tantas vezes, nunca imaginei que o esconderijo era tão óbvio.");
				return;
			}

			showDialog(Clovis, "Há um buraco nessa pilastra... definitivamente está aqui de propósito.");
		}

		public override function onItemUse(prop:Prop, item:Item):void {
			if(prop.name == "keyhole" && item is Key) {
				showDialog(Clovis, "*coloca a chave no buraco* *click*");
				showDialog(Clovis, "Acho que escutei um clique");
				showDialog(Clovis, "*abre-se uma portinhola, e por trás dela há um símbolo*");
				showDialog(Clovis, "Eureka! Mais um símbolo!");

				hasUsedKey = true;

				item.consume();

				// TODO: give symbol
			}

			showDialog(Clovis, "Não cabe nesse buraco. Parece que é o tamanho exato de uma chave.");
		}
	}
}

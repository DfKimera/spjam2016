package levels {
	import characters.Clovis;

	import engine.Dialog;

	import engine.InteractiveArea;

	import engine.Level;
	import engine.Portal;
	import engine.Prop;
	import engine.visualnovel.EventChain;

	import props.CemeteryStreetTrash;

	public class CemeteryStreet extends Level {

		public var BACKGROUND_SPRITE_DAY:Class = Assets.BG_CEMETERY_STREET_DAY;
		public var BACKGROUND_SPRITE_NIGHT:Class = Assets.BG_CEMETERY_STREET;

		public var trash:CemeteryStreetTrash;

		public function CemeteryStreet():void {
			super();
		}

		public override function prepare():void {
			setBackground((StoryLog.timeOfDay == "day") ? BACKGROUND_SPRITE_DAY : BACKGROUND_SPRITE_NIGHT);
		}

		public override function create():void {
			super.create();

			TrainStation.setExit(CemeteryStreet);

			Portal.placeOnScene(this, "back_to_station", 0, 120, 85, 270, TrainStation);
			Portal.placeOnScene(this, "approach_gate", 650, 0, 150, 600, CemeteryGate);

			InteractiveArea.placeOnScene(this, "determination", 744, 253, 30, 30, Dialog.Quick(this, Clovis, "Por algum motivo, esse poster me dá... determinação..."));

			if(!CemeteryGate.hasPlacedTrash) {
				trash = new CemeteryStreetTrash();
				Prop.placeOnScene(this, trash, 290, 357);
			}

		}

		public override function onPropInteract(prop:Prop):void {
			if(prop is CemeteryStreetTrash) {

				if(!CemeteryGate.hasVisitedOnce) {
					showDialog(Clovis, "Um monte de lixo. Há várias tábuas e caixas ali.");
					return;
				}

				var chain:EventChain = createEventChain("move_trash");

				chain.addQuestion("Empurrar o lixo?")
					.addOption("Sim", onTrashMove)
					.addOption("Não", function ():void {});

				chain.start();
			}
		}

		public function onTrashMove():void {
			// TODO: audio SFX
			CemeteryGate.hasPlacedTrash = true;
			showDialog(Clovis, "Pronto!");
			Game.transitionToScene(new CemeteryGate());
		}
	}
}

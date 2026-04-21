package levels ;

import characters.Clovis;

import engine.Dialog;

import engine.InteractiveArea;

import engine.Level;
import engine.Portal;
import engine.Prop;

import props.CemeteryStreetTrash;

 class CemeteryStreet extends Level {

	public var BACKGROUND_SPRITE_DAY:Class<Dynamic> = Assets.BG_CEMETERY_STREET_DAY;
	public var BACKGROUND_SPRITE_NIGHT:Class<Dynamic> = Assets.BG_CEMETERY_STREET;

	public var trash:CemeteryStreetTrash;

	public function new(){
		super();
	}

	public override function prepare() {
		setBackground((StoryLog.timeOfDay == "day") ? BACKGROUND_SPRITE_DAY : BACKGROUND_SPRITE_NIGHT);
	}

	public override function create() {
		super.create();

		TrainStation.setExit(CemeteryStreet);

		Portal.placeOnScene(this, "back_to_station", 0, 120, 85, 270, TrainStation);
		Portal.placeOnScene(this, "approach_gate", 650, 0, 150, 600, CemeteryGate);

		InteractiveArea.placeOnScene(this, "determination", 744, 253, 30, 30, Dialog.Quick(this, Clovis, "Por algum motivo, esse poster me dá... determinação..."));

		if (!CemeteryGate.hasPlacedTrash) {
			trash = new CemeteryStreetTrash();
			Prop.placeOnScene(this, trash, 290, 357);
		}

	}

	public override function onPropInteract(prop:Prop) {
		if (Std.is(prop , CemeteryStreetTrash)) {

			if (!CemeteryGate.hasVisitedOnce) {
				showDialog(Clovis, "Um monte de lixo. Há várias tábuas e caixas ali.");
				return;
			}

			var chain= createEventChain("move_trash");

			chain.addQuestion("Empurrar o lixo?")
					.addOption("Sim", onTrashMove)
					.addOption("Não", function () {
					});

			chain.start();
		}
	}

	public function onTrashMove() {
		// TODO: audio SFX
		CemeteryGate.hasPlacedTrash = true;
		showDialog(Clovis, "Pronto!");
		Game.transitionToScene(new CemeteryGate());
	}
}


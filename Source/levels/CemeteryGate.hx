package levels ;

import characters.Clovis;

import engine.Dialog;

import engine.InteractiveArea;

import engine.Level;
import engine.Portal;
import engine.Prop;

import props.CemeteryGateTrash;

 class CemeteryGate extends Level {

	public static var hasVisitedOnce:Bool = false;
	public static var hasPlacedTrash:Bool = false;

	public var BACKGROUND_SPRITE_NIGHT:Class<Dynamic> = Assets.BG_CEMETERY_GATE;
	public var BACKGROUND_SPRITE_DAY:Class<Dynamic> = Assets.BG_CEMETERY_GATE_DAY;

	public function new(){
		super();
	}

	public override function prepare() {
		setBackground((StoryLog.timeOfDay == "day") ? BACKGROUND_SPRITE_DAY : BACKGROUND_SPRITE_NIGHT);
	}

	public override function create() {
		super.create();

		if (StoryLog.timeOfDay == "night") {
			Portal.placeOnScene(this, "leave_cemetery", 0, 0, 80, 600, CemeteryStreet);
			Portal.placeOnScene(this, "enter_cemetery", 428, 100, 330, 497, CemeteryTombs);
			return;
		}

		if (!hasVisitedOnce) {
			showDialog(Clovis, "Merda, o cemitério está fechado. Como será que os góticos passam a noite aqui");
			hasVisitedOnce = true;
		}


		if (!hasPlacedTrash) {
			InteractiveArea.placeOnScene(this, "wall_breach", 60, 210, 125, 85, Dialog.Quick(this, Clovis, "Essa parte está sem arame farpado, eu posso passar sem me machucar... muito."));
			InteractiveArea.placeOnScene(this, "garbage_area", 30, 495, 185, 105, Dialog.Quick(this, Clovis, "Preciso dar um jeito de escalar esse muro."));
		} else {
			Portal.placeOnScene(this, "wall_breach", 60, 210, 125, 85, CemeteryTombs);
			Prop.placeOnScene(this, new CemeteryGateTrash(), 0, 443);
		}

		Portal.placeOnScene(this, "leave_cemetery", 0, 0, 80, 600, CemeteryStreet);

	}

	public override function onPropInteract(prop:Prop) {
		if (Std.is(prop , CemeteryGateTrash)) {
			showDialog(Clovis, "Pronto, agora acho que consigo pular o muro.");
		}
	}

}


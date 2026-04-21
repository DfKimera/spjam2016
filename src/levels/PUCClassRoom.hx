package levels ;

import characters.Clovis;
import engine.Level;
import engine.Portal;

import levels.PUCClassRoom;

 class PUCClassRoom extends Level {

	public var BACKGROUND_SPRITE:String = Assets.BG_PUC_CLASSROOM;

	public static var hasSeenSequence:Bool = false;

	public function new(){
		super();
	}

	public override function prepare() {
		setBackground(BACKGROUND_SPRITE);
	}

	public override function create() {
		super.create();
		Portal.placeOnScene(this, "back_to_gate", 30, 115, 55, 220, PUCGate);

		if (!hasSeenSequence) {
			showClassroomSequence();
		}
	}

	public function showClassroomSequence() {
		createEventChain("classroom_sequence")
				.addDialog(Clovis, "... será que foi real?")
				.addDialog(Clovis, "Preciso encontrar as palavras...")
				.addDialog(Clovis, "... mas por onde poderia começar?")
				.addDialog(Clovis, "... espero que o mestre entenda o meu esforço...")
				.addDialog(Clovis, "... maldita aula chata!")
				.addCallback(finishedClassroomSequence)
				.start();
	}

	public function finishedClassroomSequence() {
		PUCClassRoom.hasSeenSequence = true;
		TrainStation.enableTrains();
	}
}


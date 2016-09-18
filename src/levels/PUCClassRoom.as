package levels {

	import characters.Clovis;
	import characters.Hastur;

	import engine.Item;
	import engine.Level;
	import engine.Portal;
	import engine.Prop;
	import engine.visualnovel.EventChain;

	import levels.PUCClassRoom;

	public class PUCClassRoom extends Level {

		public var BACKGROUND_SPRITE:Class = Assets.BG_PUC_CLASSROOM;

		public static var hasSeenSequence:Boolean = false;

		public function PUCClassRoom():void {
			super();
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
		}

		public override function create():void {
			super.create();
			Portal.placeOnScene(this, "back_to_gate", 30, 115, 55, 220, PUCGate);

			if(!hasSeenSequence) {
				showClassroomSequence();
			}
		}

		public function showClassroomSequence():void {
			createEventChain("classroom_sequence")
				.addDialog(Clovis, "... será que foi real?")
				.addDialog(Clovis, "Preciso encontrar as palavras...")
				.addDialog(Clovis, "... mas por onde poderia começar?")
				.addDialog(Clovis, "... espero que o mestre entenda o meu esforço...")
				.addDialog(Clovis, "... maldita aula chata!")
				.addCallback(finishedClassroomSequence)
				.start();
		}

		public function finishedClassroomSequence():void {
			PUCClassRoom.hasSeenSequence = true;
			TrainStation.enableTrains();
		}
	}
}

package levels ;

import characters.Clovis;

import engine.InteractiveArea;
import engine.Level;
import engine.Portal;
import engine.visualnovel.EventChain;

 class TrainStation extends Level {

	public var BACKGROUND_SPRITE:String = Assets.BG_TRAIN_STATION;
	public static var justWokenUp:Bool = false;

	public function new(){
		super();
	}

	public override function prepare() {
		setBackground(BACKGROUND_SPRITE);
	}

	public override function create() {
		super.create();

		if (justWokenUp) {
			justWokenUp = false;

			Game.playMusic("memories_of_yellow");

			showDialog(Clovis, "Mas... mas o que!?");
			showDialog(Clovis, "Será que foi um sonho?");
			showDialog(Clovis, "*olha o relógio* Merda! Estou atrasado para a aula!");
		}

		Portal.placeOnScene(this, "leave_station", 0, 189, 121, 197, TrainStation.exitLevel);
		InteractiveArea.placeOnScene(this, "use_train", 375, 190, 420, 230, onTrainUse); // TODO: restrict this after first classroom interaction?
	}

	public function onTrainUse(area:InteractiveArea) {

		var chain= EventChain.create(this);

		if (!TrainStation.trainEnabled) {
			if (StoryLog.timeOfDay == "day") {
				return chain.addDialog(Clovis, "Preciso encontrar o mestre. Não há mais volta para mim.").start();
			}
			return chain.addDialog(Clovis, "Não posso voltar, estou atrasado para minha aula").start();
		}

		var menu= chain.addQuestion("Para onde devo ir?")
				.addOption("Campus da PUC", Level.Teleporter(PUCGate))
				.addOption("Centro Cultural São Paulo", Level.Teleporter(Library));

		menu.addOption("Cemitério da Consolação", Level.Teleporter(CemeteryStreet))
				.addOption("Parque Augusta", Level.Teleporter(Park))
				.addOption("Vão do MASP", Level.Teleporter(MASP))
				.addOption("Beco do Batman", Level.Teleporter(Alley))
				.addOption("Praça da Sé", Level.Teleporter(Plaza))
				.addOption("Viaduto do Chá", Level.Teleporter(Bridge));


		chain.start();

	}

	static var exitLevel:Class<Dynamic> = CemeteryStreet;
	static var trainEnabled:Bool = false;

	public static function enableTrains() {
		trainEnabled = true;
	}

	public static function setExit(level:Class<Dynamic>) {
		TrainStation.exitLevel = level;
	}
}


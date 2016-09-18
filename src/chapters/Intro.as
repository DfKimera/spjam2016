package chapters {

	import characters.Cthullu;
	import characters.Player;

	import engine.visualnovel.Chapter;
	import engine.visualnovel.Event;

	import levels.TrainStation;

	public class Intro extends Chapter {

		public function Intro():void {
			chain.addEvent(Event.newBackground(chain, Assets.BG_CEMETERY).loadNext());

			chain.addQuestion("Você avistou monstros na praia, o que quer fazer?")
					.addOption("Se esconder", optHide)
					.addOption("'Ei! Quem são vocês?'", optAsk);
		}

		private function optAsk():void {
			chain.addEvent(Event.newDialog(chain, Cthullu, "QUEM ESTÁ AÍ!?"));
			chain.start();
		}

		private function optHide():void {
			chain.addDialog(Cthullu, "QUEM ESTÁ AÍ!?")
				.addDialog(Player, "Eu acabei de chegar nesta cidade, não me machuquem, por favor!")
				.addDialog(Cthullu, "Calma! Nós não queremos ferir ninguém.")
				.addDialog(Cthullu, "Se não ficarem em nosso caminho!")
				.addDialog(Player, "... o que está acontecendo?")
				.addDialog(Cthullu, "Há milhares de anos fomos exilados para terras além-mar, mas agora finalmente reunimos forças para retornar a onde pertencemos. Só queremos atravessar até além das montanhas, onde é nosso lar.")
				.nextEvent();
		}

		override public function onFinish():void {
			Game.transitionToScene(new TrainStation());
		}

	}
}

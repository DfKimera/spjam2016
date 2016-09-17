package chapters {

	import characters.Cthullu;
	import characters.Player;

	import engine.visualnovel.Chapter;
	import engine.visualnovel.Event;

	public class Intro extends Chapter {

		public function Intro() {

			var self:Chapter = this;

			addEvent(Event.newBackground(this, Assets.BG_CEMETERY).loadNext());
			addQuestion("Você avistou monstros na praia, o que quer fazer?")
				.addOption("Se esconder", optHide)
				.addOption("'Ei! Quem são vocês?'", optAsk);

		}

		private function optAsk():void {
			addEvent(Event.newDialog(this, Cthullu, "QUEM ESTÁ AÍ!?"));
			nextEvent();
		}

		private function optHide():void {
			addEvent(Event.newDialog(this, Cthullu, "QUEM ESTÁ AÍ!?"));
			addEvent(Event.newDialog(this, Player, "Eu acabei de chegar nesta cidade, não me machuquem, por favor!"));
			addEvent(Event.newDialog(this, Cthullu, "Calma! Nós não queremos ferir ninguém."));
			addEvent(Event.newDialog(this, Cthullu, "Se não ficarem em nosso caminho!"));
			addEvent(Event.newDialog(this, Player, "... o que está acontecendo?"));
			addEvent(Event.newDialog(this, Cthullu, "Há milhares de anos fomos exilados para terras além-mar, mas agora finalmente reunimos forças para retornar a onde pertencemos. Só queremos atravessar até além das montanhas, onde é nosso lar."));
			nextEvent();
		}

		override public function onFinish():void {
			Game.goToMainMenu();
		}

	}
}

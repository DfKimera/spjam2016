package chapters {

	import characters.Clovis;
	import characters.Hastur;

	import engine.visualnovel.Chapter;
	import engine.visualnovel.Event;

	import org.flixel.FlxG;

	import scenes.CreditsScene;

	public class Outro extends Chapter {

		public function Outro():void {
			chain.addEvent(Event.newBackground(chain, Assets.BG_OUTRO).loadNext());

			chain.addDialog(Hastur, "CRIATURA TOLA, VOCÊ ME SERVIU BEM.");
			chain.addDialog(Hastur, "AGORA É HORA DO SEU MUNDO SOFRER.");
			chain.addDialog(Hastur, "QUE MINHA AURA DE PESADELO CONSUMA A AURA DE TODOS OS MORTAIS.");
			chain.addDialog(Clovis, "Ah... merda.");
		}

		override public function onFinish():void {
			FlxG.shake(0.05, 5);
			Game.transitionToScene(new CreditsScene(), 5);
		}

	}
}

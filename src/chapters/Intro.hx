package chapters ;

import characters.Clovis;

import engine.visualnovel.Chapter;
import engine.visualnovel.Event;

import levels.CemeteryStreet;

import levels.TrainStation;

 class Intro extends Chapter {

	public function new(){
		super();
		chain.addEvent(Event.newBackground(chain, Assets.BG_TRAIN_STATION).loadNext());
		chain.addDialog(Clovis, "Finalmente, depois de anos de pesquisa, consegui encontrar onde o mestre está trancado");
		chain.addDialog(Clovis, "Eu sinto como se ele estivesse me chamando daquele lugar");
	}

	override public function onFinish() {
		TrainStation.setExit(CemeteryStreet);
		Game.transitionToScene(new TrainStation());
	}

}


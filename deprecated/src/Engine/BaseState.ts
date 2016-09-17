import {BlueWolf} from "../BlueWolf";
export class BaseState {

	core: BlueWolf;
	game: Phaser.Game;

	construct() {
		this.core = BlueWolf.engine();
		this.game = BlueWolf.game();
	}

}
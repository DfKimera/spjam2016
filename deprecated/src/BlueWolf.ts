/// <reference path="../vendor/phaser.comments.d.ts"/>

import {LoadState} from "./States/LoadState";
import {MenuState} from "./States/MenuState";
import {GameState} from "./States/GameState";

export class BlueWolf {

	static instance : BlueWolf;
	static engine() { return BlueWolf.instance; }
	static game() { return BlueWolf.instance.game; }

	game: Phaser.Game;

	constructor() {
		BlueWolf.instance = this;

		this.game = new Phaser.Game(800, 600, Phaser.AUTO, 'content');

		this.game.state.add('load', LoadState);
		this.game.state.add('menu', MenuState);
		this.game.state.add('game', GameState);

		this.game.state.start('load');

		// TODO: levels
		// TODO: navigate between levels
		// TODO: objects (props/items)
		// TODO: inventory
		// TODO: use items
		// TODO: place items
		// TODO: dialog
		// TODO: game log (keep track of things done)

	}


}

var game = new BlueWolf();
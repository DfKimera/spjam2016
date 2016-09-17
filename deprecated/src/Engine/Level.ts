import {BlueWolf} from "../BlueWolf";

export class Level extends Phaser.Group {

	core:BlueWolf;
	game:Phaser.Game;

	name: string;
	backgroundPath: string;

	background: Phaser.Sprite;

	constructor() {

		super(this.game);

		this.core = BlueWolf.engine();
		this.game = BlueWolf.game();
	}

	load() {

		this.game.load("lvl_bg_" + name, this.backgroundPath);

		// TODO: load sprite
		// TODO: create sprite

		// TODO: place objects? this should be on each level class
		// TODO: handle click? do we need this here or in objects?

	}

	create() {
		this.background = new Phaser.Sprite(this.game, 0, 0, 'lvl_bg_' + name);
	}
}
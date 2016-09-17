/// <reference path="../vendor/phaser.comments.d.ts"/>
define(["require", "exports", "./greeter"], function (require, exports, greeter_1) {
    var SimpleGame = (function () {
        function SimpleGame() {
            this.game = new Phaser.Game(800, 600, Phaser.AUTO, 'content', { preload: this.preload, create: this.create });
        }
        SimpleGame.prototype.preload = function () {
            this.game.load.image('logo', 'phaser2.png');
        };
        SimpleGame.prototype.create = function () {
            var logo = this.game.add.sprite(this.game.world.centerX, this.game.world.centerY, 'logo');
            logo.anchor.setTo(0.5, 0.5);
            var greeter = new greeter_1.Greeter();
        };
        return SimpleGame;
    })();
    var game = new SimpleGame();
});
//# sourceMappingURL=app.js.map
/// <reference path="../vendor/phaser.comments.d.ts"/>
define(["require", "exports", "./States/LoadState", "./States/MenuState", "./States/GameState"], function (require, exports, LoadState_1, MenuState_1, GameState_1) {
    var BlueWolf = (function () {
        function BlueWolf() {
            BlueWolf.instance = this;
            this.game = new Phaser.Game(800, 600, Phaser.AUTO, 'content');
            this.game.state.add('load', LoadState_1.LoadState);
            this.game.state.add('menu', MenuState_1.MenuState);
            this.game.state.add('game', GameState_1.GameState);
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
        BlueWolf.engine = function () { return BlueWolf.instance; };
        BlueWolf.game = function () { return BlueWolf.instance.game; };
        return BlueWolf;
    })();
    exports.BlueWolf = BlueWolf;
    var game = new BlueWolf();
});
//# sourceMappingURL=BlueWolf.js.map
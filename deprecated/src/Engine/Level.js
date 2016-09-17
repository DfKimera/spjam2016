var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", "../BlueWolf"], function (require, exports, BlueWolf_1) {
    var Level = (function (_super) {
        __extends(Level, _super);
        function Level() {
            _super.call(this, this.game);
            this.core = BlueWolf_1.BlueWolf.engine();
            this.game = BlueWolf_1.BlueWolf.game();
        }
        Level.prototype.load = function () {
            this.game.load("lvl_bg_" + name, this.backgroundPath);
            // TODO: load sprite
            // TODO: create sprite
            // TODO: place objects? this should be on each level class
            // TODO: handle click? do we need this here or in objects?
        };
        Level.prototype.create = function () {
            this.background = new Phaser.Sprite(this.game, 0, 0, 'lvl_bg_' + name);
        };
        return Level;
    })(Phaser.Group);
    exports.Level = Level;
});
//# sourceMappingURL=Level.js.map
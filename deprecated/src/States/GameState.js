var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", "./../Engine/BaseState"], function (require, exports, BaseState_1) {
    var GameState = (function (_super) {
        __extends(GameState, _super);
        function GameState() {
            _super.apply(this, arguments);
        }
        GameState.prototype.construct = function () {
        };
        GameState.prototype.create = function () {
        };
        return GameState;
    })(BaseState_1.BaseState);
    exports.GameState = GameState;
});
//# sourceMappingURL=GameState.js.map
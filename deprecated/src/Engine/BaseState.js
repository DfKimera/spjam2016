define(["require", "exports", "../BlueWolf"], function (require, exports, BlueWolf_1) {
    var BaseState = (function () {
        function BaseState() {
        }
        BaseState.prototype.construct = function () {
            this.core = BlueWolf_1.BlueWolf.engine();
            this.game = BlueWolf_1.BlueWolf.game();
        };
        return BaseState;
    })();
    exports.BaseState = BaseState;
});
//# sourceMappingURL=BaseState.js.map
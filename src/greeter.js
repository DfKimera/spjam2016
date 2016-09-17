define(["require", "exports"], function (require, exports) {
    var Greeter = (function () {
        function Greeter() {
            console.log("Hey there!");
        }
        return Greeter;
    })();
    exports.Greeter = Greeter;
});
//# sourceMappingURL=greeter.js.map
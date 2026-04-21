package stubs;

import haxe.Timer;
import Reflect;

class TweenLite {
    public static function to(target:Dynamic, duration:Float, vars:Dynamic):Void {
        // Convert seconds → milliseconds
        var ms = Std.int(duration * 1000);

        Timer.delay(function() {
            // Apply properties (except special keys)
            for (field in Reflect.fields(vars)) {
                if (field == "onComplete" || field == "delay") continue;

                Reflect.setProperty(target, field, Reflect.field(vars, field));
            }

            // Call onComplete if present
            var cb = Reflect.field(vars, "onComplete");
            if (cb != null && Reflect.isFunction(cb)) {
                cb();
            }
        }, ms);
    }
}
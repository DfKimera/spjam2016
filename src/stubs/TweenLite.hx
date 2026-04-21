package stubs;

import haxe.Timer;
import Reflect;

class TweenLite {
    public static function to(target:Dynamic, duration:Float, vars:Dynamic):Void {
        var ms = Std.int(duration * 1000);
        var onUpdate:Dynamic = Reflect.field(vars, "onUpdate");
        var onComplete:Dynamic = Reflect.field(vars, "onComplete");

        var startTime = haxe.Timer.stamp();
        var timer = new haxe.Timer(16); // ~60fps ticks
        timer.run = function() {
            var elapsed = haxe.Timer.stamp() - startTime;
            var progress = duration > 0 ? Math.min(elapsed / duration, 1.0) : 1.0;

            // Interpolate numeric fields
            for (field in Reflect.fields(vars)) {
                if (field == "onComplete" || field == "onUpdate" || field == "delay") continue;
                var endVal:Dynamic = Reflect.field(vars, field);
                if (Std.isOfType(endVal, Float) || Std.isOfType(endVal, Int)) {
                    var startVal:Dynamic = Reflect.getProperty(target, field);
                    if (startVal == null) startVal = 0;
                    Reflect.setProperty(target, field, startVal + (endVal - startVal) * progress);
                } else {
                    Reflect.setProperty(target, field, endVal);
                }
            }

            if (onUpdate != null && Reflect.isFunction(onUpdate)) {
                onUpdate();
            }

            if (progress >= 1.0) {
                timer.stop();
                if (onComplete != null && Reflect.isFunction(onComplete)) {
                    onComplete();
                }
            }
        };
    }
}

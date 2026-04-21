import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import stubs.TweenLite;

class Utils {

    public static function fadeIn(object:FlxSprite, delay:Float, callback:ASFunction = null):Void {
        TweenLite.to(object, delay, {
            alpha: 1,
            onComplete: function() {
                if (Reflect.isFunction(callback)) {
                    callback();
                }
            }
        });
    }

    public static function fadeInGroup(group:FlxGroup, delay:Float, callback:ASFunction = null):Void {

        var target:ASAny = {alpha: 0};

        TweenLite.to(target, delay, {
            alpha: 1,
            onUpdate: function() {
                if (group.members != null) {
                    group.setAll("alpha", target.alpha);
                }
            },
            onComplete: function() {
                if (Reflect.isFunction(callback)) {
                    callback();
                }
            }
        });

    }

    public static function fadeOut(object:FlxSprite, delay:Float, callback:ASFunction = null):Void {
        TweenLite.to(object, delay, {
            alpha: 0,
            onComplete: function() {
                if (Reflect.isFunction(callback)) {
                    callback();
                }
            }
        });
    }

    public static function fadeOutGroup(group:FlxGroup, delay:Float, callback:ASFunction = null):Void {

        var target:ASAny = {alpha: 1};

        TweenLite.to(target, delay, {
            alpha: 0,
            onUpdate: function() {
                if (group.members != null) {
                    group.setAll("alpha", target.alpha);
                }
            },
            onComplete: function() {
                if (Reflect.isFunction(callback) && group.members != null) {
                    callback();
                }
            }
        });

    }

    public static function reverseArray(input:Array<ASAny>):Array<ASAny> {
        var out:Array<ASAny> = [];
        for (i in (0...input.length).reverse()) {
            out.push(input[i]);
        }
        return out;
    }

    public static function makeArray(length:Int):Array<ASAny> {
        var a:Array<ASAny> = [];

        for (i in 0...length) {
            a.push(null);
        }

        return a;
    }

    public static function hasItemOfType(obj:ASAny, key:String):Bool {
        for (_tmp_ in obj.___keys()) {
            var i:String = _tmp_;
            if (i == i) {
                return true;
            }
        }
        return false;
    }

    public static function resizeArray<T>(arr:Array<T>, newLength:Int, ?fill:T):Array<T> {
        var current = arr.length;

        if (newLength < current) {
            // shrink
            arr.splice(newLength, current - newLength);
        } else if (newLength > current) {
            // grow
            var value:T = fill;
            for (i in current...newLength) {
                arr.push(value);
            }
        }

        return arr;
    }

    public static function getTimerStamp():Int {
        return Std.int(haxe.Timer.stamp() * 1000);
    }

}


package;

import haxe.Timer;
import Reflect;
import Std;
import Math;

class ASCompat {
    public static inline var MAX_INT:Int = 0x7fffffff;
    public static inline var MAX_FLOAT:Float = 1.7976931348623157e308;
    public static inline var MIN_FLOAT:Float = 5e-324;

    // AS3-style "as" (very loose)
    public static inline function dynamicAs<T>(v:Dynamic, c:Class<T>):Null<T> {
        return Std.isOfType(v, c) ? cast v : null;
    }

    public static inline function toInt(v:Dynamic):Int {
        return Std.int(toNumber(v));
    }

    public static inline function toNumber(v:Dynamic):Float {
        if (v == null) return Math.NaN;
        if (Std.isOfType(v, Float) || Std.isOfType(v, Int)) return v;
        return Std.parseFloat(Std.string(v));
    }

    public static inline function toBool(v:Dynamic):Bool {
        if (v == null) return false;
        if (Std.isOfType(v, Bool)) return v;
        if (Std.isOfType(v, Int) || Std.isOfType(v, Float)) return v != 0;
        if (Std.isOfType(v, String)) return v != "" && v != "0" && v != "false";
        return true;
    }

    public static inline function stringAsBool(s:String):Bool {
        if (s == null) return false;
        var v = s.toLowerCase();
        return !(v == "" || v == "0" || v == "false" || v == "null");
    }

    public static inline function toString(v:Dynamic):String {
        return Std.string(v);
    }

    public static inline function toFixed(v:Dynamic, digits:Int):String {
        var n = toNumber(v);
        if (Math.isNaN(n)) return "NaN";
        return (untyped n).toFixed(digits);
    }

    public static function arraySetLength<T>(arr:Array<T>, len:Int):Int {
        if (len < arr.length) arr.splice(len, arr.length - len);
        else while (arr.length < len) arr.push(cast null);
        return arr.length;
    }

    // Flash-style setTimeout (returns timer so you can cancel if needed)
    public static function setTimeout(fn:Dynamic, delayMs:Int, ?args:Array<Dynamic>):Timer {
        var t = new Timer(delayMs);
        t.run = function() {
            t.stop();
            if (args != null)
                Reflect.callMethod(null, fn, args);
            else
                Reflect.callMethod(null, fn, []);
        };
        return t;
    }

    // Very loose sort emulation
    public static function sortWithOptions(arr:Array<Dynamic>, ?options:Dynamic):Array<Dynamic> {
        arr.sort(function(a, b) {
            var na = toNumber(a);
            var nb = toNumber(b);

            if (!Math.isNaN(na) && !Math.isNaN(nb)) {
                return na < nb ? -1 : (na > nb ? 1 : 0);
            }

            var sa = Std.string(a);
            var sb = Std.string(b);
            return sa < sb ? -1 : (sa > sb ? 1 : 0);
        });
        return arr;
    }
}
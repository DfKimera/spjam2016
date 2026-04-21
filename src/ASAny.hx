import Reflect;

@:forward
abstract ASAny(Dynamic) from Dynamic to Dynamic {
    public inline function new(v:Dynamic) {
        this = v;
    }

    @:arrayAccess
    public inline function get(key:String):Dynamic {
        return Reflect.field(this, key);
    }

    @:arrayAccess
    public inline function set(key:String, value:Dynamic):Dynamic {
        Reflect.setProperty(this, key, value);
        return value;
    }

    @:arrayAccess
    public inline function getInt(key:Int):Dynamic {
        return Reflect.field(this, Std.string(key));
    }

    @:arrayAccess
    public inline function setInt(key:Int, value:Dynamic):Dynamic {
        Reflect.setProperty(this, Std.string(key), value);
        return value;
    }
}
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
}
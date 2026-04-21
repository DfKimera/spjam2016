class Globals {
	public static function flash_utils_getQualifiedClassName(arg0:ASAny):String {
		if (arg0 == null) return "null";
		var cls = Type.getClass(arg0);
		if (cls != null) return Type.getClassName(cls);
		// arg0 may itself be a Class
		var name = Type.getClassName(arg0);
		if (name != null) return name;
		return Std.string(arg0);
	}
}

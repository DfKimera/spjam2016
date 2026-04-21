package {

import com.greensock.TweenLite;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;

public class Utils {

	public static function fadeIn(object:FlxSprite, delay:Number, callback:Function = null):TweenLite {
		return TweenLite.to(object, delay, {
			alpha: 1,
			onComplete: function ():void {
				if (callback is Function) {
					callback.call();
				}
			}
		});
	}

	public static function fadeInGroup(group:FlxGroup, delay:Number, callback:Function = null):TweenLite {

		var target:* = {alpha: 0};

		return TweenLite.to(target, delay, {
			alpha: 1,
			onUpdate: function ():void {
				if (group.members != null) {
					group.setAll("alpha", target.alpha);
				}
			},
			onComplete: function ():void {
				if (callback is Function) {
					callback.call();
				}
			}
		});

	}

	public static function fadeOut(object:FlxSprite, delay:Number, callback:Function = null):TweenLite {
		return TweenLite.to(object, delay, {
			alpha: 0,
			onComplete: function ():void {
				if (callback is Function) {
					callback.call();
				}
			}
		});
	}

	public static function fadeOutGroup(group:FlxGroup, delay:Number, callback:Function = null):TweenLite {

		var target:* = {alpha: 1};

		return TweenLite.to(target, delay, {
			alpha: 0,
			onUpdate: function ():void {
				if (group.members != null) {
					group.setAll("alpha", target.alpha);
				}
			},
			onComplete: function ():void {
				if (callback is Function && group.members != null) {
					callback.call();
				}
			}
		});

	}
	public static function reverseArray(input:Array):Array {
		var out:Array = [];
		for (var i:int = input.length - 1; i >= 0; i--) {
			out.push(input[i]);
		}
		return out;
	}

	public static function makeArray(length:int):Array {
		var a:Array = [];

		for (var i:int = 0; i < length; i++) {
			a.push(null);
		}

		return a;
	}

	public static function hasItemOfType(obj:*, key:String):Boolean {
		for (var i:String in obj) {
			if (i == i) {
				return true;
			}
		}
		return false;
	}

}
}

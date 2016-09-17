package {

	import com.greensock.TweenLite;

	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;

	public class Utils {

		public static function fadeIn(object:FlxSprite, delay:Number, callback:Function = null):TweenLite {
			return TweenLite.to(object, delay, {alpha: 1,
				onComplete: function():void {
					if(callback is Function) {
						callback.call();
					}
				}
			});
		}

		public static function fadeInGroup(group:FlxGroup, delay:Number, callback:Function = null):TweenLite {

			var target:Object = {alpha: 0};

			return TweenLite.to(target, delay, {alpha: 1,
				onUpdate: function():void {
					if(group.members != null) {
						group.setAll("alpha", target.alpha);
					}
				},
				onComplete: function():void {
					if(callback is Function) {
						callback.call();
					}
				}
			});

		}

		public static function fadeOut(object:FlxSprite, delay:Number, callback:Function = null):TweenLite {
			return TweenLite.to(object, delay, {alpha: 0,
				onComplete: function():void {
					if(callback is Function) {
						callback.call();
					}
				}
			});
		}

		public static function fadeOutGroup(group:FlxGroup, delay:Number, callback:Function = null):TweenLite {

			var target:Object = {alpha: 1};

			return TweenLite.to(target, delay, {alpha: 0,
				onUpdate: function():void {
					if(group.members != null) {
						group.setAll("alpha", target.alpha);
					}
				},
				onComplete: function():void {
					if(callback is Function && group.members != null) {
						callback.call();
					}
				}
			});

		}

	}
}

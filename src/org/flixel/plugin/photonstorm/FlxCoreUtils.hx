/**
 * FlxCoreUtils
 * -- Part of the Flixel Power Tools set
 *
 * v1.1 Added get mouseIndex and gameContainer
 * v1.0 First release with copyObject
 *
 * @version 1.1 - August 4th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
 */

package org.flixel.plugin.photonstorm ;

import flash.display.Sprite;
import flash.utils.ByteArray;

import org.flixel.*;

 class FlxCoreUtils {

	public function new() {
	}

	/**
	 * Performs a complete object deep-copy and returns a duplicate (not a reference)
	 *
	 * @param	value	The object you want copied
	 * @return	A copy of this object
	 */
	public static function copyObject(value:ASAny):ASAny {
		var buffer= new ByteArray();
		buffer.writeObject(value);
		buffer.position = 0;
		var result:ASAny = buffer.readObject();
		return result;
	}

	/**
	 * Returns the Display List index of the mouse pointer
	 */
	@:flash.property public static var mouseIndex(get,never):Int;
static function  get_mouseIndex():Int {
		var mouseIndex= -1;

		try {
			mouseIndex = FlxG.camera.getContainerSprite().parent.numChildren - 4;
		} catch (e:Error) {
			//trace
		}

		return mouseIndex;
	}

	/**
	 * Returns the Sprite that FlxGame extends (which contains the cameras, mouse, etc)
	 */
	@:flash.property public static var gameContainer(get,never):Sprite;
static function  get_gameContainer():Sprite {
		return cast(FlxG.camera.getContainerSprite().parent, Sprite);
	}

}


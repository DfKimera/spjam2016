/**
 * BaseFX - Special FX Plugin
 * -- Part of the Flixel Power Tools set
 *
 * v1.1 Fixed some documentation
 * v1.0 First release
 *
 * @version 1.1 - June 10th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
 */

package org.flixel.plugin.photonstorm.fx;

import flash.geom.Point;
import flash.geom.Rectangle;

import org.flixel.FlxSprite;

import flash.display.BitmapData;

 class BaseFX {
	/**
	 * Set to false to stop this effect being updated by the FlxSpecialFX Plugin. Set to true to enable.
	 */
	public var active:Bool = false;

	/**
	 * The FlxSprite into which the effect is drawn. Add this to your FlxState / FlxGroup to display the effect.
	 */
	public var sprite:FlxSprite;

	/**
	 * A scratch bitmapData used to build-up the effect before passing to sprite.pixels
	 */
	@:allow(org.flixel.plugin.photonstorm.FX) var canvas:BitmapData;

	/**
	 * TODO A snapshot of the sprite background before the effect is applied
	 */
	@:allow(org.flixel.plugin.photonstorm.FX) var back:BitmapData;

	@:allow(org.flixel.plugin.photonstorm.FX) var image:BitmapData;
	@:allow(org.flixel.plugin.photonstorm.FX) var sourceRef:FlxSprite;
	@:allow(org.flixel.plugin.photonstorm.FX) var updateFromSource:Bool = false;
	@:allow(org.flixel.plugin.photonstorm.FX) var clsRect:Rectangle;
	@:allow(org.flixel.plugin.photonstorm.FX) var clsPoint:Point;
	@:allow(org.flixel.plugin.photonstorm.FX) var clsColor:UInt = 0;

	//	For staggered drawing updates
	@:allow(org.flixel.plugin.photonstorm.FX) var updateLimit:UInt = 0;
	@:allow(org.flixel.plugin.photonstorm.FX) var lastUpdate:UInt = 0;
	@:allow(org.flixel.plugin.photonstorm.FX) var ready:Bool = false;

	@:allow(org.flixel.plugin.photonstorm.FX) var copyRect:Rectangle;
	@:allow(org.flixel.plugin.photonstorm.FX) var copyPoint:Point;

	public function new() {
		active = false;
	}

	/**
	 * Starts the effect runnning
	 *
	 * @param	delay	How many "game updates" should pass between each update? If your game runs at 30fps a value of 0 means it will do 30 updates per second. A value of 1 means it will do 15 updates per second, etc.
	 */
	public function start(delay:UInt = 0) {
		updateLimit = delay;
		lastUpdate = 0;
		ready = true;
	}

	/**
	 * Pauses the effect from running. The draw function is still called each loop, but the pixel data is stopped from updating.<br>
	 * To disable the SpecialFX Plugin from calling the FX at all set the "active" parameter to false.
	 */
	public function stop() {
		ready = false;
	}

	public function destroy() {
		if (sprite != null) {
			sprite.kill();
		}

		if (canvas != null) {
			canvas.dispose();
		}

		if (back != null) {
			back.dispose();
		}

		if (image != null) {
			image.dispose();
		}

		sourceRef = null;

		active = false;
	}

}


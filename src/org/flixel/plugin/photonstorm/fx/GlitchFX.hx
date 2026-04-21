/**
 * GlitchFX - Special FX Plugin
 * -- Part of the Flixel Power Tools set
 *
 * v1.2 Fixed updateFromSource github issue #8 (thanks CoderBrandon)
 * v1.1 Added changeGlitchValues support
 * v1.0 First release
 *
 * @version 1.2 - August 8th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
 */

package org.flixel.plugin.photonstorm.fx;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

import org.flixel.*;
import org.flixel.plugin.photonstorm.*;

/**
 * Creates a static / glitch / monitor-corruption style effect on an FlxSprite
 *
 * TODO:
 *
 * Add reduction from really high glitch value down to zero, will smooth the image into place and look cool :)
 * Add option to glitch vertically?
 *
 */
 class GlitchFX extends BaseFX {
	var glitchSize:UInt = 0;
	var glitchSkip:UInt = 0;

	public function new() {
		super();
	}

	public function createFromFlxSprite(source:FlxSprite, maxGlitch:UInt, maxSkip:UInt, autoUpdate:Bool = false, backgroundColor:UInt = 0x0):FlxSprite {
		sprite = new FlxSprite(source.x, source.y).makeGraphic(Std.int(source.width + maxGlitch), Std.int(source.height), backgroundColor);

		canvas = new BitmapData(Std.int(sprite.width), Std.int(sprite.height), true, backgroundColor);

		image = source.pixels;

		updateFromSource = autoUpdate;

		if (updateFromSource) {
			sourceRef = source;
		}

		glitchSize = maxGlitch;
		glitchSkip = maxSkip;

		clsColor = backgroundColor;
		clsRect = new Rectangle(0, 0, canvas.width, canvas.height);

		copyPoint = new Point(0, 0);
		copyRect = new Rectangle(0, 0, image.width, 1);

		active = true;

		return sprite;
	}

	public function changeGlitchValues(maxGlitch:UInt, maxSkip:UInt) {
		glitchSize = maxGlitch;
		glitchSkip = maxSkip;
	}

	public function draw() {
		if (ready) {
			if (lastUpdate != updateLimit) {
				lastUpdate++;

				return;
			}

			if (updateFromSource && sourceRef.exists) {
				image = sourceRef.framePixels;
			}

			canvas.lock();
			canvas.fillRect(clsRect, clsColor);

			var rndSkip:UInt = 1 + Std.int(Math.random() * glitchSkip);

			copyRect.y = 0;
			copyPoint.y = 0;
			copyRect.height = rndSkip;

			var y= 0;while (y < sprite.height) {
				copyPoint.x = Std.int(Math.random() * glitchSize);
				canvas.copyPixels(image, copyRect, copyPoint);

				copyRect.y += rndSkip;
				copyPoint.y += rndSkip;
y += rndSkip;
			}

			canvas.unlock();

			lastUpdate = 0;

			sprite.pixels = canvas;
			sprite.dirty = true;
		}
	}

}


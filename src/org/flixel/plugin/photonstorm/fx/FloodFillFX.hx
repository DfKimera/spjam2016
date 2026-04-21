/**
 * FloodFillFX - Special FX Plugin
 * -- Part of the Flixel Power Tools set
 *
 * v1.1 Renamed - was "DropDown", but now a more accurate "flood fill"
 * v1.0 First release
 *
 * @version 1.1 - May 31st 2011
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
 * Creates a flood fill effect FlxSprite, useful for bringing in images in cool ways
 */
 class FloodFillFX extends BaseFX {
	var complete:Bool = false;
	var chunk:UInt = 0;
	var offset:UInt = 0;
	var dropDirection:UInt = 0;
	var dropRect:Rectangle;
	var dropPoint:Point;
	var dropY:UInt = 0;

	public function new() {
		super();
	}

	/**
	 * Creates a new Flood Fill effect from the given image
	 *
	 * @param	source				The source image bitmapData to use for the drop
	 * @param	x					The x coordinate to place the resulting effect sprite
	 * @param	y					The y coordinate to place the resulting effect sprite
	 * @param	width				The width of the resulting effet sprite. Doesn't have to match the source image
	 * @param	height				The height of the resulting effet sprite. Doesn't have to match the source image
	 * @param	direction			0 = Top to bottom. 1 = Bottom to top. 2 = Left to Right. 3 = Right to Left.
	 * @param	pixels				How many pixels to drop per update (default 1)
	 * @param	split				Boolean (default false) - if split it will drop from opposite sides at the same time
	 * @param	backgroundColor		The background colour of the FlxSprite the effect is drawn in to (default 0x0 = transparent)
	 *
	 * @return	An FlxSprite with the effect ready to run in it
	 */
	public function create(source:FlxSprite, x:Int, y:Int, width:UInt, height:UInt, direction:UInt = 0, pixels:UInt = 1, split:Bool = false, backgroundColor:UInt = 0x0):FlxSprite {
		sprite = new FlxSprite(x, y).makeGraphic(width, height, backgroundColor);

		canvas = new BitmapData(width, height, true, backgroundColor);

		if ((source.pixels.width : UInt) != width || (source.pixels.height : UInt) != height) {
			image = new BitmapData(width, height, true, backgroundColor);
			image.copyPixels(source.pixels, new Rectangle(0, 0, source.pixels.width, source.pixels.height), new Point(0, height - source.pixels.height));
		} else {
			image = source.pixels;
		}

		offset = pixels;

		dropDirection = direction;
		dropRect = new Rectangle(0, canvas.height - offset, canvas.width, offset);
		dropPoint = new Point(0, 0);
		dropY = canvas.height;

		active = true;

		return sprite;
	}

	public function draw() {
		if (ready && complete == false) {
			if (lastUpdate != updateLimit) {
				lastUpdate++;

				return;
			}

			canvas.lock();

			switch (dropDirection) {
					//	Dropping Down
				case 0:

					//	Get a pixel strip from the picture (starting at the bottom and working way up)
					var y= 0;while ((y : UInt) < dropY) {
						dropPoint.y = y;
						canvas.copyPixels(image, dropRect, dropPoint);
y += offset;
					}

					dropY -= offset;

					dropRect.y -= offset;

					if (dropY <= 0) {
						complete = true;
					}

					
			}

			lastUpdate = 0;

			canvas.unlock();

			sprite.pixels = canvas;
			sprite.dirty = true;
		}
	}

}


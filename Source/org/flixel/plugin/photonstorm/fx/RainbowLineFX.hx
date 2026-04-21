/**
 * RainbowLineFX - A Special FX Plugin
 * -- Part of the Flixel Power Tools set
 *
 * v1.0 Built into the new FlxSpecialFX system
 *
 * @version 1.0 - May 9th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
 * @see Requires FlxGradient, FlxMath
 */

package org.flixel.plugin.photonstorm.fx;

import flash.display.BitmapData;
import flash.geom.Rectangle;

import org.flixel.*;
import org.flixel.plugin.photonstorm.*;

/**
 * Creates a Rainbow Line Effect - typically a rainbow sequence of color values passing through a 1px high line
 */
 class RainbowLineFX extends BaseFX {
	var lineColors:Array<ASAny>;
	var maxColor:UInt = 0;
	var currentColor:UInt = 0;
	var fillRect:Rectangle;
	var speed:UInt = 0;
	var chunk:UInt = 0;
	var direction:UInt = 0;
	var setPixel:Bool = false;

	public function new() {
		super();
	}

	/**
	 * Creates a Color Line FlxSprite.
	 *
	 * @param	x			The x coordinate of the FlxSprite in game world pixels
	 * @param	y			The y coordinate of the FlxSprite in game world pixels
	 * @param	width		The width of the FlxSprite in pixels
	 * @param	height		The height of the FlxSprite in pixels
	 * @param	colors		An Array of color values used to create the line. If null (default) the HSV Color Wheel is used, giving a full spectrum rainbow effect
	 * @param	colorWidth	The width of the color range controls how much interpolation occurs between each color in the colors array (default 360)
	 * @param	colorSpeed	The speed at which the Rainbow Line cycles through its colors (default 1)
	 * @param	stepSize	The size of each "chunk" of the Rainbow Line - use a higher value for a more retro look (default 1)
	 * @param	fadeWidth	If you want the Line to fade from fadeColor to the first color in the colors array, and then out again, set this value to the amount of transition you want (128 looks good)
	 * @param	fadeColor	The default fade color is black, but if you need to alpha it, or change for a different color, set it here
	 *
	 * @return	An FlxSprite which automatically updates each draw() to cycle the colors through it
	 */
	public function create(x:Int, y:Int, width:UInt, height:UInt = 1, colors:Array<ASAny> = null, colorWidth:UInt = 360, colorSpeed:UInt = 1, stepSize:UInt = 1, fadeWidth:UInt = 128, fadeColor:UInt = 0xff000000):FlxSprite {
		sprite = new FlxSprite(x, y).makeGraphic(width, height, 0x0);

		canvas = new BitmapData(width, height, true, 0x0);

		if (Std.is(colors , Array)) {
			lineColors = FlxGradient.createGradientArray(1, colorWidth, colors);
		} else {
			lineColors = FlxColor.getHSVColorWheel();
		}

		currentColor = 0;
		maxColor = lineColors.length - 1;

		if (fadeWidth != 0) {
			var blackToFirst= FlxGradient.createGradientArray(1, fadeWidth, [fadeColor, fadeColor, fadeColor, lineColors[0]]);
			var lastToBlack= FlxGradient.createGradientArray(1, fadeWidth, [lineColors[maxColor], fadeColor, fadeColor, fadeColor, fadeColor]);

			var fadingColours= blackToFirst.concat(lineColors);
			fadingColours = fadingColours.concat(lastToBlack);

			lineColors = fadingColours;

			maxColor = lineColors.length - 1;
		}

		direction = 0;
		setPixel = false;
		speed = colorSpeed;
		chunk = stepSize;
		fillRect = new Rectangle(0, 0, chunk, height);

		if (height == 1 && chunk == 1) {
			setPixel = true;
		}

		active = true;

		return sprite;
	}

	/**
	 * Change the colors cycling through the line by passing in a new array of color values
	 *
	 * @param	colors				An Array of color values used to create the line. If null (default) the HSV Color Wheel is used, giving a full spectrum rainbow effect
	 * @param	colorWidth			The width of the color range controls how much interpolation occurs between each color in the colors array (default 360)
	 * @param	resetCurrentColor	If true the color pointer is returned to the start of the new color array, otherwise remains where it is
	 * @param	fadeWidth			If you want the Rainbow Line to fade from black to the first color in the colors array, and then out again, set this value to the amount of transition you want (128 looks good)
	 * @param	fadeColor			The default fade color is black, but if you need to alpha it, or change for a different color, set it here
	 */
	public function updateColors(colors:Array<ASAny>, colorWidth:UInt = 360, resetCurrentColor:Bool = false, fadeWidth:UInt = 128, fadeColor:UInt = 0xff000000) {
		if (Std.is(colors , Array)) {
			lineColors = FlxGradient.createGradientArray(1, colorWidth, colors);
		} else {
			lineColors = FlxColor.getHSVColorWheel();
		}

		maxColor = lineColors.length - 1;

		if (fadeWidth != 0) {
			var blackToFirst= FlxGradient.createGradientArray(1, fadeWidth, [0xff000000, 0xff000000, 0xff000000, lineColors[0]]);
			var lastToBlack= FlxGradient.createGradientArray(1, fadeWidth, [lineColors[maxColor], 0xff000000, 0xff000000, 0xff000000, 0xff000000]);

			var fadingColours= blackToFirst.concat(lineColors);
			fadingColours = fadingColours.concat(lastToBlack);

			lineColors = fadingColours;

			maxColor = lineColors.length - 1;
		}

		if (currentColor > maxColor || resetCurrentColor) {
			currentColor = 0;
		}
	}

	/**
	 * Doesn't need to be called directly as it's called by the FlxSpecialFX Plugin.<br>
	 * Set active to false if you wish to disable the effect.<br>
	 * Pass the effect to FlxSpecialFX.erase() if you wish to destroy this effect.
	 */
	public function draw() {
		canvas.lock();

		fillRect.x = 0;

		var x= 0;while (x < canvas.width) {
			var c= FlxMath.wrapValue(currentColor + x, 1, maxColor);

			if (setPixel) {
				canvas.setPixel32(x, 0, lineColors[c]);
			} else {
				canvas.fillRect(fillRect, lineColors[c]);
				fillRect.x += chunk;
			}
x = x + chunk;
		}

		canvas.unlock();

		if (direction == 0) {
			currentColor += speed;

			if (currentColor >= maxColor) {
				currentColor = 0;
			}
		} else {
			currentColor -= speed;

			if (currentColor < 0) {
				currentColor = maxColor;
			}
		}

		sprite.pixels = canvas;
		sprite.dirty = true;
	}

	/**
	 * Set the speed at which the Line cycles through its colors
	 */
	
	/**
	 * The speed at which the Line cycles through its colors
	 */
	@:flash.property public var colorSpeed(get,set):UInt;
function  set_colorSpeed(value:UInt):UInt{
		if (value < maxColor) {
			speed = value;
		}
return value;
	}
function  get_colorSpeed():UInt {
		return speed;
	}

	/**
	 * Set the size of each "chunk" of the Line. Use a higher value for a more retro look
	 */
	
	/**
	 * The size of each "chunk" of the Line
	 */
	@:flash.property public var stepSize(get,set):UInt;
function  set_stepSize(value:UInt):UInt{
		if (value < (canvas.width : UInt) && value > 0) {
			canvas.fillRect(new Rectangle(0, 0, canvas.width, canvas.height), 0x0);
			chunk = value;

			fillRect.x = 0;
			fillRect.width = chunk;

			if (value > 1) {
				setPixel = false;
			} else {
				setPixel = true;
			}
		}
return value;
	}
function  get_stepSize():UInt {
		return chunk;
	}

	/**
	 * Changes the color cycle direction.
	 *
	 * @param	newDirection	0 = Colors cycle incrementally (line looks like it is moving to the left), 1 = Colors decrement (line moves to the right)
	 */
	public function setDirection(newDirection:UInt) {
		if (newDirection == 0 || newDirection == 1) {
			direction = newDirection;
		}
	}

}


/**
 * PlasmaFX - Special FX Plugin
 * -- Part of the Flixel Power Tools set
 *
 * v1.4 Moved to the new Special FX Plugins
 * v1.3 Colours updated to include alpha values
 * v1.2 Updated for the Flixel 2.5 Plugin system
 *
 * @version 1.4 - May 8th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
 */

package org.flixel.plugin.photonstorm.fx;

import flash.display.BitmapData;

import org.flixel.*;
import org.flixel.plugin.photonstorm.*;

/**
 * Creates a plasma effect FlxSprite
 */

 class PlasmaFX extends BaseFX {
	//private var pos1:uint;
	//private var pos2:uint;
	//private var pos3:uint;
	//private var pos4:uint;

	public var pos1:UInt = 0;
	public var pos2:UInt = 0;
	public var pos3:UInt = 0;
	public var pos4:UInt = 0;
	public var depth:UInt = 128;

	var tpos1:UInt = 0;
	var tpos2:UInt = 0;
	var tpos3:UInt = 0;
	var tpos4:UInt = 0;

	var aSin:Array<ASAny>;
	//private var previousColour:uint;
	var colours:Array<ASAny>;
	var step:UInt = 0;
	var span:UInt = 0;

	public function new(){
		super();
	}

	public function create(x:Int, y:Int, width:UInt, height:UInt, scaleX:UInt = 1, scaleY:UInt = 1):FlxSprite {
		sprite = new FlxSprite(x, y).makeGraphic(width, height, 0x0);

		if (scaleX != 1 || scaleY != 1) {
			sprite.scale = new FlxPoint(scaleX, scaleY);
			sprite.x += width / scaleX;
			sprite.y += height / scaleY;
		}

		canvas = new BitmapData(width, height, true, 0x0);

		colours = FlxColor.getHSVColorWheel();

		//colours = FlxColor.getHSVColorWheel(140);	// now supports alpha :)
		//colours = FlxGradient.createGradientArray(1, 360, [0xff000000, 0xff000000, 0xff000000, 0x00000000, 0xff000000], 2);	//	Lovely black reveal for over an image
		//colours = FlxGradient.createGradientArray(1, 360, [0xff0000FF, 0xff000000, 0xff8F107C, 0xff00FFFF, 0xff0000FF], 1); // lovely purple black blue thingy

		span = colours.length - 1;

		aSin = Utils.makeArray(512);

		for (i in 0...512) {
			//var rad:Number = (i * 0.703125) * 0.0174532;
			var rad= (i * 0.703125) * 0.0174532;

			//	Any power of 2!
			//	http://www.vaughns-1-pagers.com/computer/powers-of-2.htm
			//	256, 512, 1024, 2048, 4096, 8192, 16384
			aSin[i] = Math.sin(rad) * 1024;

			//aSin[i] = Math.cos(rad) * 1024;
		}

		active = true;

		tpos1 = 293;
		tpos2 = 483;
		tpos3 = 120;
		tpos4 = 360;

		pos1 = 0;
		pos2 = 5;
		pos3 = 0;
		pos4 = 0;

		return sprite;
	}

	public function draw() {
		if (step < 10) {
			//trace(step, tpos1, tpos2, tpos3, tpos4, pos1, pos2, pos3, pos4, index);
			step++;
		}

		tpos4 = pos4;
		tpos3 = pos3;

		canvas.lock();

		var y= 0;while (y < canvas.height) {
			tpos1 = pos1 + 5;
			tpos2 = pos2 + 3;

			//tpos1 = pos1;
			//tpos2 = pos2;

			tpos2 &= 511;
			tpos3 &= 511;

			var x= 0;while (x < canvas.width) {
				tpos1 &= 511;
				tpos2 &= 511;

				var x2= Std.int(ASCompat.toNumber(aSin[tpos1]) + ASCompat.toNumber(aSin[tpos2]) + ASCompat.toNumber(aSin[tpos3]) + ASCompat.toNumber(aSin[tpos4]));

				//var index:int = depth + (x2 >> 4);
				var index:Int = depth + (x2 >> 4);
				//p = (128 + (p >> 4)) & 255;


				if (index <= 0) {
					index += span;
				}

				if ((index : UInt) >= span) {
					index -= span;
				}

				canvas.setPixel32(x, y, colours[index]);

				tpos1 += 5;
				tpos2 += 3;
x++;
			}

			tpos3 += 1;
			tpos4 += 3;
y++;
		}

		canvas.unlock();

		sprite.pixels = canvas;
		sprite.dirty = true;

		pos1 += 4;	// horizontal shift
		pos3 += 2;	// vertical shift
	}

}


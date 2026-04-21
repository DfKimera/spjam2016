/**
 * FlxCollision
 * -- Part of the Flixel Power Tools set
 *
 * v1.6 Fixed bug in pixelPerfectCheck that stopped non-square rotated objects from colliding properly (thanks to joon on the flixel forums for spotting)
 * v1.5 Added createCameraWall
 * v1.4 Added pixelPerfectPointCheck()
 * v1.3 Update fixes bug where it wouldn't accurately perform collision on AutoBuffered rotated sprites, or sprites with offsets
 * v1.2 Updated for the Flixel 2.5 Plugin system
 *
 * @version 1.6 - October 8th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
 */

package org.flixel.plugin.photonstorm ;

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.display.BlendMode;

import org.flixel.*;

 class FlxCollision {
	public static var debug:BitmapData = new BitmapData(1, 1, false);

	public static var CAMERA_WALL_OUTSIDE:UInt = 0;
	public static var CAMERA_WALL_INSIDE:UInt = 1;

	public function new() {
	}

	/**
	 * A Pixel Perfect Collision check between two FlxSprites.
	 * It will do a bounds check first, and if that passes it will run a pixel perfect match on the intersecting area.
	 * Works with rotated, scaled and animated sprites.
	 *
	 * @param	contact			The first FlxSprite to test against
	 * @param	target			The second FlxSprite to test again, sprite order is irrelevant
	 * @param	alphaTolerance	The tolerance value above which alpha pixels are included. Default to 255 (must be fully opaque for collision).
	 * @param	camera			If the collision is taking place in a camera other than FlxG.camera (the default/current) then pass it here
	 *
	 * @return	Boolean True if the sprites collide, false if not
	 */
	public static function pixelPerfectCheck(contact:FlxSprite, target:FlxSprite, alphaTolerance:Int = 255, camera:FlxCamera = null):Bool {
		var pointA= new Point();
		var pointB= new Point();

		if (camera != null) {
			pointA.x = contact.x - Std.int(camera.scroll.x * contact.scrollFactor.x) - contact.offset.x;
			pointA.y = contact.y - Std.int(camera.scroll.y * contact.scrollFactor.y) - contact.offset.y;

			pointB.x = target.x - Std.int(camera.scroll.x * target.scrollFactor.x) - target.offset.x;
			pointB.y = target.y - Std.int(camera.scroll.y * target.scrollFactor.y) - target.offset.y;
		} else {
			pointA.x = contact.x - Std.int(FlxG.camera.scroll.x * contact.scrollFactor.x) - contact.offset.x;
			pointA.y = contact.y - Std.int(FlxG.camera.scroll.y * contact.scrollFactor.y) - contact.offset.y;

			pointB.x = target.x - Std.int(FlxG.camera.scroll.x * target.scrollFactor.x) - target.offset.x;
			pointB.y = target.y - Std.int(FlxG.camera.scroll.y * target.scrollFactor.y) - target.offset.y;
		}

		var boundsA= new Rectangle(pointA.x, pointA.y, contact.framePixels.width, contact.framePixels.height);
		var boundsB= new Rectangle(pointB.x, pointB.y, target.framePixels.width, target.framePixels.height);

		var intersect= boundsA.intersection(boundsB);

		if (intersect.isEmpty() || intersect.width == 0 || intersect.height == 0) {
			return false;
		}

		//	Normalise the values or it'll break the BitmapData creation below
		intersect.x = Math.ffloor(intersect.x);
		intersect.y = Math.ffloor(intersect.y);
		intersect.width = Math.fceil(intersect.width);
		intersect.height = Math.fceil(intersect.height);

		if (intersect.isEmpty()) {
			return false;
		}

		//	Thanks to Chris Underwood for helping with the translate logic :)

		var matrixA= new Matrix();
		matrixA.translate(-(intersect.x - boundsA.x), -(intersect.y - boundsA.y));

		var matrixB= new Matrix();
		matrixB.translate(-(intersect.x - boundsB.x), -(intersect.y - boundsB.y));

		var testA= contact.framePixels;
		var testB= target.framePixels;
		var overlapArea= new BitmapData(Std.int(intersect.width), Std.int(intersect.height), false);

		overlapArea.draw(testA, matrixA, new ColorTransform(1, 1, 1, 1, 255, -255, -255, alphaTolerance), BlendMode.NORMAL);
		overlapArea.draw(testB, matrixB, new ColorTransform(1, 1, 1, 1, 255, 255, 255, alphaTolerance), BlendMode.DIFFERENCE);

		//	Developers: If you'd like to see how this works, display it in your game somewhere. Or you can comment it out to save a tiny bit of performance
		debug = overlapArea;

		var overlap= overlapArea.getColorBoundsRect(0xffffffff, 0xff00ffff);
		overlap.offset(intersect.x, intersect.y);

		if (overlap.isEmpty()) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * A Pixel Perfect Collision check between a given x/y coordinate and an FlxSprite<br>
	 *
	 * @param	pointX			The x coordinate of the point given in local space (relative to the FlxSprite, not game world coordinates)
	 * @param	pointY			The y coordinate of the point given in local space (relative to the FlxSprite, not game world coordinates)
	 * @param	target			The FlxSprite to check the point against
	 * @param	alphaTolerance	The alpha tolerance level above which pixels are counted as colliding. Default to 255 (must be fully transparent for collision)
	 *
	 * @return	Boolean True if the x/y point collides with the FlxSprite, false if not
	 */
	public static function pixelPerfectPointCheck(pointX:UInt, pointY:UInt, target:FlxSprite, alphaTolerance:Int = 255):Bool {
		//	Intersect check
		if (FlxMath.pointInCoordinates(pointX, pointY, Std.int(target.x), Std.int(target.y), target.framePixels.width, target.framePixels.height) == false) {
			return false;
		}

		//	How deep is pointX/Y within the rect?
		var test= target.framePixels;

		if (FlxColor.getAlpha(test.getPixel32(Std.int(pointX - target.x), Std.int(pointY - target.y))) >= (alphaTolerance : UInt)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Creates a "wall" around the given camera which can be used for FlxSprite collision
	 *
	 * @param	camera				The FlxCamera to use for the wall bounds (can be FlxG.camera for the current one)
	 * @param	placement			CAMERA_WALL_OUTSIDE or CAMERA_WALL_INSIDE
	 * @param	thickness			The thickness of the wall in pixels
	 * @param	adjustWorldBounds	Adjust the FlxG.worldBounds based on the wall (true) or leave alone (false)
	 *
	 * @return	FlxGroup The 4 FlxTileblocks that are created are placed into this FlxGroup which should be added to your State
	 */
	public static function createCameraWall(camera:FlxCamera, placement:UInt, thickness:UInt, adjustWorldBounds:Bool = false):FlxGroup {
		var left:FlxTileblock = null;
		var right:FlxTileblock = null;
		var top:FlxTileblock = null;
		var bottom:FlxTileblock = null;

		switch (placement) {
			case (_ == CAMERA_WALL_OUTSIDE => true):
				left = new FlxTileblock(Std.int(camera.x - thickness), Std.int(camera.y + thickness), thickness, camera.height - (thickness * 2));
				right = new FlxTileblock(Std.int(camera.x + camera.width), Std.int(camera.y + thickness), thickness, camera.height - (thickness * 2));
				top = new FlxTileblock(Std.int(camera.x - thickness), Std.int(camera.y - thickness), camera.width + thickness * 2, thickness);
				bottom = new FlxTileblock(Std.int(camera.x - thickness), camera.height, camera.width + thickness * 2, thickness);

				if (adjustWorldBounds) {
					FlxG.worldBounds = new FlxRect(camera.x - thickness, camera.y - thickness, camera.width + thickness * 2, camera.height + thickness * 2);
				}
				

			case (_ == CAMERA_WALL_INSIDE => true):
				left = new FlxTileblock(Std.int(camera.x), Std.int(camera.y + thickness), thickness, camera.height - (thickness * 2));
				right = new FlxTileblock(Std.int(camera.x + camera.width - thickness), Std.int(camera.y + thickness), thickness, camera.height - (thickness * 2));
				top = new FlxTileblock(Std.int(camera.x), Std.int(camera.y), camera.width, thickness);
				bottom = new FlxTileblock(Std.int(camera.x), camera.height - thickness, camera.width, thickness);

				if (adjustWorldBounds) {
					FlxG.worldBounds = new FlxRect(camera.x, camera.y, camera.width, camera.height);
				}
				

default:
		}

		var result= new FlxGroup(4);

		result.add(left);
		result.add(right);
		result.add(top);
		result.add(bottom);

		return result;
	}

}


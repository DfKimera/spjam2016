/**
 * Bullet
 * -- Part of the Flixel Power Tools set
 *
 * v1.2 Removed "id" and used the FlxSprite ID value instead
 * v1.1 Updated to support fire callbacks, sounds, random variances and lifespan
 * v1.0 First release
 *
 * @version 1.2 - October 10th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
 */

package org.flixel.plugin.photonstorm.baseTypes;

import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.plugin.photonstorm.FlxMath;
import org.flixel.plugin.photonstorm.FlxVelocity;
import org.flixel.plugin.photonstorm.FlxWeapon;

 class Bullet extends FlxSprite {
	var weapon:FlxWeapon;

	var bulletSpeed:Int = 0;

	//	Acceleration or Velocity?
	public var accelerates:Bool = false;
	public var xAcceleration:Int = 0;
	public var yAcceleration:Int = 0;

	public var rndFactorAngle:UInt = 0;
	public var rndFactorSpeed:UInt = 0;
	public var rndFactorLifeSpan:UInt = 0;
	public var lifespan:UInt = 0;
	public var launchTime:UInt = 0;
	public var expiresTime:UInt = 0;

	var animated:Bool = false;

	public function new(weapon:FlxWeapon, id:UInt) {
		super(0, 0);

		this.weapon = weapon;
		this.ID = id;

		//	Safe defaults
		accelerates = false;
		animated = false;
		bulletSpeed = 0;

		exists = false;
	}

	/**
	 * Adds a new animation to the sprite.
	 *
	 * @param	Name		What this animation should be called (e.g. "run").
	 * @param	Frames		An array of numbers indicating what frames to play in what order (e.g. 1, 2, 3).
	 * @param	FrameRate	The speed in frames per second that the animation should play at (e.g. 40 fps).
	 * @param	Looped		Whether or not the animation is looped or just plays once.
	 */
	override public function addAnimation(Name:String, Frames:Array<ASAny>, FrameRate:Float = 0, Looped:Bool = true) {
		super.addAnimation(Name, Frames, FrameRate, Looped);

		animated = true;
	}

	public function fire(fromX:Int, fromY:Int, velX:Int, velY:Int) {
		x = fromX + FlxMath.rand(-weapon.rndFactorPosition.x, weapon.rndFactorPosition.x);
		y = fromY + FlxMath.rand(-weapon.rndFactorPosition.y, weapon.rndFactorPosition.y);

		if (accelerates) {
			acceleration.x = xAcceleration + FlxMath.rand(-weapon.rndFactorSpeed, weapon.rndFactorSpeed);
			acceleration.y = yAcceleration + FlxMath.rand(-weapon.rndFactorSpeed, weapon.rndFactorSpeed);
		} else {
			velocity.x = velX + FlxMath.rand(-weapon.rndFactorSpeed, weapon.rndFactorSpeed);
			velocity.y = velY + FlxMath.rand(-weapon.rndFactorSpeed, weapon.rndFactorSpeed);
		}

		postFire();
	}

	public function fireAtMouse(fromX:Int, fromY:Int, speed:Int) {
		x = fromX + FlxMath.rand(-weapon.rndFactorPosition.x, weapon.rndFactorPosition.x);
		y = fromY + FlxMath.rand(-weapon.rndFactorPosition.y, weapon.rndFactorPosition.y);

		if (accelerates) {
			FlxVelocity.accelerateTowardsMouse(this, speed + FlxMath.rand(-weapon.rndFactorSpeed, weapon.rndFactorSpeed), Std.int(maxVelocity.x), Std.int(maxVelocity.y));
		} else {
			FlxVelocity.moveTowardsMouse(this, speed + FlxMath.rand(-weapon.rndFactorSpeed, weapon.rndFactorSpeed));
		}

		postFire();
	}

	public function fireAtPosition(fromX:Int, fromY:Int, toX:Int, toY:Int, speed:Int) {
		x = fromX + FlxMath.rand(-weapon.rndFactorPosition.x, weapon.rndFactorPosition.x);
		y = fromY + FlxMath.rand(-weapon.rndFactorPosition.y, weapon.rndFactorPosition.y);

		if (accelerates) {
			FlxVelocity.accelerateTowardsPoint(this, new FlxPoint(toX, toY), speed + FlxMath.rand(-weapon.rndFactorSpeed, weapon.rndFactorSpeed), Std.int(maxVelocity.x), Std.int(maxVelocity.y));
		} else {
			FlxVelocity.moveTowardsPoint(this, new FlxPoint(toX, toY), speed + FlxMath.rand(-weapon.rndFactorSpeed, weapon.rndFactorSpeed));
		}

		postFire();
	}

	public function fireAtTarget(fromX:Int, fromY:Int, target:FlxSprite, speed:Int) {
		x = fromX + FlxMath.rand(-weapon.rndFactorPosition.x, weapon.rndFactorPosition.x);
		y = fromY + FlxMath.rand(-weapon.rndFactorPosition.y, weapon.rndFactorPosition.y);

		if (accelerates) {
			FlxVelocity.accelerateTowardsObject(this, target, speed + FlxMath.rand(-weapon.rndFactorSpeed, weapon.rndFactorSpeed), Std.int(maxVelocity.x), Std.int(maxVelocity.y));
		} else {
			FlxVelocity.moveTowardsObject(this, target, speed + FlxMath.rand(-weapon.rndFactorSpeed, weapon.rndFactorSpeed));
		}

		postFire();
	}

	public function fireFromAngle(fromX:Int, fromY:Int, fireAngle:Int, speed:Int) {
		x = fromX + FlxMath.rand(-weapon.rndFactorPosition.x, weapon.rndFactorPosition.x);
		y = fromY + FlxMath.rand(-weapon.rndFactorPosition.y, weapon.rndFactorPosition.y);

		var newVelocity= FlxVelocity.velocityFromAngle(fireAngle + FlxMath.rand(-weapon.rndFactorAngle, weapon.rndFactorAngle), speed + FlxMath.rand(-weapon.rndFactorSpeed, weapon.rndFactorSpeed));

		if (accelerates) {
			acceleration.x = newVelocity.x;
			acceleration.y = newVelocity.y;
		} else {
			velocity.x = newVelocity.x;
			velocity.y = newVelocity.y;
		}

		postFire();
	}

	function postFire() {
		if (animated) {
			play("fire");
		}

		if (weapon.bulletElasticity > 0) {
			elasticity = weapon.bulletElasticity;
		}

		exists = true;

		launchTime = Utils.getTimerStamp();

		if (weapon.bulletLifeSpan > 0) {
			lifespan = weapon.bulletLifeSpan + FlxMath.rand(-weapon.rndFactorLifeSpan, weapon.rndFactorLifeSpan);
			expiresTime = Utils.getTimerStamp() + lifespan;
		}

		if (Reflect.isFunction(weapon.onFireCallback )) {
			weapon.onFireCallback();
		}

		if (weapon.onFireSound != null) {
			weapon.onFireSound.play();
		}
	}

	@:flash.property public var xGravity(never,set):Int;
function  set_xGravity(gx:Int):Int{
		acceleration.x = gx;
return gx;
	}

	@:flash.property public var yGravity(never,set):Int;
function  set_yGravity(gy:Int):Int{
		acceleration.y = gy;
return gy;
	}

	@:flash.property public var maxVelocityX(never,set):Int;
function  set_maxVelocityX(mx:Int):Int{
		maxVelocity.x = mx;
return mx;
	}

	@:flash.property public var maxVelocityY(never,set):Int;
function  set_maxVelocityY(my:Int):Int{
		maxVelocity.y = my;
return my;
	}

	override public function update() {
		if (lifespan > 0 && (Utils.getTimerStamp() : UInt) > expiresTime) {
			kill();
		}

		if (FlxMath.pointInFlxRect(Std.int(x), Std.int(y), weapon.bounds) == false) {
			kill();
		}
	}

}


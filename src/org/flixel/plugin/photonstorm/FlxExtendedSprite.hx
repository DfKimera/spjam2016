/**
 * FlxExtendedSprite
 * -- Part of the Flixel Power Tools set
 *
 * v1.4 Added MouseSpring, plugin checks and all the missing documentation
 * v1.3 Added Gravity, Friction and Tolerance support
 * v1.2 Now works fully with FlxMouseControl to be completely clickable and draggable!
 * v1.1 Added "setMouseDrag" and "mouse over" states
 * v1.0 Updated for the Flixel 2.5 Plugin system
 *
 * @version 1.4 - July 29th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
 */

package org.flixel.plugin.photonstorm ;

import org.flixel.*;
import org.flixel.plugin.photonstorm.baseTypes.MouseSpring;

/**
 * An enhanced FlxSprite that is capable of receiving mouse clicks, being dragged and thrown, mouse springs, gravity and other useful things
 */
 class FlxExtendedSprite extends FlxSprite {

	public var name:String;

	/**
	 * Used by FlxMouseControl when multiple sprites overlap and register clicks, and you need to determine which sprite has priority
	 */
	public var priorityID:UInt = 0;

	/**
	 * If the mouse currently pressed down on this sprite?
	 * @default false
	 */
	public var isPressed:Bool = false;

	/**
	 * Is this sprite allowed to be clicked?
	 * @default false
	 */
	public var clickable:Bool = false;
	var clickOnRelease:Bool = false;
	var clickPixelPerfect:Bool = false;
	var clickPixelPerfectAlpha:UInt = 0;
	var clickCounter:UInt = 0;

	/**
	 * Function called when the mouse is pressed down on this sprite. Function is passed these parameters: obj:FlxExtendedSprite, x:int, y:int
	 * @default null
	 */
	public var mousePressedCallback:ASFunction;

	/**
	 * Function called when the mouse is released from this sprite. Function is passed these parameters: obj:FlxExtendedSprite, x:int, y:int
	 * @default null
	 */
	public var mouseReleasedCallback:ASFunction;

	/**
	 * Is this sprite allowed to be thrown?
	 * @default false
	 */
	public var throwable:Bool = false;
	var throwXFactor:Int = 0;
	var throwYFactor:Int = 0;

	/**
	 * Does this sprite have gravity applied to it?
	 * @default false
	 */
	public var hasGravity:Bool = false;

	/**
	 * The x axis gravity influence
	 */
	public var gravityX:Int = 0;

	/**
	 * The y axis gravity influence
	 */
	public var gravityY:Int = 0;

	/**
	 * Determines how quickly the Sprite come to rest on the walls if the sprite has x gravity enabled
	 * @default 500
	 */
	public var frictionX:Float = Math.NaN;

	/**
	 * Determines how quickly the Sprite come to rest on the ground if the sprite has y gravity enabled
	 * @default 500
	 */
	public var frictionY:Float = Math.NaN;

	/**
	 * If the velocity.x of this sprite falls between zero and this amount, then the sprite will come to a halt (have velocity.x set to zero)
	 */
	public var toleranceX:Float = Math.NaN;

	/**
	 * If the velocity.y of this sprite falls between zero and this amount, then the sprite will come to a halt (have velocity.y set to zero)
	 */
	public var toleranceY:Float = Math.NaN;

	/**
	 * Is this sprite being dragged by the mouse or not?
	 * @default false
	 */
	public var isDragged:Bool = false;

	/**
	 * Is this sprite allowed to be dragged by the mouse? true = yes, false = no
	 * @default false
	 */
	public var draggable:Bool = false;
	var dragPixelPerfect:Bool = false;
	var dragPixelPerfectAlpha:UInt = 0;
	var dragOffsetX:Int = 0;
	var dragOffsetY:Int = 0;
	var dragFromPoint:Bool = false;
	var allowHorizontalDrag:Bool = true;
	var allowVerticalDrag:Bool = true;

	/**
	 * Function called when the mouse starts to drag this sprite. Function is passed these parameters: obj:FlxExtendedSprite, x:int, y:int
	 * @default null
	 */
	public var mouseStartDragCallback:ASFunction;

	/**
	 * Function called when the mouse stops dragging this sprite. Function is passed these parameters: obj:FlxExtendedSprite, x:int, y:int
	 * @default null
	 */
	public var mouseStopDragCallback:ASFunction;

	/**
	 * An FlxRect region of the game world within which the sprite is restricted during mouse drag
	 * @default null
	 */
	public var boundsRect:FlxRect = null;

	/**
	 * An FlxSprite the bounds of which this sprite is restricted during mouse drag
	 * @default null
	 */
	public var boundsSprite:FlxSprite = null;

	var snapOnDrag:Bool = false;
	var snapOnRelease:Bool = false;
	var snapX:Int = 0;
	var snapY:Int = 0;

	/**
	 * Is this sprite using a mouse spring?
	 * @default false
	 */
	public var hasMouseSpring:Bool = false;

	/**
	 * Will the Mouse Spring be active always (false) or only when pressed (true)
	 * @default true
	 */
	public var springOnPressed:Bool = true;

	/**
	 * The MouseSpring object which is used to tie this sprite to the mouse
	 */
	public var mouseSpring:MouseSpring;

	/**
	 * By default the spring attaches to the top left of the sprite. To change this location provide an x offset (in pixels)
	 */
	public var springOffsetX:Int = 0;

	/**
	 * By default the spring attaches to the top left of the sprite. To change this location provide a y offset (in pixels)
	 */
	public var springOffsetY:Int = 0;

	/**
	 * Called when the sprite is updated
	 */
	public var onUpdate:ASFunction;

	/**
	 * Creates a white 8x8 square <code>FlxExtendedSprite</code> at the specified position.
	 * Optionally can load a simple, one-frame graphic instead.
	 *
	 * @param	X				The initial X position of the sprite.
	 * @param	Y				The initial Y position of the sprite.
	 * @param	SimpleGraphic	The graphic you want to display (OPTIONAL - for simple stuff only, do NOT use for animated images!).
	 */
	public function new(X:Float = 0, Y:Float = 0, SimpleGraphic:Class<Dynamic> = null) {
		super(X, Y, SimpleGraphic);
	}

	/**
	 * Allow this Sprite to receive mouse clicks, the total number of times this sprite is clicked is stored in this.clicks<br>
	 * You can add callbacks via mousePressedCallback and mouseReleasedCallback
	 *
	 * @param	onRelease			Register the click when the mouse is pressed down (false) or when it's released (true). Note that callbacks still fire regardless of this setting.
	 * @param	pixelPerfect		If true it will use a pixel perfect test to see if you clicked the Sprite. False uses the bounding box.
	 * @param	alphaThreshold		If using pixel perfect collision this specifies the alpha level from 0 to 255 above which a collision is processed (default 255)
	 */
	public function enableMouseClicks(onRelease:Bool, pixelPerfect:Bool = false, alphaThreshold:UInt = 255) {
		if (FlxG.getPlugin(FlxMouseControl) == null) {
			throw cast("FlxExtendedSprite.enableMouseClicks called but FlxMouseControl plugin not activated", Error);
		}

		clickable = true;

		clickOnRelease = onRelease;
		clickPixelPerfect = pixelPerfect;
		clickPixelPerfectAlpha = alphaThreshold;
		clickCounter = 0;
	}

	/**
	 * Stops this sprite from checking for mouse clicks and clears any set callbacks
	 */
	public function disableMouseClicks() {
		clickable = false;
		mousePressedCallback = null;
		mouseReleasedCallback = null;
	}

	/**
	 * Returns the number of times this sprite has been clicked (can be reset by setting clicks to zero)
	 */
	
	/**
	 * Sets the number of clicks this item has received. Usually you'd only set it to zero.
	 */
	@:flash.property public var clicks(get,set):UInt;
function  get_clicks():UInt {
		return clickCounter;
	}
function  set_clicks(i:UInt):UInt{
		return clickCounter = i;
	}

	/**
	 * Make this Sprite draggable by the mouse. You can also optionally set mouseStartDragCallback and mouseStopDragCallback
	 *
	 * @param	lockCenter			If false the Sprite will drag from where you click it. If true it will center itself to the tip of the mouse pointer.
	 * @param	pixelPerfect		If true it will use a pixel perfect test to see if you clicked the Sprite. False uses the bounding box.
	 * @param	alphaThreshold		If using pixel perfect collision this specifies the alpha level from 0 to 255 above which a collision is processed (default 255)
	 * @param	boundsRect			If you want to restrict the drag of this sprite to a specific FlxRect, pass the FlxRect here, otherwise it's free to drag anywhere
	 * @param	boundsSprite		If you want to restrict the drag of this sprite to within the bounding box of another sprite, pass it here
	 */
	public function enableMouseDrag(lockCenter:Bool = false, pixelPerfect:Bool = false, alphaThreshold:UInt = 255, boundsRect:FlxRect = null, boundsSprite:FlxSprite = null) {
		if (FlxG.getPlugin(FlxMouseControl) == null) {
			throw cast("FlxExtendedSprite.enableMouseDrag called but FlxMouseControl plugin not activated", Error);
		}

		draggable = true;

		dragFromPoint = lockCenter;
		dragPixelPerfect = pixelPerfect;
		dragPixelPerfectAlpha = alphaThreshold;

		if (boundsRect != null) {
			this.boundsRect = boundsRect;
		}

		if (boundsSprite != null) {
			this.boundsSprite = boundsSprite;
		}
	}

	/**
	 * Stops this sprite from being able to be dragged. If it is currently the target of an active drag it will be stopped immediately. Also disables any set callbacks.
	 */
	public function disableMouseDrag() {
		if (isDragged) {
			FlxMouseControl.dragTarget = null;
			FlxMouseControl.isDragging = false;
		}

		isDragged = false;
		draggable = false;

		mouseStartDragCallback = null;
		mouseStopDragCallback = null;
	}

	/**
	 * Restricts this sprite to drag movement only on the given axis. Note: If both are set to false the sprite will never move!
	 *
	 * @param	allowHorizontal		To enable the sprite to be dragged horizontally set to true, otherwise false
	 * @param	allowVertical		To enable the sprite to be dragged vertically set to true, otherwise false
	 */
	public function setDragLock(allowHorizontal:Bool = true, allowVertical:Bool = true) {
		allowHorizontalDrag = allowHorizontal;
		allowVerticalDrag = allowVertical;
	}

	/**
	 * Make this Sprite throwable by the mouse. The sprite is thrown only when the mouse button is released.
	 *
	 * @param	xFactor		The sprites velocity is set to FlxMouseControl.speedX * xFactor. Try a value around 50+
	 * @param	yFactor		The sprites velocity is set to FlxMouseControl.speedY * yFactor. Try a value around 50+
	 */
	public function enableMouseThrow(xFactor:Int, yFactor:Int) {
		if (FlxG.getPlugin(FlxMouseControl) == null) {
			throw cast("FlxExtendedSprite.enableMouseThrow called but FlxMouseControl plugin not activated", Error);
		}

		throwable = true;
		throwXFactor = xFactor;
		throwYFactor = yFactor;

		if (clickable == false && draggable == false) {
			clickable = true;
		}
	}

	/**
	 * Stops this sprite from being able to be thrown. If it currently has velocity this is NOT removed from it.
	 */
	public function disableMouseThrow() {
		throwable = false;
	}

	/**
	 * Make this Sprite snap to the given grid either during drag or when it's released.
	 * For example 16x16 as the snapX and snapY would make the sprite snap to every 16 pixels.
	 *
	 * @param	snapX		The width of the grid cell in pixels
	 * @param	snapY		The height of the grid cell in pixels
	 * @param	onDrag		If true the sprite will snap to the grid while being dragged
	 * @param	onRelease	If true the sprite will snap to the grid when released
	 */
	public function enableMouseSnap(snapX:Int, snapY:Int, onDrag:Bool = true, onRelease:Bool = false) {
		snapOnDrag = onDrag;
		snapOnRelease = onRelease;
		this.snapX = snapX;
		this.snapY = snapY;
	}

	/**
	 * Stops the sprite from snapping to a grid during drag or release.
	 */
	public function disableMouseSnap() {
		snapOnDrag = false;
		snapOnRelease = false;
	}

	/**
	 * Adds a simple spring between the mouse and this Sprite. The spring can be activated either when the mouse is pressed (default), or enabled all the time.
	 * Note that nearly always the Spring will over-ride any other motion setting the sprite has (like velocity or gravity)
	 *
	 * @param	onPressed			true if the spring should only be active when the mouse is pressed down on this sprite
	 * @param	retainVelocity		true to retain the velocity of the spring when the mouse is released, or false to clear it
	 * @param	tension				The tension of the spring, smaller numbers create springs closer to the mouse pointer
	 * @param	friction			The friction applied to the spring as it moves
	 * @param	gravity				The gravity controls how far "down" the spring hangs (use a negative value for it to hang up!)
	 *
	 * @return	The MouseSpring object if you wish to perform further chaining on it. Also available via FlxExtendedSprite.mouseSpring
	 */
	public function enableMouseSpring(onPressed:Bool = true, retainVelocity:Bool = false, tension:Float = 0.1, friction:Float = 0.95, gravity:Float = 0):MouseSpring {
		if (FlxG.getPlugin(FlxMouseControl) == null) {
			throw cast("FlxExtendedSprite.enableMouseSpring called but FlxMouseControl plugin not activated", Error);
		}

		hasMouseSpring = true;
		springOnPressed = onPressed;

		if (mouseSpring == null) {
			mouseSpring = new MouseSpring(this, retainVelocity, tension, friction, gravity);
		} else {
			mouseSpring.tension = tension;
			mouseSpring.friction = friction;
			mouseSpring.gravity = gravity;
		}

		if (clickable == false && draggable == false) {
			clickable = true;
		}

		return mouseSpring;
	}

	/**
	 * Stops the sprite to mouse spring from being active
	 */
	public function disableMouseSpring() {
		hasMouseSpring = false;

		mouseSpring = null;
	}

	/**
	 * The spring x coordinate in game world space. Consists of sprite.x + springOffsetX
	 */
	@:flash.property public var springX(get,never):Int;
function  get_springX():Int {
		return Std.int(x + springOffsetX);
	}

	/**
	 * The spring y coordinate in game world space. Consists of sprite.y + springOffsetY
	 */
	@:flash.property public var springY(get,never):Int;
function  get_springY():Int {
		return Std.int(y + springOffsetY);
	}

	/**
	 * Core update loop
	 */
	override public function update() {
		if (draggable && isDragged) {
			updateDrag();
		}

		if (isPressed == false && FlxG.mouse.justPressed()) {
			checkForClick();
		}

		if (hasGravity) {
			updateGravity();
		}

		if (hasMouseSpring) {
			if (springOnPressed == false) {
				mouseSpring.update();
			} else {
				if (isPressed == true) {
					mouseSpring.update();
				} else {
					mouseSpring.reset();
				}
			}
		}

		if (Reflect.isFunction(this.onUpdate )) {
			this.onUpdate();
		}

		super.update();
	}

	/**
	 * Called by update, applies friction if the sprite has gravity to stop jittery motion when slowing down
	 */
	function updateGravity() {
		//	A sprite can have horizontal and/or vertical gravity in each direction (positiive / negative)

		//	First let's check the x movement

		if (velocity.x != 0) {
			if (acceleration.x < 0) {
				//	Gravity is pulling them left
				if ((touching & FlxObject.WALL) != 0) {
					drag.y = frictionY;

					if ((wasTouching & FlxObject.WALL) == false) {
						if (velocity.x < toleranceX) {
							//trace("(left) velocity.x", velocity.x, "stopped via tolerance break", toleranceX);
							velocity.x = 0;
						}
					}
				} else {
					drag.y = 0;
				}
			} else if (acceleration.x > 0) {
				//	Gravity is pulling them right
				if ((touching & FlxObject.WALL) != 0) {
					//	Stop them sliding like on ice
					drag.y = frictionY;

					if ((wasTouching & FlxObject.WALL) == false) {
						if (velocity.x > -toleranceX) {
							//trace("(right) velocity.x", velocity.x, "stopped via tolerance break", toleranceX);
							velocity.x = 0;
						}
					}
				} else {
					drag.y = 0;
				}
			}
		}

		//	Now check the y movement

		if (velocity.y != 0) {
			if (acceleration.y < 0) {
				//	Gravity is pulling them up (velocity is negative)
				if ((touching & FlxObject.CEILING) != 0) {
					drag.x = frictionX;

					if ((wasTouching & FlxObject.CEILING) == false) {
						if (velocity.y < toleranceY) {
							//trace("(down) velocity.y", velocity.y, "stopped via tolerance break", toleranceY);
							velocity.y = 0;
						}
					}
				} else {
					drag.x = 0;
				}
			} else if (acceleration.y > 0) {
				//	Gravity is pulling them down (velocity is positive)
				if ((touching & FlxObject.FLOOR) != 0) {
					//	Stop them sliding like on ice
					drag.x = frictionX;

					if ((wasTouching & FlxObject.FLOOR) == false) {
						if (velocity.y > -toleranceY) {
							//trace("(down) velocity.y", velocity.y, "stopped via tolerance break", toleranceY);
							velocity.y = 0;
						}
					}
				} else {
					drag.x = 0;
				}
			}
		}
	}

	/**
	 * Updates the Mouse Drag on this Sprite.
	 */
	function updateDrag() {
		//FlxG.mouse.getWorldPosition(null, tempPoint);

		if (allowHorizontalDrag) {
			x = Std.int(FlxG.mouse.x) - dragOffsetX;
		}

		if (allowVerticalDrag) {
			y = Std.int(FlxG.mouse.y) - dragOffsetY;
		}

		if (boundsRect != null) {
			checkBoundsRect();
		}

		if (boundsSprite != null) {
			checkBoundsSprite();
		}

		if (snapOnDrag) {
			x = Std.int(Math.ffloor(x / snapX) * snapX);
			y = Std.int(Math.ffloor(y / snapY) * snapY);
		}
	}

	/**
	 * Checks if the mouse is over this sprite and pressed, then does a pixel perfect check if needed and adds it to the FlxMouseControl check stack
	 */
	function checkForClick() {
		if (mouseOver && FlxG.mouse.justPressed()) {
			//	If we don't need a pixel perfect check, then don't bother running one! By this point we know the mouse is over the sprite already
			if (clickPixelPerfect == false && dragPixelPerfect == false) {
				FlxMouseControl.addToStack(this);
				return;
			}

			if (clickPixelPerfect && FlxCollision.pixelPerfectPointCheck(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), this, clickPixelPerfectAlpha)) {
				FlxMouseControl.addToStack(this);
				return;
			}

			if (dragPixelPerfect && FlxCollision.pixelPerfectPointCheck(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), this, dragPixelPerfectAlpha)) {
				FlxMouseControl.addToStack(this);
				return;
			}
		}
	}

	/**
	 * Called by FlxMouseControl when this sprite is clicked. Should not usually be called directly.
	 */
	public function mousePressedHandler() {
		isPressed = true;

		if (clickable && clickOnRelease == false) {
			clickCounter++;
		}

		if (Reflect.isFunction(mousePressedCallback )) {
			Reflect.callMethod(null, mousePressedCallback, [this, mouseX, mouseY]);
		}
	}

	/**
	 * Called by FlxMouseControl when this sprite is released from a click. Should not usually be called directly.
	 */
	public function mouseReleasedHandler() {
		isPressed = false;

		if (isDragged) {
			stopDrag();
		}

		if (clickable && clickOnRelease == true) {
			clickCounter++;
		}

		if (throwable) {
			velocity.x = FlxMouseControl.speedX * throwXFactor;
			velocity.y = FlxMouseControl.speedY * throwYFactor;
		}

		if (Reflect.isFunction(mouseReleasedCallback )) {
			Reflect.callMethod(null, mouseReleasedCallback, [this, mouseX, mouseY]);
		}
	}

	/**
	 * Called by FlxMouseControl when Mouse Drag starts on this Sprite. Should not usually be called directly.
	 */
	public function startDrag() {
		isDragged = true;

		if (dragFromPoint == false) {
			dragOffsetX = Std.int(Std.int(FlxG.mouse.x) - x);
			dragOffsetY = Std.int(Std.int(FlxG.mouse.y) - y);
		} else {
			//	Move the sprite to the middle of the mouse
			dragOffsetX = Std.int(frameWidth / 2);
			dragOffsetY = Std.int(frameHeight / 2);
		}
	}

	/**
	 * Bounds Rect check for the sprite drag
	 */
	function checkBoundsRect() {
		if (x < boundsRect.left) {
			x = boundsRect.x;
		} else if ((x + width) > boundsRect.right) {
			x = boundsRect.right - width;
		}

		if (y < boundsRect.top) {
			y = boundsRect.top;
		} else if ((y + height) > boundsRect.bottom) {
			y = boundsRect.bottom - height;
		}
	}

	/**
	 * Parent Sprite Bounds check for the sprite drag
	 */
	function checkBoundsSprite() {
		if (x < boundsSprite.x) {
			x = boundsSprite.x;
		} else if ((x + width) > (boundsSprite.x + boundsSprite.width)) {
			x = (boundsSprite.x + boundsSprite.width) - width;
		}

		if (y < boundsSprite.y) {
			y = boundsSprite.y;
		} else if ((y + height) > (boundsSprite.y + boundsSprite.height)) {
			y = (boundsSprite.y + boundsSprite.height) - height;
		}
	}

	/**
	 * Called by FlxMouseControl when Mouse Drag is stopped on this Sprite. Should not usually be called directly.
	 */
	public function stopDrag() {
		isDragged = false;

		if (snapOnRelease) {
			x = Std.int(Math.ffloor(x / snapX) * snapX);
			y = Std.int(Math.ffloor(y / snapY) * snapY);
		}
	}

	/**
	 * Gravity can be applied to the sprite, pulling it in any direction. Gravity is given in pixels per second and is applied as acceleration.
	 * If you don't want gravity for a specific direction pass a value of zero. To cancel it entirely pass both values as zero.
	 *
	 * @param	gravityX	A positive value applies gravity dragging the sprite to the right. A negative value drags the sprite to the left. Zero disables horizontal gravity.
	 * @param	gravityY	A positive value applies gravity dragging the sprite down. A negative value drags the sprite up. Zero disables vertical gravity.
	 * @param	frictionX	The amount of friction applied to the sprite if it hits a wall. Allows it to come to a stop without constantly jittering.
	 * @param	frictionY	The amount of friction applied to the sprite if it hits the floor/roof. Allows it to come to a stop without constantly jittering.
	 * @param	toleranceX	If the velocity.x of the sprite falls between 0 and +- this value, it is set to stop (velocity.x = 0)
	 * @param	toleranceY	If the velocity.y of the sprite falls between 0 and +- this value, it is set to stop (velocity.y = 0)
	 */
	public function setGravity(gravityX:Int, gravityY:Int, frictionX:Float = 500, frictionY:Float = 500, toleranceX:Float = 10, toleranceY:Float = 10) {
		hasGravity = true;

		this.gravityX = gravityX;
		this.gravityY = gravityY;

		this.frictionX = frictionX;
		this.frictionY = frictionY;

		this.toleranceX = toleranceX;
		this.toleranceY = toleranceY;

		if (gravityX == 0 && gravityY == 0) {
			hasGravity = false;
		}

		acceleration.x = gravityX;
		acceleration.y = gravityY;
	}

	/**
	 * Switches the gravity applied to the sprite. If gravity was +400 Y (pulling them down) this will swap it to -400 Y (pulling them up)<br>
	 * To reset call flipGravity again
	 */
	public function flipGravity() {
		if (gravityX != 0 && gravityX != 0) {
			gravityX = -gravityX;
			acceleration.x = gravityX;
		}

		if (gravityY != 0 && gravityY != 0) {
			gravityY = -gravityY;
			acceleration.y = gravityY;
		}
	}

	/**
	 * Returns an FlxPoint consisting of this sprites world x/y coordinates
	 */
	
	@:flash.property public var point(get,set):FlxPoint;
function  get_point():FlxPoint {
		return _point;
	}
function  set_point(p:FlxPoint):FlxPoint{
		return _point = p;
	}

	/**
	 * Return true if the mouse is over this Sprite, otherwise false. Only takes the Sprites bounding box into consideration and does not check if there
	 * are other sprites potentially on-top of this one. Check the value of this.isPressed if you need to know if the mouse is currently clicked on this sprite.
	 */
	@:flash.property public var mouseOver(get,never):Bool;
function  get_mouseOver():Bool {
		return FlxMath.pointInCoordinates(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), Std.int(x), Std.int(y), Std.int(width), Std.int(height));
	}

	/**
	 * Returns how many horizontal pixels the mouse pointer is inside this sprite from the top left corner. Returns -1 if outside.
	 */
	@:flash.property public var mouseX(get,never):Int;
function  get_mouseX():Int {
		if (mouseOver) {
			return Std.int(FlxG.mouse.x - x);
		}

		return -1;
	}

	/**
	 * Returns how many vertical pixels the mouse pointer is inside this sprite from the top left corner. Returns -1 if outside.
	 */
	@:flash.property public var mouseY(get,never):Int;
function  get_mouseY():Int {
		if (mouseOver) {
			return Std.int(FlxG.mouse.y - y);
		}

		return -1;
	}

	/**
	 * Returns an FlxRect consisting of the bounds of this Sprite.
	 */
	@:flash.property public var rect(get,never):FlxRect;
function  get_rect():FlxRect {
		_rect.x = x;
		_rect.y = y;
		_rect.width = width;
		_rect.height = height;

		return _rect;
	}

}


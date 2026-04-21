package org.flixel.system.replay ;

/**
 * A helper class for the frame records, part of the replay/demo/recording system.
 *
 * @author Adam Atomic
 */
 class MouseRecord {
	/**
	 * The main X value of the mouse in screen space.
	 */
	public var x:Int = 0;
	/**
	 * The main Y value of the mouse in screen space.
	 */
	public var y:Int = 0;
	/**
	 * The state of the left mouse button.
	 */
	public var button:Int = 0;
	/**
	 * The state of the mouse wheel.
	 */
	public var wheel:Int = 0;

	/**
	 * Instantiate a new mouse input record.
	 *
	 * @param X			The main X value of the mouse in screen space.
	 * @param Y			The main Y value of the mouse in screen space.
	 * @param Button	The state of the left mouse button.
	 * @param Wheel		The state of the mouse wheel.
	 */
	public function new(X:Int, Y:Int, Button:Int, Wheel:Int) {
		x = X;
		y = Y;
		button = Button;
		wheel = Wheel;
	}
}

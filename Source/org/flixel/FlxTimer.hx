package org.flixel ;

import org.flixel.plugin.TimerManager;

/**
 * A simple timer class, leveraging the new plugins system.
 * Can be used with callbacks or by polling the <code>finished</code> flag.
 * Not intended to be added to a game state or group; the timer manager
 * is responsible for actually calling update(), not the user.
 *
 * @author Adam Atomic
 */
 class FlxTimer {
	/**
	 * How much time the timer was set for.
	 */
	public var time:Float = Math.NaN;
	/**
	 * How many loops the timer was set for.
	 */
	public var loops:UInt = 0;
	/**
	 * Pauses or checks the pause state of the timer.
	 */
	public var paused:Bool = false;
	/**
	 * Check to see if the timer is finished.
	 */
	public var finished:Bool = false;

	/**
	 * Internal tracker for the time's-up callback function.
	 * Callback should be formed "onTimer(Timer:FlxTimer);"
	 */
	var _callback:ASFunction;
	/**
	 * Internal tracker for the actual timer counting up.
	 */
	var _timeCounter:Float = Math.NaN;
	/**
	 * Internal tracker for the loops counting up.
	 */
	var _loopsCounter:UInt = 0;

	/**
	 * Instantiate the timer.  Does not set or start the timer.
	 */
	public function new() {
		time = 0;
		loops = 0;
		_callback = null;
		_timeCounter = 0;
		_loopsCounter = 0;

		paused = false;
		finished = false;
	}

	/**
	 * Clean up memory.
	 */
	public function destroy() {
		stop();
		_callback = null;
	}

	/**
	 * Called by the timer manager plugin to update the timer.
	 * If time runs out, the loop counter is advanced, the timer reset, and the callback called if it exists.
	 * If the timer runs out of loops, then the timer calls <code>stop()</code>.
	 * However, callbacks are called AFTER <code>stop()</code> is called.
	 */
	public function update() {
		_timeCounter += FlxG.elapsed;
		while ((_timeCounter >= time) && !paused && !finished) {
			_timeCounter -= time;

			_loopsCounter++;
			if ((loops > 0) && (_loopsCounter >= loops)) {
				stop();
			}

			if (_callback != null) {
				_callback(this);
			}
		}
	}

	/**
	 * Starts or resumes the timer.  If this timer was paused,
	 * then all the parameters are ignored, and the timer is resumed.
	 * Adds the timer to the timer manager.
	 *
	 * @param	Time		How many seconds it takes for the timer to go off.
	 * @param	Loops		How many times the timer should go off.  Default is 1, or "just count down once."
	 * @param	Callback	Optional, triggered whenever the time runs out, once for each loop.  Callback should be formed "onTimer(Timer:FlxTimer);"
	 *
	 * @return	A reference to itself (handy for chaining or whatever).
	 */
	public function start(Time:Float = 1, Loops:UInt = 1, Callback:ASFunction = null):FlxTimer {
		var timerManager= manager;
		if (timerManager != null) {
			timerManager.add(this);
		}

		if (paused) {
			paused = false;
			return this;
		}

		paused = false;
		finished = false;
		time = Time;
		loops = Loops;
		_callback = Callback;
		_timeCounter = 0;
		_loopsCounter = 0;
		return this;
	}

	/**
	 * Stops the timer and removes it from the timer manager.
	 */
	public function stop() {
		finished = true;
		var timerManager= manager;
		if (timerManager != null) {
			timerManager.remove(this);
		}
	}

	/**
	 * Read-only: check how much time is left on the timer.
	 */
	@:flash.property public var timeLeft(get,never):Float;
function  get_timeLeft():Float {
		return time - _timeCounter;
	}

	/**
	 * Read-only: check how many loops are left on the timer.
	 */
	@:flash.property public var loopsLeft(get,never):Int;
function  get_loopsLeft():Int {
		return loops - _loopsCounter;
	}

	/**
	 * Read-only: how far along the timer is, on a scale of 0.0 to 1.0.
	 */
	@:flash.property public var progress(get,never):Float;
function  get_progress():Float {
		if (time > 0) {
			return _timeCounter / time;
		} else {
			return 0;
		}
	}

	@:flash.property public static var manager(get,never):TimerManager;
static function  get_manager():TimerManager {
		return Std.downcast(FlxG.getPlugin(TimerManager) , TimerManager);
	}
}

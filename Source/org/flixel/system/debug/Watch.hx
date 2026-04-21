package org.flixel.system.debug ;

import flash.display.Sprite;
import flash.geom.Rectangle;
import org.flixel.system.FlxWindow;

/**
 * A Visual Studio-style "watch" window, for use in the debugger overlay.
 * Track the values of any public variable in real-time, and/or edit their values on the fly.
 *
 * @author Adam Atomic
 */
 class Watch extends FlxWindow {
	static inline final MAX_LOG_LINES:UInt = 1024;
	static inline final LINE_HEIGHT:UInt = 15;

	/**
	 * Whether a watch entry is currently being edited or not.
	 */
	public var editing:Bool = false;

	var _names:Sprite;
	var _values:Sprite;
	var _watching:Array<ASAny>;

	/**
	 * Creates a new window object.  This Flash-based class is mainly (only?) used by <code>FlxDebugger</code>.
	 *
	 * @param Title			The name of the window, displayed in the header bar.
	 * @param Width			The initial width of the window.
	 * @param Height		The initial height of the window.
	 * @param Resizable		Whether you can change the size of the window with a drag handle.
	 * @param Bounds		A rectangle indicating the valid screen area for the window.
	 * @param BGColor		What color the window background should be, default is gray and transparent.
	 * @param TopColor		What color the window header bar should be, default is black and transparent.
	 */
	public function new(Title:String, Width:Float, Height:Float, Resizable:Bool = true, Bounds:Rectangle = null, BGColor:UInt = 0x7f7f7f7f, TopColor:UInt = 0x7f000000) {
		super(Title, Width, Height, Resizable, Bounds, BGColor, TopColor);

		_names = new Sprite();
		_names.x = 2;
		_names.y = 15;
		addChild(_names);

		_values = new Sprite();
		_values.x = 2;
		_values.y = 15;
		addChild(_values);

		_watching = [];

		editing = false;

		removeAll();
	}

	/**
	 * Clean up memory.
	 */
	override public function destroy() {
		removeChild(_names);
		_names = null;
		removeChild(_values);
		_values = null;
		var i= 0;
		var l:UInt = _watching.length;
		while ((i : UInt) < l) {
			ASCompat.dynamicAs(_watching[i++] , WatchEntry).destroy();
		}
		_watching = null;
		super.destroy();
	}

	/**
	 * Add a new variable to the watch window.
	 * Has some simple code in place to prevent
	 * accidentally watching the same variable twice.
	 *
	 * @param AnyObject		The <code>Object</code> containing the variable you want to track, e.g. this or Player.velocity.
	 * @param VariableName	The <code>String</code> name of the variable you want to track, e.g. "width" or "x".
	 * @param DisplayName	Optional <code>String</code> that can be displayed in the watch window instead of the basic class-name information.
	 */
	public function add(AnyObject:ASAny, VariableName:String, DisplayName:String = null) {
		//Don't add repeats
		var watchEntry:WatchEntry;
		var i= 0;
		var l:UInt = _watching.length;
		while ((i : UInt) < l) {
			watchEntry = ASCompat.dynamicAs(_watching[i++] , WatchEntry);
			if ((watchEntry.object == AnyObject) && (watchEntry.field == VariableName)) {
				return;
			}
		}

		//Good, no repeats, add away!
		watchEntry = new WatchEntry(_watching.length * LINE_HEIGHT, _width / 2, _width / 2 - 10, AnyObject, VariableName, DisplayName);
		_names.addChild(watchEntry.nameDisplay);
		_values.addChild(watchEntry.valueDisplay);
		_watching.push(watchEntry);
	}

	/**
	 * Remove a variable from the watch window.
	 *
	 * @param AnyObject		The <code>Object</code> containing the variable you want to remove, e.g. this or Player.velocity.
	 * @param VariableName	The <code>String</code> name of the variable you want to remove, e.g. "width" or "x".  If left null, this will remove all variables of that object.
	 */
	public function remove(AnyObject:ASAny, VariableName:String = null) {
		//splice out the requested object
		var watchEntry:WatchEntry;
		var i= _watching.length - 1;
		while (i >= 0) {
			watchEntry = _watching[i];
			if ((watchEntry.object == AnyObject) && ((VariableName == null) || (watchEntry.field == VariableName))) {
				_watching.splice(i, 1);
				_names.removeChild(watchEntry.nameDisplay);
				_values.removeChild(watchEntry.valueDisplay);
				watchEntry.destroy();
			}
			i--;
		}
		watchEntry = null;

		//reset the display heights of the remaining objects
		i = 0;
		var l:UInt = _watching.length;
		while ((i : UInt) < l) {
			ASCompat.dynamicAs(_watching[i] , WatchEntry).setY(i * LINE_HEIGHT);
			i++;
		}
	}

	/**
	 * Remove everything from the watch window.
	 */
	public function removeAll() {
		var watchEntry:WatchEntry;
		var i= 0;
		var l:UInt = _watching.length;
		while ((i : UInt) < l) {
			watchEntry = _watching.pop();
			_names.removeChild(watchEntry.nameDisplay);
			_values.removeChild(watchEntry.valueDisplay);
			watchEntry.destroy();
			i++
;		}
		_watching.resize(0);
	}

	/**
	 * Update all the entries in the watch window.
	 */
	public function update() {
		editing = false;
		var i:UInt = 0;
		var l:UInt = _watching.length;
		while (i < l) {
			if (!ASCompat.dynamicAs(_watching[i++] , WatchEntry).updateValue()) {
				editing = true;
			}
		}
	}

	/**
	 * Force any watch entries currently being edited to submit their changes.
	 */
	public function submit() {
		var i:UInt = 0;
		var l:UInt = _watching.length;
		var watchEntry:WatchEntry;
		while (i < l) {
			watchEntry = ASCompat.dynamicAs(_watching[i++] , WatchEntry);
			if (watchEntry.editing) {
				watchEntry.submit();
			}
		}
		editing = false;
	}

	/**
	 * Update the Flash shapes to match the new size, and reposition the header, shadow, and handle accordingly.
	 * Also adjusts the width of the entries and stuff, and makes sure there is room for all the entries.
	 */
	override function updateSize() {
		if (_height < _watching.length * LINE_HEIGHT + 17) {
			_height = _watching.length * LINE_HEIGHT + 17;
		}

		super.updateSize();

		_values.x = _width / 2 + 2;

		var i= 0;
		var l:UInt = _watching.length;
		while ((i : UInt) < l) {
			ASCompat.dynamicAs(_watching[i++] , WatchEntry).updateWidth(_width / 2, _width / 2 - 10);
		}
	}
}


package org.flixel.system.input ;

import flash.events.KeyboardEvent;

/**
 * Keeps track of what keys are pressed and how with handy booleans or strings.
 *
 * @author Adam Atomic
 */
 class Keyboard extends Input {
	public var ESCAPE:Bool = false;
	public var F1:Bool = false;
	public var F2:Bool = false;
	public var F3:Bool = false;
	public var F4:Bool = false;
	public var F5:Bool = false;
	public var F6:Bool = false;
	public var F7:Bool = false;
	public var F8:Bool = false;
	public var F9:Bool = false;
	public var F10:Bool = false;
	public var F11:Bool = false;
	public var F12:Bool = false;
	public var ONE:Bool = false;
	public var TWO:Bool = false;
	public var THREE:Bool = false;
	public var FOUR:Bool = false;
	public var FIVE:Bool = false;
	public var SIX:Bool = false;
	public var SEVEN:Bool = false;
	public var EIGHT:Bool = false;
	public var NINE:Bool = false;
	public var ZERO:Bool = false;
	public var NUMPADONE:Bool = false;
	public var NUMPADTWO:Bool = false;
	public var NUMPADTHREE:Bool = false;
	public var NUMPADFOUR:Bool = false;
	public var NUMPADFIVE:Bool = false;
	public var NUMPADSIX:Bool = false;
	public var NUMPADSEVEN:Bool = false;
	public var NUMPADEIGHT:Bool = false;
	public var NUMPADNINE:Bool = false;
	public var NUMPADZERO:Bool = false;
	public var PAGEUP:Bool = false;
	public var PAGEDOWN:Bool = false;
	public var HOME:Bool = false;
	public var END:Bool = false;
	public var INSERT:Bool = false;
	public var MINUS:Bool = false;
	public var NUMPADMINUS:Bool = false;
	public var PLUS:Bool = false;
	public var NUMPADPLUS:Bool = false;
	public var DELETE:Bool = false;
	public var BACKSPACE:Bool = false;
	public var TAB:Bool = false;
	public var Q:Bool = false;
	public var W:Bool = false;
	public var E:Bool = false;
	public var R:Bool = false;
	public var T:Bool = false;
	public var Y:Bool = false;
	public var U:Bool = false;
	public var I:Bool = false;
	public var O:Bool = false;
	public var P:Bool = false;
	public var LBRACKET:Bool = false;
	public var RBRACKET:Bool = false;
	public var BACKSLASH:Bool = false;
	public var CAPSLOCK:Bool = false;
	public var A:Bool = false;
	public var S:Bool = false;
	public var D:Bool = false;
	public var F:Bool = false;
	public var G:Bool = false;
	public var H:Bool = false;
	public var J:Bool = false;
	public var K:Bool = false;
	public var L:Bool = false;
	public var SEMICOLON:Bool = false;
	public var QUOTE:Bool = false;
	public var ENTER:Bool = false;
	public var SHIFT:Bool = false;
	public var Z:Bool = false;
	public var X:Bool = false;
	public var C:Bool = false;
	public var V:Bool = false;
	public var B:Bool = false;
	public var N:Bool = false;
	public var M:Bool = false;
	public var COMMA:Bool = false;
	public var PERIOD:Bool = false;
	public var NUMPADPERIOD:Bool = false;
	public var SLASH:Bool = false;
	public var NUMPADSLASH:Bool = false;
	public var CONTROL:Bool = false;
	public var ALT:Bool = false;
	public var SPACE:Bool = false;
	public var UP:Bool = false;
	public var DOWN:Bool = false;
	public var LEFT:Bool = false;
	public var RIGHT:Bool = false;

	public function new() {
		super();
		var i:UInt;

		//LETTERS
		i = 65;
		while (i <= 90) {
			addKey(String.fromCharCode(i), i++);
		}

		//NUMBERS
		i = 48;
		addKey("ZERO", i++);
		addKey("ONE", i++);
		addKey("TWO", i++);
		addKey("THREE", i++);
		addKey("FOUR", i++);
		addKey("FIVE", i++);
		addKey("SIX", i++);
		addKey("SEVEN", i++);
		addKey("EIGHT", i++);
		addKey("NINE", i++);
		i = 96;
		addKey("NUMPADZERO", i++);
		addKey("NUMPADONE", i++);
		addKey("NUMPADTWO", i++);
		addKey("NUMPADTHREE", i++);
		addKey("NUMPADFOUR", i++);
		addKey("NUMPADFIVE", i++);
		addKey("NUMPADSIX", i++);
		addKey("NUMPADSEVEN", i++);
		addKey("NUMPADEIGHT", i++);
		addKey("NUMPADNINE", i++);
		addKey("PAGEUP", 33);
		addKey("PAGEDOWN", 34);
		addKey("HOME", 36);
		addKey("END", 35);
		addKey("INSERT", 45);

		//FUNCTION KEYS
		i = 1;
		while (i <= 12) {
			addKey("F" + i, 111 + (i++));
		}

		//SPECIAL KEYS + PUNCTUATION
		addKey("ESCAPE", 27);
		addKey("MINUS", 189);
		addKey("NUMPADMINUS", 109);
		addKey("PLUS", 187);
		addKey("NUMPADPLUS", 107);
		addKey("DELETE", 46);
		addKey("BACKSPACE", 8);
		addKey("LBRACKET", 219);
		addKey("RBRACKET", 221);
		addKey("BACKSLASH", 220);
		addKey("CAPSLOCK", 20);
		addKey("SEMICOLON", 186);
		addKey("QUOTE", 222);
		addKey("ENTER", 13);
		addKey("SHIFT", 16);
		addKey("COMMA", 188);
		addKey("PERIOD", 190);
		addKey("NUMPADPERIOD", 110);
		addKey("SLASH", 191);
		addKey("NUMPADSLASH", 191);
		addKey("CONTROL", 17);
		addKey("ALT", 18);
		addKey("SPACE", 32);
		addKey("UP", 38);
		addKey("DOWN", 40);
		addKey("LEFT", 37);
		addKey("RIGHT", 39);
		addKey("TAB", 9);
	}

	/**
	 * Event handler so FlxGame can toggle keys.
	 *
	 * @param	FlashEvent	A <code>KeyboardEvent</code> object.
	 */
	public function handleKeyDown(FlashEvent:KeyboardEvent) {
		var object:ASAny = _map[FlashEvent.keyCode];
		if (object == null) {
			return;
		}
		if (object.current > 0) {
			object.current = 1;
		} else {
			object.current = 2;
		}
		(this : ASAny)[object.name] = true;
	}

	/**
	 * Event handler so FlxGame can toggle keys.
	 *
	 * @param	FlashEvent	A <code>KeyboardEvent</code> object.
	 */
	public function handleKeyUp(FlashEvent:KeyboardEvent) {
		var object:ASAny = _map[FlashEvent.keyCode];
		if (object == null) {
			return;
		}
		if (object.current > 0) {
			object.current = -1;
		} else {
			object.current = 0;
		}
		(this : ASAny)[object.name] = false;
	}
}


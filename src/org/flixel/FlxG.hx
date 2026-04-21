package org.flixel ;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.Stage;
import flash.geom.Matrix;
import flash.geom.Rectangle;

import org.flixel.plugin.DebugPathDisplay;
import org.flixel.plugin.TimerManager;
import org.flixel.system.FlxQuadTree;
import org.flixel.system.input.*;

/**
 * This is a global helper class full of useful functions for audio,
 * input, basic info, and the camera system among other things.
 * Utilities for maths and color and things can be found in <code>FlxU</code>.
 * <code>FlxG</code> is specifically for Flixel-specific properties.
 *
 * @author	Adam Atomic
 */
 class FlxG {
	/**
	 * If you build and maintain your own version of flixel,
	 * you can give it your own name here.
	 */
	static public var LIBRARY_NAME:String = "flixel";
	/**
	 * Assign a major version to your library.
	 * Appears before the decimal in the console.
	 */
	static public var LIBRARY_MAJOR_VERSION:UInt = 2;
	/**
	 * Assign a minor version to your library.
	 * Appears after the decimal in the console.
	 */
	static public var LIBRARY_MINOR_VERSION:UInt = 55;

	/**
	 * Debugger overlay layout preset: Wide but low windows at the bottom of the screen.
	 */
	static public inline final DEBUGGER_STANDARD:UInt = 0;
	/**
	 * Debugger overlay layout preset: Tiny windows in the screen corners.
	 */
	static public inline final DEBUGGER_MICRO:UInt = 1;
	/**
	 * Debugger overlay layout preset: Large windows taking up bottom half of screen.
	 */
	static public inline final DEBUGGER_BIG:UInt = 2;
	/**
	 * Debugger overlay layout preset: Wide but low windows at the top of the screen.
	 */
	static public inline final DEBUGGER_TOP:UInt = 3;
	/**
	 * Debugger overlay layout preset: Large windows taking up left third of screen.
	 */
	static public inline final DEBUGGER_LEFT:UInt = 4;
	/**
	 * Debugger overlay layout preset: Large windows taking up right third of screen.
	 */
	static public inline final DEBUGGER_RIGHT:UInt = 5;

	/**
	 * Some handy color presets.  Less glaring than pure RGB full values.
	 * Primarily used in the visual debugger mode for bounding box displays.
	 * Red is used to indicate an active, movable, solid object.
	 */
	static public inline final RED:UInt = 0xffff0012;
	/**
	 * Green is used to indicate solid but immovable objects.
	 */
	static public inline final GREEN:UInt = 0xff00f225;
	/**
	 * Blue is used to indicate non-solid objects.
	 */
	static public inline final BLUE:UInt = 0xff0090e9;
	/**
	 * Pink is used to indicate objects that are only partially solid, like one-way platforms.
	 */
	static public inline final PINK:UInt = 0xfff01eff;
	/**
	 * White... for white stuff.
	 */
	static public inline final WHITE:UInt = 0xffffffff;
	/**
	 * And black too.
	 */
	static public inline final BLACK:UInt = 0xff000000;
@:allow(org.flixel) 
	/**
	 * Internal tracker for game object.
	 */
	static var _game:FlxGame;
	/**
	 * Handy shared variable for implementing your own pause behavior.
	 */
	static public var paused:Bool = false;
	/**
	 * Whether you are running in Debug or Release mode.
	 * Set automatically by <code>FlxPreloader</code> during startup.
	 */
	static public var debug:Bool = false;

	/**
	 * Represents the amount of time in seconds that passed since last frame.
	 */
	static public var elapsed:Float = Math.NaN;
	/**
	 * How fast or slow time should pass in the game; default is 1.0.
	 */
	static public var timeScale:Float = Math.NaN;
	/**
	 * The width of the screen in game pixels.
	 */
	static public var width:UInt = 0;
	/**
	 * The height of the screen in game pixels.
	 */
	static public var height:UInt = 0;
	/**
	 * The dimensions of the game world, used by the quad tree for collisions and overlap checks.
	 */
	static public var worldBounds:FlxRect;
	/**
	 * How many times the quad tree should divide the world on each axis.
	 * Generally, sparse collisions can have fewer divisons,
	 * while denser collision activity usually profits from more.
	 * Default value is 6.
	 */
	static public var worldDivisions:UInt = 0;
	/**
	 * Whether to show visual debug displays or not.
	 * Default = false.
	 */
	static public var visualDebug:Bool = false;
	/**
	 * Setting this to true will disable/skip stuff that isn't necessary for mobile platforms like Android. [BETA]
	 */
	static public var mobile:Bool = false;
	/**
	 * The global random number generator seed (for deterministic behavior in recordings and saves).
	 */
	static public var globalSeed:Float = Math.NaN;
	/**
	 * <code>FlxG.levels</code> and <code>FlxG.scores</code> are generic
	 * global variables that can be used for various cross-state stuff.
	 */
	static public var levels:Array<ASAny>;
	static public var level:Int = 0;
	static public var scores:Array<ASAny>;
	static public var score:Int = 0;
	/**
	 * <code>FlxG.saves</code> is a generic bucket for storing
	 * FlxSaves so you can access them whenever you want.
	 */
	static public var saves:Array<ASAny>;
	static public var save:Int = 0;

	/**
	 * A reference to a <code>FlxMouse</code> object.  Important for input!
	 */
	static public var mouse:Mouse;
	/**
	 * A reference to a <code>FlxKeyboard</code> object.  Important for input!
	 */
	static public var keys:Keyboard;

	/**
	 * A handy container for a background music object.
	 */
	static public var music:FlxSound;
	/**
	 * A list of all the sounds being played in the game.
	 */
	static public var sounds:FlxGroup;
	/**
	 * Whether or not the game sounds are muted.
	 */
	static public var mute:Bool = false;
	/**
	 * Internal volume level, used for global sound control.
	 */
	static var _volume:Float = Math.NaN;

	/**
	 * An array of <code>FlxCamera</code> objects that are used to draw stuff.
	 * By default flixel creates one camera the size of the screen.
	 */
	static public var cameras:Array<ASAny>;
	/**
	 * By default this just refers to the first entry in the cameras array
	 * declared above, but you can do what you like with it.
	 */
	static public var camera:FlxCamera;
	/**
	 * Allows you to possibly slightly optimize the rendering process IF
	 * you are not doing any pre-processing in your game state's <code>draw()</code> call.
	 * @default false
	 */
	static public var useBufferLocking:Bool = false;
	/**
	 * Internal helper variable for clearing the cameras each frame.
	 */
	static var _cameraRect:Rectangle;

	/**
	 * An array container for plugins.
	 * By default flixel uses a couple of plugins:
	 * DebugPathDisplay, and TimerManager.
	 */
	static public var plugins:Array<ASAny>;

	/**
	 * Set this hook to get a callback whenever the volume changes.
	 * Function should take the form <code>myVolumeHandler(Volume:Number)</code>.
	 */
	static public var volumeHandler:ASFunction;

	/**
	 * Useful helper objects for doing Flash-specific rendering.
	 * Primarily used for "debug visuals" like drawing bounding boxes directly to the screen buffer.
	 */
	static public var flashGfxSprite:Sprite;
	static public var flashGfx:Graphics;

	/**
	 * Internal storage system to prevent graphics from being used repeatedly in memory.
	 */
	static var _cache:ASAny;

	static public function getLibraryName():String {
		return FlxG.LIBRARY_NAME + " v" + FlxG.LIBRARY_MAJOR_VERSION + "." + FlxG.LIBRARY_MINOR_VERSION;
	}

	/**
	 * Log data to the debugger.
	 *
	 * @param	Data		Anything you want to log to the console.
	 */
	static public function log(Data:ASAny) {
		if ((_game != null) && (_game._debugger != null)) {
			_game._debugger.log.add((Data == null) ? "ERROR: null object" : Std.string(Data));
		}
	}

	/**
	 * Add a variable to the watch list in the debugger.
	 * This lets you see the value of the variable all the time.
	 *
	 * @param	AnyObject		A reference to any object in your game, e.g. Player or Robot or this.
	 * @param	VariableName	The name of the variable you want to watch, in quotes, as a string: e.g. "speed" or "health".
	 * @param	DisplayName		Optional, display your own string instead of the class name + variable name: e.g. "enemy count".
	 */
	static public function watch(AnyObject:ASAny, VariableName:String, DisplayName:String = null) {
		if ((_game != null) && (_game._debugger != null)) {
			_game._debugger.watch.add(AnyObject, VariableName, DisplayName);
		}
	}

	/**
	 * Remove a variable from the watch list in the debugger.
	 * Don't pass a Variable Name to remove all watched variables for the specified object.
	 *
	 * @param	AnyObject		A reference to any object in your game, e.g. Player or Robot or this.
	 * @param	VariableName	The name of the variable you want to watch, in quotes, as a string: e.g. "speed" or "health".
	 */
	static public function unwatch(AnyObject:ASAny, VariableName:String = null) {
		if ((_game != null) && (_game._debugger != null)) {
			_game._debugger.watch.remove(AnyObject, VariableName);
		}
	}

	/**
	 * How many times you want your game to update each second.
	 * More updates usually means better collisions and smoother motion.
	 * NOTE: This is NOT the same thing as the Flash Player framerate!
	 */
	
	/**
	 * @private
	 */
	@:flash.property public static var framerate(get,set):Float;
static function  get_framerate():Float {
		return 1000 / _game._step;
	}
static function  set_framerate(Framerate:Float):Float{
		_game._step = Std.int(1000 / Framerate);
		if (_game._maxAccumulation < _game._step) {
			_game._maxAccumulation = _game._step;
		}
return Framerate;
	}

	/**
	 * How many times you want your game to update each second.
	 * More updates usually means better collisions and smoother motion.
	 * NOTE: This is NOT the same thing as the Flash Player framerate!
	 */
	
	/**
	 * @private
	 */
	@:flash.property public static var flashFramerate(get,set):Float;
static function  get_flashFramerate():Float {
		if (_game.root != null) {
			return _game.stage.frameRate;
		} else {
			return 0;
		}
	}
static function  set_flashFramerate(Framerate:Float):Float{
		_game._flashFramerate = Std.int(Framerate);
		if (_game.root != null) {
			_game.stage.frameRate = _game._flashFramerate;
		}
		_game._maxAccumulation = Std.int(2000 / _game._flashFramerate - 1);
		if (_game._maxAccumulation < _game._step) {
			_game._maxAccumulation = _game._step;
		}
return Framerate;
	}

	/**
	 * Generates a random number.  Deterministic, meaning safe
	 * to use if you want to record replays in random environments.
	 *
	 * @return	A <code>Number</code> between 0 and 1.
	 */
	static public function random():Float {
		return globalSeed = FlxU.srand(globalSeed);
	}

	/**
	 * Shuffles the entries in an array into a new random order.
	 * <code>FlxG.shuffle()</code> is deterministic and safe for use with replays/recordings.
	 * HOWEVER, <code>FlxU.shuffle()</code> is NOT deterministic and unsafe for use with replays/recordings.
	 *
	 * @param	A				A Flash <code>Array</code> object containing...stuff.
	 * @param	HowManyTimes	How many swaps to perform during the shuffle operation.  Good rule of thumb is 2-4 times as many objects are in the list.
	 *
	 * @return	The same Flash <code>Array</code> object that you passed in in the first place.
	 */
	static public function shuffle(Objects:Array<ASAny>, HowManyTimes:UInt):Array<ASAny> {
		var i:UInt = 0;
		var index1:UInt;
		var index2:UInt;
		var object:ASAny;
		while (i < HowManyTimes) {
			index1 = Std.int(FlxG.random() * Objects.length);
			index2 = Std.int(FlxG.random() * Objects.length);
			object = Objects[index2];
			Objects[index2] = Objects[index1];
			Objects[index1] = object;
			i++;
		}
		return Objects;
	}

	/**
	 * Fetch a random entry from the given array.
	 * Will return null if random selection is missing, or array has no entries.
	 * <code>FlxG.getRandom()</code> is deterministic and safe for use with replays/recordings.
	 * HOWEVER, <code>FlxU.getRandom()</code> is NOT deterministic and unsafe for use with replays/recordings.
	 *
	 * @param	Objects		A Flash array of objects.
	 * @param	StartIndex	Optional offset off the front of the array. Default value is 0, or the beginning of the array.
	 * @param	Length		Optional restriction on the number of values you want to randomly select from.
	 *
	 * @return	The random object that was selected.
	 */
	static public function getRandom(Objects:Array<ASAny>, StartIndex:UInt = 0, Length:UInt = 0):ASAny {
		if (Objects != null) {
			var l= Length;
			if ((l == 0) || (l > Objects.length - StartIndex)) {
				l = Objects.length - StartIndex;
			}
			if (l > 0) {
				return Objects[StartIndex + Std.int(FlxG.random() * l)];
			}
		}
		return null;
	}

	/**
	 * Load replay data from a string and play it back.
	 *
	 * @param	Data		The replay that you want to load.
	 * @param	State		Optional parameter: if you recorded a state-specific demo or cutscene, pass a new instance of that state here.
	 * @param	CancelKeys	Optional parameter: an array of string names of keys (see FlxKeyboard) that can be pressed to cancel the playback, e.g. ["ESCAPE","ENTER"].  Also accepts 2 custom key names: "ANY" and "MOUSE" (fairly self-explanatory I hope!).
	 * @param	Timeout		Optional parameter: set a time limit for the replay.  CancelKeys will override this if pressed.
	 * @param	Callback	Optional parameter: if set, called when the replay finishes.  Running to the end, CancelKeys, and Timeout will all trigger Callback(), but only once, and CancelKeys and Timeout will NOT call FlxG.stopReplay() if Callback is set!
	 */
	static public function loadReplay(Data:String, State:FlxState = null, CancelKeys:Array<ASAny> = null, Timeout:Float = 0, Callback:ASFunction = null) {
		_game._replay.load(Data);
		if (State == null) {
			FlxG.resetGame();
		} else {
			FlxG.switchState(State);
		}
		_game._replayCancelKeys = CancelKeys;
		_game._replayTimer = Std.int(Timeout * 1000);
		_game._replayCallback = Callback;
		_game._replayRequested = true;
	}

	/**
	 * Resets the game or state and replay requested flag.
	 *
	 * @param	StandardMode	If true, reload entire game, else just reload current game state.
	 */
	static public function reloadReplay(StandardMode:Bool = true) {
		if (StandardMode) {
			FlxG.resetGame();
		} else {
			FlxG.resetState();
		}
		if (_game._replay.frameCount > 0) {
			_game._replayRequested = true;
		}
	}

	/**
	 * Stops the current replay.
	 */
	static public function stopReplay() {
		_game._replaying = false;
		resetInput();
	}

	/**
	 * Resets the game or state and requests a new recording.
	 *
	 * @param	StandardMode	If true, reset the entire game, else just reset the current state.
	 */
	static public function recordReplay(StandardMode:Bool = true) {
		if (StandardMode) {
			FlxG.resetGame();
		} else {
			FlxG.resetState();
		}
		_game._recordingRequested = true;
	}

	/**
	 * Stop recording the current replay and return the replay data.
	 *
	 * @return	The replay data in simple ASCII format (see <code>FlxReplay.save()</code>).
	 */
	static public function stopRecording():String {
		_game._recording = false;
		return _game._replay.save();
	}

	/**
	 * Request a reset of the current game state.
	 */
	static public function resetState() {
		_game._requestedState = Type.createInstance(FlxU.getClass(FlxU.getClassName(_game._state, false)), []);
	}

	/**
	 * Like hitting the reset button on a game console, this will re-launch the game as if it just started.
	 */
	static public function resetGame() {
		_game._requestedReset = true;
	}

	/**
	 * Reset the input helper objects (useful when changing screens or states)
	 */
	static public function resetInput() {
		keys.reset();
		mouse.reset();
	}

	/**
	 * Set up and play a looping background soundtrack.
	 *
	 * @param	Music		The sound file you want to loop in the background.
	 * @param	Volume		How loud the sound should be, from 0 to 1.
	 */
	static public function playMusic(Music:String, Volume:Float = 1.0) {
		if (music == null) {
			music = new FlxSound();
		} else if (music.active) {
			music.stop();
		}
		music.loadEmbedded(Music, true);
		music.volume = Volume;
		music.survive = true;
		music.play();
	}

	/**
	 * Creates a new sound object.
	 *
	 * @param	EmbeddedSound	The embedded sound resource you want to play.  To stream, use the optional URL parameter instead.
	 * @param	Volume			How loud to play it (0 to 1).
	 * @param	Looped			Whether to loop this sound.
	 * @param	AutoDestroy		Whether to destroy this sound when it finishes playing.  Leave this value set to "false" if you want to re-use this <code>FlxSound</code> instance.
	 * @param	AutoPlay		Whether to play the sound.
	 * @param	URL				Load a sound from an external web resource instead.  Only used if EmbeddedSound = null.
	 *
	 * @return	A <code>FlxSound</code> object.
	 */
	static public function loadSound(EmbeddedSound:String = null, Volume:Float = 1.0, Looped:Bool = false, AutoDestroy:Bool = false, AutoPlay:Bool = false, URL:String = null):FlxSound {
		if ((EmbeddedSound == null) && (URL == null)) {
			FlxG.log("WARNING: FlxG.loadSound() requires either\nan embedded sound or a URL to work.");
			return null;
		}
		var sound= Std.downcast(sounds.recycle(FlxSound) , FlxSound);
		if (EmbeddedSound != null) {
			sound.loadEmbedded(EmbeddedSound, Looped, AutoDestroy);
		} else {
			sound.loadStream(URL, Looped, AutoDestroy);
		}
		sound.volume = Volume;
		if (AutoPlay) {
			sound.play();
		}
		return sound;
	}

	/**
	 * Creates a new sound object from an embedded <code>Class</code> object.
	 * NOTE: Just calls FlxG.loadSound() with AutoPlay == true.
	 *
	 * @param	EmbeddedSound	The sound you want to play.
	 * @param	Volume			How loud to play it (0 to 1).
	 * @param	Looped			Whether to loop this sound.
	 * @param	AutoDestroy		Whether to destroy this sound when it finishes playing.  Leave this value set to "false" if you want to re-use this <code>FlxSound</code> instance.
	 *
	 * @return	A <code>FlxSound</code> object.
	 */
	static public function play(EmbeddedSound:String, Volume:Float = 1.0, Looped:Bool = false, AutoDestroy:Bool = true):FlxSound {
		if (EmbeddedSound == null) return null;
		return FlxG.loadSound(EmbeddedSound, Volume, Looped, AutoDestroy, true);
	}

	/**
	 * Creates a new sound object from a URL.
	 * NOTE: Just calls FlxG.loadSound() with AutoPlay == true.
	 *
	 * @param	URL		The URL of the sound you want to play.
	 * @param	Volume	How loud to play it (0 to 1).
	 * @param	Looped	Whether or not to loop this sound.
	 * @param	AutoDestroy		Whether to destroy this sound when it finishes playing.  Leave this value set to "false" if you want to re-use this <code>FlxSound</code> instance.
	 *
	 * @return	A FlxSound object.
	 */
	static public function stream(URL:String, Volume:Float = 1.0, Looped:Bool = false, AutoDestroy:Bool = true):FlxSound {
		return FlxG.loadSound(null, Volume, Looped, AutoDestroy, true, URL);
	}

	/**
	 * Set <code>volume</code> to a number between 0 and 1 to change the global volume.
	 *
	 * @default 0.5
	 */
	
	/**
	 * @private
	 */
	@:flash.property public static var volume(get,set):Float;
static function  get_volume():Float {
		return _volume;
	}
static function  set_volume(Volume:Float):Float{
		_volume = Volume;
		if (_volume < 0) {
			_volume = 0;
		} else if (_volume > 1) {
			_volume = 1;
		}
		if (volumeHandler != null) {
			volumeHandler(FlxG.mute ? 0 : _volume);
		}
return Volume;
	}
@:allow(org.flixel) 
	/**
	 * Called by FlxGame on state changes to stop and destroy sounds.
	 *
	 * @param	ForceDestroy		Kill sounds even if they're flagged <code>survive</code>.
	 */
	static function destroySounds(ForceDestroy:Bool = false) {
		if ((music != null) && (ForceDestroy || !music.survive)) {
			music.destroy();
			music = null;
		}
		var i:UInt = 0;
		var sound:FlxSound;
		var l:UInt = sounds.members.length;
		while (i < l) {
			sound = ASCompat.dynamicAs(sounds.members[i++] , FlxSound);
			if ((sound != null) && (ForceDestroy || !sound.survive)) {
				sound.destroy();
			}
		}
	}
@:allow(org.flixel) 
	/**
	 * Called by the game loop to make sure the sounds get updated each frame.
	 */
	static function updateSounds() {
		if ((music != null) && music.active) {
			music.update();
		}
		if ((sounds != null) && sounds.active) {
			sounds.update();
		}
	}

	/**
	 * Pause all sounds currently playing.
	 */
	static public function pauseSounds() {
		if ((music != null) && music.exists && music.active) {
			music.pause();
		}
		var i:UInt = 0;
		var sound:FlxSound;
		var l:UInt = Std.int(sounds.length);
		while (i < l) {
			sound = ASCompat.dynamicAs(sounds.members[i++] , FlxSound);
			if ((sound != null) && sound.exists && sound.active) {
				sound.pause();
			}
		}
	}

	/**
	 * Resume playing existing sounds.
	 */
	static public function resumeSounds() {
		if ((music != null) && music.exists) {
			music.play();
		}
		var i:UInt = 0;
		var sound:FlxSound;
		var l:UInt = Std.int(sounds.length);
		while (i < l) {
			sound = ASCompat.dynamicAs(sounds.members[i++] , FlxSound);
			if ((sound != null) && sound.exists) {
				sound.resume();
			}
		}
	}

	/**
	 * Check the local bitmap cache to see if a bitmap with this key has been loaded already.
	 *
	 * @param	Key		The string key identifying the bitmap.
	 *
	 * @return	Whether or not this file can be found in the cache.
	 */
	static public function checkBitmapCache(Key:String):Bool {
		return (_cache[Key] != /*undefined*/null) && (_cache[Key] != null);
	}

	/**
	 * Generates a new <code>BitmapData</code> object (a colored square) and caches it.
	 *
	 * @param	Width	How wide the square should be.
	 * @param	Height	How high the square should be.
	 * @param	Color	What color the square should be (0xAARRGGBB)
	 * @param	Unique	Ensures that the bitmap data uses a new slot in the cache.
	 * @param	Key		Force the cache to use a specific Key to index the bitmap.
	 *
	 * @return	The <code>BitmapData</code> we just created.
	 */
	static public function createBitmap(Width:UInt, Height:UInt, Color:UInt, Unique:Bool = false, Key:String = null):BitmapData {
		if (Key == null) {
			Key = Width + "x" + Height + ":" + Color;
			if (Unique && checkBitmapCache(Key)) {
				var inc:UInt = 0;
				var ukey:String;
				do {
					ukey = Key + inc++;
				} while (checkBitmapCache(ukey));
				Key = ukey;
			}
		}
		if (!checkBitmapCache(Key)) {
			_cache[Key] = new BitmapData(Width, Height, true, Color);
		}
		return _cache[Key];
	}

	/**
	 * Loads a bitmap from a file, caches it, and generates a horizontally flipped version if necessary.
	 *
	 * @param	Graphic		The image file that you want to load.
	 * @param	Reverse		Whether to generate a flipped version.
	 * @param	Unique		Ensures that the bitmap data uses a new slot in the cache.
	 * @param	Key			Force the cache to use a specific Key to index the bitmap.
	 *
	 * @return	The <code>BitmapData</code> we just created.
	 */
	static public function addBitmap(Graphic:String, Reverse:Bool = false, Unique:Bool = false, Key:String = null):BitmapData {
		if (Graphic == null) {
			return new BitmapData(1, 1, true, 0x00000000);
		}
		var needReverse= false;
		if (Key == null) {
			Key = Graphic + (Reverse ? "_REVERSE_" : "");
			if (Unique && checkBitmapCache(Key)) {
				var inc:UInt = 0;
				var ukey:String;
				do {
					ukey = Key + inc++;
				} while (checkBitmapCache(ukey));
				Key = ukey;
			}
		}

		//If there is no data for this key, generate the requested graphic
		if (!checkBitmapCache(Key)) {
			var bd = openfl.Assets.getBitmapData(Graphic);
			if (bd == null) return new BitmapData(1, 1, true, 0x00000000);
			_cache[Key] = bd;
			if (Reverse) {
				needReverse = true;
			}
		}
		var pixels:BitmapData = _cache[Key];
		if (!needReverse && Reverse && (pixels.width == openfl.Assets.getBitmapData(Graphic).width)) {
			needReverse = true;
		}
		if (needReverse) {
			var newPixels= new BitmapData(pixels.width << 1, pixels.height, true, 0x00000000);
			newPixels.draw(pixels);
			var mtx= new Matrix();
			mtx.scale(-1, 1);
			mtx.translate(newPixels.width, 0);
			newPixels.draw(pixels, mtx);
			pixels = newPixels;
			_cache[Key] = pixels;
		}
		return pixels;
	}

	/**
	 * Dumps the cache's image references.
	 */
	static public function clearBitmapCache() {
		_cache = {};
	}

	/**
	 * Read-only: retrieves the Flash stage object (required for event listeners)
	 * Will be null if it's not safe/useful yet.
	 */
	@:flash.property public static var stage(get,never):Stage;
static function  get_stage():Stage {
		if (_game.root != null) {
			return _game.stage;
		}
		return null;
	}

	/**
	 * Read-only: access the current game state from anywhere.
	 */
	@:flash.property public static var state(get,never):FlxState;
static function  get_state():FlxState {
		return _game._state;
	}

	/**
	 * Switch from the current game state to the one specified here.
	 */
	static public function switchState(State:FlxState) {
		_game._requestedState = State;
	}

	/**
	 * Change the way the debugger's windows are laid out.
	 *
	 * @param	Layout		See the presets above (e.g. <code>DEBUGGER_MICRO</code>, etc).
	 */
	static public function setDebuggerLayout(Layout:UInt) {
		if (_game._debugger != null) {
			_game._debugger.setLayout(Layout);
		}
	}

	/**
	 * Just resets the debugger windows to whatever the last selected layout was (<code>DEBUGGER_STANDARD</code> by default).
	 */
	static public function resetDebuggerLayout() {
		if (_game._debugger != null) {
			_game._debugger.resetLayout();
		}
	}

	/**
	 * Add a new camera object to the game.
	 * Handy for PiP, split-screen, etc.
	 *
	 * @param	NewCamera	The camera you want to add.
	 *
	 * @return	This <code>FlxCamera</code> instance.
	 */
	static public function addCamera(NewCamera:FlxCamera):FlxCamera {
		FlxG._game.addChildAt(NewCamera._flashSprite, FlxG._game.getChildIndex(FlxG._game._mouse));
		FlxG.cameras.push(NewCamera);
		return NewCamera;
	}

	/**
	 * Remove a camera from the game.
	 *
	 * @param	Camera	The camera you want to remove.
	 * @param	Destroy	Whether to call destroy() on the camera, default value is true.
	 */
	static public function removeCamera(Camera:FlxCamera, Destroy:Bool = true) {
		try {
			FlxG._game.removeChild(Camera._flashSprite);
		} catch (E:Dynamic) {
			FlxG.log("Error removing camera, not part of game.");
		}
		if (Destroy) {
			Camera.destroy();
		}
	}

	/**
	 * Dumps all the current cameras and resets to just one camera.
	 * Handy for doing split-screen especially.
	 *
	 * @param	NewCamera	Optional; specify a specific camera object to be the new main camera.
	 */
	static public function resetCameras(NewCamera:FlxCamera = null) {
		var cam:FlxCamera;
		var i:UInt = 0;
		var l:UInt = cameras.length;
		while (i < l) {
			cam = ASCompat.dynamicAs(FlxG.cameras[i++] , FlxCamera);
			FlxG._game.removeChild(cam._flashSprite);
			cam.destroy();
		}
		FlxG.cameras.resize(0);

		if (NewCamera == null) {
			NewCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height)
;		}
		FlxG.camera = FlxG.addCamera(NewCamera);
	}

	/**
	 * All screens are filled with this color and gradually return to normal.
	 *
	 * @param	Color		The color you want to use.
	 * @param	Duration	How long it takes for the flash to fade.
	 * @param	OnComplete	A function you want to run when the flash finishes.
	 * @param	Force		Force the effect to reset.
	 */
	static public function flash(Color:UInt = 0xffffffff, Duration:Float = 1, OnComplete:ASFunction = null, Force:Bool = false) {
		var i:UInt = 0;
		var l:UInt = FlxG.cameras.length;
		while (i < l) {
			ASCompat.dynamicAs(FlxG.cameras[i++] , FlxCamera).flash(Color, Duration, OnComplete, Force);
		}
	}

	/**
	 * The screen is gradually filled with this color.
	 *
	 * @param	Color		The color you want to use.
	 * @param	Duration	How long it takes for the fade to finish.
	 * @param	OnComplete	A function you want to run when the fade finishes.
	 * @param	Force		Force the effect to reset.
	 */
	static public function fade(Color:UInt = 0xff000000, Duration:Float = 1, OnComplete:ASFunction = null, Force:Bool = false) {
		var i:UInt = 0;
		var l:UInt = FlxG.cameras.length;
		while (i < l) {
			ASCompat.dynamicAs(FlxG.cameras[i++] , FlxCamera).fade(Color, Duration, OnComplete, Force);
		}
	}

	/**
	 * A simple screen-shake effect.
	 *
	 * @param	Intensity	Percentage of screen size representing the maximum distance that the screen can move while shaking.
	 * @param	Duration	The length in seconds that the shaking effect should last.
	 * @param	OnComplete	A function you want to run when the shake effect finishes.
	 * @param	Force		Force the effect to reset (default = true, unlike flash() and fade()!).
	 * @param	Direction	Whether to shake on both axes, just up and down, or just side to side (use class constants SHAKE_BOTH_AXES, SHAKE_VERTICAL_ONLY, or SHAKE_HORIZONTAL_ONLY).  Default value is SHAKE_BOTH_AXES (0).
	 */
	static public function shake(Intensity:Float = 0.05, Duration:Float = 0.5, OnComplete:ASFunction = null, Force:Bool = true, Direction:UInt = 0) {
		var i:UInt = 0;
		var l:UInt = FlxG.cameras.length;
		while (i < l) {
			ASCompat.dynamicAs(FlxG.cameras[i++] , FlxCamera).shake(Intensity, Duration, OnComplete, Force, Direction);
		}
	}

	/**
	 * Get and set the background color of the game.
	 * Get functionality is equivalent to FlxG.camera.bgColor.
	 * Set functionality sets the background color of all the current cameras.
	 */
	
	@:flash.property public static var bgColor(get,set):UInt;
static function  get_bgColor():UInt {
		if (FlxG.camera == null) {
			return 0xff000000;
		} else {
			return FlxG.camera.bgColor;
		}
	}
static function  set_bgColor(Color:UInt):UInt{
		var i:UInt = 0;
		var l:UInt = FlxG.cameras.length;
		while (i < l) {
			ASCompat.dynamicAs(FlxG.cameras[i++] , FlxCamera).bgColor = Color;
		}
return Color;
	}

	/**
	 * Call this function to see if one <code>FlxObject</code> overlaps another.
	 * Can be called with one object and one group, or two groups, or two objects,
	 * whatever floats your boat! For maximum performance try bundling a lot of objects
	 * together using a <code>FlxGroup</code> (or even bundling groups together!).
	 *
	 * <p>NOTE: does NOT take objects' scrollfactor into account, all overlaps are checked in world space.</p>
	 *
	 * @param	ObjectOrGroup1	The first object or group you want to check.
	 * @param	ObjectOrGroup2	The second object or group you want to check.  If it is the same as the first, flixel knows to just do a comparison within that group.
	 * @param	NotifyCallback	A function with two <code>FlxObject</code> parameters - e.g. <code>myOverlapFunction(Object1:FlxObject,Object2:FlxObject)</code> - that is called if those two objects overlap.
	 * @param	ProcessCallback	A function with two <code>FlxObject</code> parameters - e.g. <code>myOverlapFunction(Object1:FlxObject,Object2:FlxObject)</code> - that is called if those two objects overlap.  If a ProcessCallback is provided, then NotifyCallback will only be called if ProcessCallback returns true for those objects!
	 *
	 * @return	Whether any oevrlaps were detected.
	 */
	static public function overlap(ObjectOrGroup1:FlxBasic = null, ObjectOrGroup2:FlxBasic = null, NotifyCallback:ASFunction = null, ProcessCallback:ASFunction = null):Bool {
		if (ObjectOrGroup1 == null) {
			ObjectOrGroup1 = FlxG.state;
		}
		if (ObjectOrGroup2 == ObjectOrGroup1) {
			ObjectOrGroup2 = null;
		}
		FlxQuadTree.divisions = FlxG.worldDivisions;
		var quadTree= new FlxQuadTree(FlxG.worldBounds.x, FlxG.worldBounds.y, FlxG.worldBounds.width, FlxG.worldBounds.height);
		quadTree.load(ObjectOrGroup1, ObjectOrGroup2, NotifyCallback, ProcessCallback);
		var result= quadTree.execute();
		quadTree.destroy();
		return result;
	}

	/**
	 * Call this function to see if one <code>FlxObject</code> collides with another.
	 * Can be called with one object and one group, or two groups, or two objects,
	 * whatever floats your boat! For maximum performance try bundling a lot of objects
	 * together using a <code>FlxGroup</code> (or even bundling groups together!).
	 *
	 * <p>This function just calls FlxG.overlap and presets the ProcessCallback parameter to FlxObject.separate.
	 * To create your own collision logic, write your own ProcessCallback and use FlxG.overlap to set it up.</p>
	 *
	 * <p>NOTE: does NOT take objects' scrollfactor into account, all overlaps are checked in world space.</p>
	 *
	 * @param	ObjectOrGroup1	The first object or group you want to check.
	 * @param	ObjectOrGroup2	The second object or group you want to check.  If it is the same as the first, flixel knows to just do a comparison within that group.
	 * @param	NotifyCallback	A function with two <code>FlxObject</code> parameters - e.g. <code>myOverlapFunction(Object1:FlxObject,Object2:FlxObject)</code> - that is called if those two objects overlap.
	 *
	 * @return	Whether any objects were successfully collided/separated.
	 */
	static public function collide(ObjectOrGroup1:FlxBasic = null, ObjectOrGroup2:FlxBasic = null, NotifyCallback:ASFunction = null):Bool {
		return overlap(ObjectOrGroup1, ObjectOrGroup2, NotifyCallback, FlxObject.separate);
	}

	/**
	 * Adds a new plugin to the global plugin array.
	 *
	 * @param	Plugin	Any object that extends FlxBasic. Useful for managers and other things.  See org.flixel.plugin for some examples!
	 *
	 * @return	The same <code>FlxBasic</code>-based plugin you passed in.
	 */
	static public function addPlugin(Plugin:FlxBasic):FlxBasic {
		//Don't add repeats
		var pluginList= FlxG.plugins;
		var i:UInt = 0;
		var l:UInt = pluginList.length;
		while (i < l) {
			if (Std.string(pluginList[i++]) == Plugin.toString()) {
				return Plugin;
			}
		}

		//no repeats! safe to add a new instance of this plugin
		pluginList.push(Plugin);
		return Plugin;
	}

	/**
	 * Retrieves a plugin based on its class name from the global plugin array.
	 *
	 * @param	ClassType	The class name of the plugin you want to retrieve. See the <code>FlxPath</code> or <code>FlxTimer</code> constructors for example usage.
	 *
	 * @return	The plugin object, or null if no matching plugin was found.
	 */
	static public function getPlugin(ClassType:Class<Dynamic>):FlxBasic {
		var pluginList= FlxG.plugins;
		var i:UInt = 0;
		var l:UInt = pluginList.length;
		while (i < l) {
			if (Std.is(pluginList[i] , ClassType)) {
				return plugins[i];
			}
			i++;
		}
		return null;
	}

	/**
	 * Removes an instance of a plugin from the global plugin array.
	 *
	 * @param	Plugin	The plugin instance you want to remove.
	 *
	 * @return	The same <code>FlxBasic</code>-based plugin you passed in.
	 */
	static public function removePlugin(Plugin:FlxBasic):FlxBasic {
		//Don't add repeats
		var pluginList= FlxG.plugins;
		var i= pluginList.length - 1;
		while (i >= 0) {
			if (pluginList[i] == Plugin) {
				pluginList.splice(i, 1);
			}
			i--;
		}
		return Plugin;
	}

	/**
	 * Removes an instance of a plugin from the global plugin array.
	 *
	 * @param	ClassType	The class name of the plugin type you want removed from the array.
	 *
	 * @return	Whether or not at least one instance of this plugin type was removed.
	 */
	static public function removePluginType(ClassType:Class<Dynamic>):Bool {
		//Don't add repeats
		var results= false;
		var pluginList= FlxG.plugins;
		var i= pluginList.length - 1;
		while (i >= 0) {
			if (Std.is(pluginList[i] , ClassType)) {
				pluginList.splice(i, 1);
				results = true;
			}
			i--;
		}
		return results;
	}
@:allow(org.flixel) 
	/**
	 * Called by <code>FlxGame</code> to set up <code>FlxG</code> during <code>FlxGame</code>'s constructor.
	 */
	static function init(Game:FlxGame, Width:UInt, Height:UInt, Zoom:Float) {
		FlxG._game = Game;
		FlxG.width = Width;
		FlxG.height = Height;

		FlxG.mute = false;
		FlxG._volume = 0.5;
		FlxG.sounds = new FlxGroup();
		FlxG.volumeHandler = null;

		FlxG.clearBitmapCache();

		if (flashGfxSprite == null) {
			flashGfxSprite = new Sprite();
			flashGfx = flashGfxSprite.graphics;
		}

		FlxCamera.defaultZoom = Zoom;
		FlxG._cameraRect = new Rectangle();
		FlxG.cameras = [];
		useBufferLocking = false;

		plugins = [];
		addPlugin(new DebugPathDisplay());
		addPlugin(new TimerManager());

		FlxG.mouse = new Mouse(FlxG._game._mouse);
		FlxG.keys = new Keyboard();
		FlxG.mobile = false;

		FlxG.levels = [];
		FlxG.scores = [];
		FlxG.visualDebug = false;
	}
@:allow(org.flixel) 
	/**
	 * Called whenever the game is reset, doesn't have to do quite as much work as the basic initialization stuff.
	 */
	static function reset() {
		FlxG.clearBitmapCache();
		FlxG.resetInput();
		FlxG.destroySounds(true);
		FlxG.levels.resize(0);
		FlxG.scores.resize(0);
		FlxG.level = 0;
		FlxG.score = 0;
		FlxG.paused = false;
		FlxG.timeScale = 1.0;
		FlxG.elapsed = 0;
		FlxG.globalSeed = Math.random();
		FlxG.worldBounds = new FlxRect(-10, -10, FlxG.width + 20, FlxG.height + 20);
		FlxG.worldDivisions = 6;
		var debugPathDisplay= Std.downcast(FlxG.getPlugin(DebugPathDisplay) , DebugPathDisplay);
		if (debugPathDisplay != null) {
			debugPathDisplay.clear();
		}
	}
@:allow(org.flixel) 
	/**
	 * Called by the game object to update the keyboard and mouse input tracking objects.
	 */
	static function updateInput() {
		FlxG.keys.update();
		if (!_game._debuggerUp || !_game._debugger.hasMouse) {
			FlxG.mouse.update(Std.int(FlxG._game.mouseX), Std.int(FlxG._game.mouseY));
		}
	}
@:allow(org.flixel) 
	/**
	 * Called by the game object to lock all the camera buffers and clear them for the next draw pass.
	 */
	static function lockCameras() {
		var cam:FlxCamera;
		var cams= FlxG.cameras;
		var i:UInt = 0;
		var l:UInt = cams.length;
		while (i < l) {
			cam = ASCompat.dynamicAs(cams[i++] , FlxCamera);
			if ((cam == null) || !cam.exists || !cam.visible) {
				continue;
			}
			if (useBufferLocking) {
				cam.buffer.lock();
			}
			cam.fill(cam.bgColor);
			cam.screen.dirty = true;
		}
	}
@:allow(org.flixel) 
	/**
	 * Called by the game object to draw the special FX and unlock all the camera buffers.
	 */
	static function unlockCameras() {
		var cam:FlxCamera;
		var cams= FlxG.cameras;
		var i:UInt = 0;
		var l:UInt = cams.length;
		while (i < l) {
			cam = ASCompat.dynamicAs(cams[i++] , FlxCamera);
			if ((cam == null) || !cam.exists || !cam.visible) {
				continue;
			}
			cam.drawFX();
			if (useBufferLocking) {
				cam.buffer.unlock();
			}
		}
	}
@:allow(org.flixel) 
	/**
	 * Called by the game object to update the cameras and their tracking/special effects logic.
	 */
	static function updateCameras() {
		var cam:FlxCamera;
		var cams= FlxG.cameras;
		var i:UInt = 0;
		var l:UInt = cams.length;
		while (i < l) {
			cam = ASCompat.dynamicAs(cams[i++] , FlxCamera);
			if ((cam != null) && cam.exists) {
				if (cam.active) {
					cam.update();
				}
				cam._flashSprite.x = cam.x + cam._flashOffsetX;
				cam._flashSprite.y = cam.y + cam._flashOffsetY;
				cam._flashSprite.visible = cam.visible;
			}
		}
	}
@:allow(org.flixel) 
	/**
	 * Used by the game object to call <code>update()</code> on all the plugins.
	 */
	static function updatePlugins() {
		var plugin:FlxBasic;
		var pluginList= FlxG.plugins;
		var i:UInt = 0;
		var l:UInt = pluginList.length;
		while (i < l) {
			plugin = ASCompat.dynamicAs(pluginList[i++] , FlxBasic);
			if (plugin.exists && plugin.active) {
				plugin.update();
			}
		}
	}
@:allow(org.flixel) 
	/**
	 * Used by the game object to call <code>draw()</code> on all the plugins.
	 */
	static function drawPlugins() {
		var plugin:FlxBasic;
		var pluginList= FlxG.plugins;
		var i:UInt = 0;
		var l:UInt = pluginList.length;
		while (i < l) {
			plugin = ASCompat.dynamicAs(pluginList[i++] , FlxBasic);
			if (plugin.exists && plugin.visible) {
				plugin.draw();
			}
		}
	}
}


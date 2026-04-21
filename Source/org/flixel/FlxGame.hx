package org.flixel ;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.*;
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Mouse;
import org.flixel.system.FlxDebugger;
import org.flixel.system.FlxReplay;

/**
 * FlxGame is the heart of all flixel games, and contains a bunch of basic game loops and things.
 * It is a long and sloppy file that you shouldn't have to worry about too much!
 * It is basically only used to create your game object in the first place,
 * after that FlxG and FlxState have all the useful stuff you actually need.
 *
 * @author	Adam Atomic
 */
 class FlxGame extends Sprite {
	@:meta(Embed(source="data/nokiafc22.ttf", fontFamily="system", embedAsCFF="false"))
	var junk:String;
	@:meta(Embed(source="data/beep.mp3"))
	var SndBeep:Class<Dynamic>;
	@:meta(Embed(source="data/logo.png"))
	var ImgLogo:Class<Dynamic>;

	/**
	 * Sets 0, -, and + to control the global volume sound volume.
	 * @default true
	 */
	public var useSoundHotKeys:Bool = false;
	/**
	 * Tells flixel to use the default system mouse cursor instead of custom Flixel mouse cursors.
	 * @default false
	 */
	public var useSystemCursor:Bool = false;
	/**
	 * Initialize and allow the flixel debugger overlay even in release mode.
	 * Also useful if you don't use FlxPreloader!
	 * @default false
	 */
	public var forceDebugger:Bool = false;

	/**
	 * Current game state.
	 */
	@:allow(org.flixel) var _state:FlxState;
	/**
	 * Mouse cursor.
	 */
	@:allow(org.flixel) var _mouse:Sprite;

	/**
	 * Class type of the initial/first game state for the game, usually MenuState or something like that.
	 */
	var _iState:Class<Dynamic>;
	/**
	 * Whether the game object's basic initialization has finished yet.
	 */
	var _created:Bool = false;

	/**
	 * Total number of milliseconds elapsed since game start.
	 */
	var _total:UInt = 0;
	/**
	 * Total number of milliseconds elapsed since last update loop.
	 * Counts down as we step through the game loop.
	 */
	var _accumulator:Int = 0;
	/**
	 * Whether the Flash player lost focus.
	 */
	var _lostFocus:Bool = false;
	/**
	 * Milliseconds of time per step of the game loop.  FlashEvent.g. 60 fps = 16ms.
	 */
	@:allow(org.flixel) var _step:UInt = 0;
	/**
	 * Framerate of the Flash player (NOT the game loop). Default = 30.
	 */
	@:allow(org.flixel) var _flashFramerate:UInt = 0;
	/**
	 * Max allowable accumulation (see _accumulator).
	 * Should always (and automatically) be set to roughly 2x the flash player framerate.
	 */
	@:allow(org.flixel) var _maxAccumulation:UInt = 0;
	/**
	 * If a state change was requested, the new state object is stored here until we switch to it.
	 */
	@:allow(org.flixel) var _requestedState:FlxState;
	/**
	 * A flag for keeping track of whether a game reset was requested or not.
	 */
	@:allow(org.flixel) var _requestedReset:Bool = false;

	/**
	 * The "focus lost" screen (see <code>createFocusScreen()</code>).
	 */
	var _focus:Sprite;
	/**
	 * The sound tray display container (see <code>createSoundTray()</code>).
	 */
	var _soundTray:Sprite;
	/**
	 * Helps us auto-hide the sound tray after a volume change.
	 */
	var _soundTrayTimer:Float = Math.NaN;
	/**
	 * Helps display the volume bars on the sound tray.
	 */
	var _soundTrayBars:Array<ASAny>;
	/**
	 * The debugger overlay object.
	 */
	@:allow(org.flixel) var _debugger:FlxDebugger;
	/**
	 * A handy boolean that keeps track of whether the debugger exists and is currently visible.
	 */
	@:allow(org.flixel) var _debuggerUp:Bool = false;

	/**
	 * Container for a game replay object.
	 */
	@:allow(org.flixel) var _replay:FlxReplay;
	/**
	 * Flag for whether a playback of a recording was requested.
	 */
	@:allow(org.flixel) var _replayRequested:Bool = false;
	/**
	 * Flag for whether a new recording was requested.
	 */
	@:allow(org.flixel) var _recordingRequested:Bool = false;
	/**
	 * Flag for whether a replay is currently playing.
	 */
	@:allow(org.flixel) var _replaying:Bool = false;
	/**
	 * Flag for whether a new recording is being made.
	 */
	@:allow(org.flixel) var _recording:Bool = false;
	/**
	 * Array that keeps track of keypresses that can cancel a replay.
	 * Handy for skipping cutscenes or getting out of attract modes!
	 */
	@:allow(org.flixel) var _replayCancelKeys:Array<ASAny>;
	/**
	 * Helps time out a replay if necessary.
	 */
	@:allow(org.flixel) var _replayTimer:Int = 0;
	/**
	 * This function, if set, is triggered when the callback stops playing.
	 */
	@:allow(org.flixel) var _replayCallback:ASFunction;

	/**
	 * Instantiate a new game object.
	 *
	 * @param	GameSizeX		The width of your game in game pixels, not necessarily final display pixels (see Zoom).
	 * @param	GameSizeY		The height of your game in game pixels, not necessarily final display pixels (see Zoom).
	 * @param	InitialState	The class name of the state you want to create and switch to first (e.g. MenuState).
	 * @param	Zoom			The default level of zoom for the game's cameras (e.g. 2 = all pixels are now drawn at 2x).  Default = 1.
	 * @param	GameFramerate	How frequently the game should update (default is 60 times per second).
	 * @param	FlashFramerate	Sets the actual display framerate for Flash player (default is 30 times per second).
	 * @param	UseSystemCursor	Whether to use the default OS mouse pointer, or to use custom flixel ones.
	 */
	public function new(GameSizeX:UInt, GameSizeY:UInt, InitialState:Class<Dynamic>, Zoom:Float = 1, GameFramerate:UInt = 60, FlashFramerate:UInt = 30, UseSystemCursor:Bool = false) {
		super();
		//super high priority init stuff (focus, mouse, etc)
		_lostFocus = false;
		_focus = new Sprite();
		_focus.visible = false;
		_soundTray = new Sprite();
		_mouse = new Sprite();

		//basic display and update setup stuff
		FlxG.init(this, GameSizeX, GameSizeY, Zoom);
		FlxG.framerate = GameFramerate;
		FlxG.flashFramerate = FlashFramerate;
		_accumulator = _step;
		_total = 0;
		_state = null;
		useSoundHotKeys = true;
		useSystemCursor = UseSystemCursor;
		if (!useSystemCursor) {
			flash.ui.Mouse.hide();
		}
		forceDebugger = false;
		_debuggerUp = false;

		//replay data
		_replay = new FlxReplay();
		_replayRequested = false;
		_recordingRequested = false;
		_replaying = false;
		_recording = false;

		//then get ready to create the game object for real
		_iState = InitialState;
		_requestedState = null;
		_requestedReset = true;
		_created = false;
		addEventListener(Event.ENTER_FRAME, create);
	}

	/**
	 * Makes the little volume tray slide out.
	 *
	 * @param	Silent	Whether or not it should beep.
	 */
	@:allow(org.flixel) function showSoundTray(Silent:Bool = false) {
		if (!Silent) {
			FlxG.play(SndBeep);
		}
		_soundTrayTimer = 1;
		_soundTray.y = 0;
		_soundTray.visible = true;
		var globalVolume:UInt = Math.round(FlxG.volume * 10);
		if (FlxG.mute) {
			globalVolume = 0;
		}
		var i:UInt = 0;while (i < (_soundTrayBars.length : UInt)) {
			if (i < globalVolume) {
				_soundTrayBars[i].alpha = 1;
			} else {
				_soundTrayBars[i].alpha = 0.5;
			}
i++;
		}
	}

	/**
	 * Internal event handler for input and focus.
	 *
	 * @param	FlashEvent	Flash keyboard event.
	 */
	function onKeyUp(FlashEvent:KeyboardEvent) {
		if (_debuggerUp && _debugger.watch.editing) {
			return;
		}
		if (!FlxG.mobile) {
			if ((_debugger != null) && ((FlashEvent.keyCode == 192) || (FlashEvent.keyCode == 220))) {
				_debugger.visible = !_debugger.visible;
				_debuggerUp = _debugger.visible;
				if (_debugger.visible) {
					flash.ui.Mouse.show();
				} else if (!useSystemCursor) {
					flash.ui.Mouse.hide();
				}
				//_console.toggle();
				return;
			}
			if (useSoundHotKeys) {
				var c:Int = FlashEvent.keyCode;
				var code= String.fromCharCode(FlashEvent.charCode);
				switch (c) {
					case 48
					   | 96:
						FlxG.mute = !FlxG.mute;
						if (FlxG.volumeHandler != null) {
							FlxG.volumeHandler(FlxG.mute ? 0 : FlxG.volume);
						}
						showSoundTray();
						return;
					case 109
					   | 189:
						FlxG.mute = false;
						FlxG.volume = FlxG.volume - 0.1;
						showSoundTray();
						return;
					case 107
					   | 187:
						FlxG.mute = false;
						FlxG.volume = FlxG.volume + 0.1;
						showSoundTray();
						return;
					default:
				}
			}
		}
		if (_replaying) {
			return;
		}
		FlxG.keys.handleKeyUp(FlashEvent);
	}

	/**
	 * Internal event handler for input and focus.
	 *
	 * @param	FlashEvent	Flash keyboard event.
	 */
	function onKeyDown(FlashEvent:KeyboardEvent) {
		if (_debuggerUp && _debugger.watch.editing) {
			return;
		}
		if (_replaying && (_replayCancelKeys != null) && (_debugger == null) && (FlashEvent.keyCode != 192) && (FlashEvent.keyCode != 220)) {
			var cancel= false;
			var replayCancelKey:String;
			var i:UInt = 0;
			var l:UInt = _replayCancelKeys.length;
			while (i < l) {
				replayCancelKey = _replayCancelKeys[i++];
				if ((replayCancelKey == "ANY") || ((FlxG.keys.getKeyCode(replayCancelKey) : UInt) == FlashEvent.keyCode)) {
					if (_replayCallback != null) {
						_replayCallback();
						_replayCallback = null;
					} else {
						FlxG.stopReplay();
					}
					break;
				}
			}
			return;
		}
		FlxG.keys.handleKeyDown(FlashEvent);
	}

	/**
	 * Internal event handler for input and focus.
	 *
	 * @param	FlashEvent	Flash mouse event.
	 */
	function onMouseDown(FlashEvent:MouseEvent) {
		if (_debuggerUp) {
			if (_debugger.hasMouse) {
				return;
			}
			if (_debugger.watch.editing) {
				_debugger.watch.submit();
			}
		}
		if (_replaying && (_replayCancelKeys != null)) {
			var replayCancelKey:String;
			var i:UInt = 0;
			var l:UInt = _replayCancelKeys.length;
			while (i < l) {
				replayCancelKey = ASCompat.toString(_replayCancelKeys[i++]);
				if ((replayCancelKey == "MOUSE") || (replayCancelKey == "ANY")) {
					if (_replayCallback != null) {
						_replayCallback();
						_replayCallback = null;
					} else {
						FlxG.stopReplay();
					}
					break;
				}
			}
			return;
		}
		FlxG.mouse.handleMouseDown(FlashEvent);
	}

	/**
	 * Internal event handler for input and focus.
	 *
	 * @param	FlashEvent	Flash mouse event.
	 */
	function onMouseUp(FlashEvent:MouseEvent) {
		if ((_debuggerUp && _debugger.hasMouse) || _replaying) {
			return;
		}
		FlxG.mouse.handleMouseUp(FlashEvent);
	}

	/**
	 * Internal event handler for input and focus.
	 *
	 * @param	FlashEvent	Flash mouse event.
	 */
	function onMouseWheel(FlashEvent:MouseEvent) {
		if ((_debuggerUp && _debugger.hasMouse) || _replaying) {
			return;
		}
		FlxG.mouse.handleMouseWheel(FlashEvent);
	}

	/**
	 * Internal event handler for input and focus.
	 *
	 * @param	FlashEvent	Flash event.
	 */
	function onFocus(FlashEvent:Event = null) {
		if (!_debuggerUp && !useSystemCursor) {
			flash.ui.Mouse.hide();
		}
		FlxG.resetInput();
		_lostFocus = _focus.visible = false;
		stage.frameRate = _flashFramerate;
		FlxG.resumeSounds();
	}

	/**
	 * Internal event handler for input and focus.
	 *
	 * @param	FlashEvent	Flash event.
	 */
	function onFocusLost(FlashEvent:Event = null) {
		if ((x != 0) || (y != 0)) {
			x = 0;
			y = 0;
		}
		flash.ui.Mouse.show();
		_lostFocus = _focus.visible = true;
		stage.frameRate = 10;
		FlxG.pauseSounds();
	}

	/**
	 * Handles the onEnterFrame call and figures out how many updates and draw calls to do.
	 *
	 * @param	FlashEvent	Flash event.
	 */
	function onEnterFrame(FlashEvent:Event = null) {
		var mark:UInt = Utils.getTimerStamp();
		var elapsedMS= mark - _total;
		_total = mark;
		updateSoundTray(elapsedMS);
		if (!_lostFocus) {
			if ((_debugger != null) && _debugger.vcr.paused) {
				if (_debugger.vcr.stepRequested) {
					_debugger.vcr.stepRequested = false;
					step();
				}
			} else {
				_accumulator += elapsedMS;
				if ((_accumulator : UInt) > _maxAccumulation) {
					_accumulator = _maxAccumulation;
				}
				while ((_accumulator : UInt) >= _step) {
					step();
					_accumulator = _accumulator - _step;
				}
			}

			FlxBasic._VISIBLECOUNT = 0;
			draw();

			if (_debuggerUp) {
				_debugger.perf.flash(elapsedMS);
				_debugger.perf.visibleObjects(FlxBasic._VISIBLECOUNT);
				_debugger.perf.update();
				_debugger.watch.update();
			}
		}
	}

	/**
	 * If there is a state change requested during the update loop,
	 * this function handles actual destroying the old state and related processes,
	 * and calls creates on the new state and plugs it into the game object.
	 */
	function switchState() {
		//Basic reset stuff
		FlxG.resetCameras();
		FlxG.resetInput();
		FlxG.destroySounds();
		FlxG.clearBitmapCache();

		//Clear the debugger overlay's Watch window
		if (_debugger != null) {
			_debugger.watch.removeAll();
		}

		//Clear any timers left in the timer manager
		var timerManager= FlxTimer.manager;
		if (timerManager != null) {
			timerManager.clear();
		}

		//Destroy the old state (if there is an old state)
		if (_state != null) {
			_state.destroy();
		}

		//Finally assign and create the new state
		_state = _requestedState;
		_state.create();
	}

	/**
	 * This is the main game update logic section.
	 * The onEnterFrame() handler is in charge of calling this
	 * the appropriate number of times each frame.
	 * This block handles state changes, replays, all that good stuff.
	 */
	function step() {
		//handle game reset request
		if (_requestedReset) {
			_requestedReset = false;
			_requestedState = Type.createInstance(_iState, []);
			_replayTimer = 0;
			_replayCancelKeys = null;
			FlxG.reset();
		}

		//handle replay-related requests
		if (_recordingRequested) {
			_recordingRequested = false;
			_replay.create(FlxG.globalSeed);
			_recording = true;
			if (_debugger != null) {
				_debugger.vcr.recording();
				FlxG.log("FLIXEL: starting new flixel gameplay record.");
			}
		} else if (_replayRequested) {
			_replayRequested = false;
			_replay.rewind();
			FlxG.globalSeed = _replay.seed;
			if (_debugger != null) {
				_debugger.vcr.playing();
			}
			_replaying = true;
		}

		//handle state switching requests
		if (_state != _requestedState) {
			switchState();
		}

		//finally actually step through the game physics
		FlxBasic._ACTIVECOUNT = 0;
		if (_replaying) {
			_replay.playNextFrame();
			if (_replayTimer > 0) {
				_replayTimer -= _step;
				if (_replayTimer <= 0) {
					if (_replayCallback != null) {
						_replayCallback();
						_replayCallback = null;
					} else {
						FlxG.stopReplay();
					}
				}
			}
			if (_replaying && _replay.finished) {
				FlxG.stopReplay();
				if (_replayCallback != null) {
					_replayCallback();
					_replayCallback = null;
				}
			}
			if (_debugger != null) {
				_debugger.vcr.updateRuntime(_step);
			}
		} else {
			FlxG.updateInput();
		}
		if (_recording) {
			_replay.recordFrame();
			if (_debugger != null) {
				_debugger.vcr.updateRuntime(_step);
			}
		}
		update();
		FlxG.mouse.wheel = 0;
		if (_debuggerUp) {
			_debugger.perf.activeObjects(FlxBasic._ACTIVECOUNT);
		}
	}

	/**
	 * This function just updates the soundtray object.
	 */
	function updateSoundTray(MS:Float) {
		//animate stupid sound tray thing

		if (_soundTray != null) {
			if (_soundTrayTimer > 0) {
				_soundTrayTimer -= MS / 1000;
			} else if (_soundTray.y > -_soundTray.height) {
				_soundTray.y -= (MS / 1000) * FlxG.height * 2;
				if (_soundTray.y <= -_soundTray.height) {
					_soundTray.visible = false;

					//Save sound preferences
					var soundPrefs= new FlxSave();
					if (soundPrefs.bind("flixel")) {
						if (soundPrefs.data.sound == null) {
							soundPrefs.data.sound = {};
						}
						soundPrefs.data.sound.mute = FlxG.mute;
						soundPrefs.data.sound.volume = FlxG.volume;
						soundPrefs.close();
					}
				}
			}
		}
	}

	/**
	 * This function is called by step() and updates the actual game state.
	 * May be called multiple times per "frame" or draw call.
	 */
	function update() {
		var mark:UInt = Utils.getTimerStamp();

		FlxG.elapsed = FlxG.timeScale * (_step / 1000);
		FlxG.updateSounds();
		FlxG.updatePlugins();
		_state.update();
		FlxG.updateCameras();

		if (_debuggerUp) {
			_debugger.perf.flixelUpdate(Utils.getTimerStamp() - mark);
		}
	}

	/**
	 * Goes through the game state and draws all the game objects and special effects.
	 */
	function draw() {
		var mark:UInt = Utils.getTimerStamp();
		FlxG.lockCameras();
		_state.draw();
		FlxG.drawPlugins();
		FlxG.unlockCameras();
		if (_debuggerUp) {
			_debugger.perf.flixelDraw(Utils.getTimerStamp() - mark);
		}
	}

	/**
	 * Used to instantiate the guts of the flixel game object once we have a valid reference to the root.
	 *
	 * @param	FlashEvent	Just a Flash system event, not too important for our purposes.
	 */
	function create(FlashEvent:Event) {
		if (root == null) {
			return;
		}
		removeEventListener(Event.ENTER_FRAME, create);
		_total = Utils.getTimerStamp();

		//Set up the view window and double buffering
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.frameRate = _flashFramerate;

		//Add basic input event listeners and mouse container
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		addChild(_mouse);

		//Let mobile devs opt out of unnecessary overlays.
		if (!FlxG.mobile) {
			//Debugger overlay
			if (FlxG.debug || forceDebugger) {
				_debugger = new FlxDebugger(FlxG.width * FlxCamera.defaultZoom, FlxG.height * FlxCamera.defaultZoom);
				addChild(_debugger);
			}

			//Volume display tab
			createSoundTray();

			//Focus gained/lost monitoring
			stage.addEventListener(Event.DEACTIVATE, onFocusLost);
			stage.addEventListener(Event.ACTIVATE, onFocus);
			createFocusScreen();
		}

		//Finally, set up an event for the actual game loop stuff.
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	/**
	 * Sets up the "sound tray", the little volume meter that pops down sometimes.
	 */
	function createSoundTray() {
		_soundTray.visible = false;
		_soundTray.scaleX = 2;
		_soundTray.scaleY = 2;
		var tmp= new Bitmap(new BitmapData(80, 30, true, 0x7F000000));
		_soundTray.x = (FlxG.width / 2) * FlxCamera.defaultZoom - (tmp.width / 2) * _soundTray.scaleX;
		_soundTray.addChild(tmp);

		var text= new TextField();
		text.width = tmp.width;
		text.height = tmp.height;
		text.multiline = true;
		text.wordWrap = true;
		text.selectable = false;
		text.embedFonts = true;
		text.antiAliasType = AntiAliasType.NORMAL;
		text.gridFitType = GridFitType.PIXEL;
		text.defaultTextFormat = new TextFormat("system", 8, 0xffffff, null, null, null, null, null, "center");

		_soundTray.addChild(text);
		text.text = "VOLUME";
		text.y = 16;

		var bx:UInt = 10;
		var by:UInt = 14;
		_soundTrayBars = [];
		var i:UInt = 0;
		while (i < 10) {
			tmp = new Bitmap(new BitmapData(4, ++i, false, 0xffffff));
			tmp.x = bx;
			tmp.y = by;
			_soundTrayBars.push(_soundTray.addChild(tmp));
			bx += 6;
			by--;
		}

		_soundTray.y = -_soundTray.height;
		_soundTray.visible = false;
		addChild(_soundTray);

		//load saved sound preferences for this game if they exist
		var soundPrefs= new FlxSave();
		if (soundPrefs.bind("flixel") && (soundPrefs.data.sound != null)) {
			if (soundPrefs.data.sound.volume != null) {
				FlxG.volume = soundPrefs.data.sound.volume;
			}
			if (soundPrefs.data.sound.mute != null) {
				FlxG.mute = soundPrefs.data.sound.mute;
			}
			soundPrefs.destroy();
		}
	}

	/**
	 * Sets up the darkened overlay with the big white "play" button that appears when a flixel game loses focus.
	 */
	function createFocusScreen() {
		var gfx= _focus.graphics;
		var screenWidth:UInt = Std.int(FlxG.width * FlxCamera.defaultZoom);
		var screenHeight:UInt = Std.int(FlxG.height * FlxCamera.defaultZoom);

		//draw transparent black backdrop
		gfx.moveTo(0, 0);
		gfx.beginFill(0, 0.5);
		gfx.lineTo(screenWidth, 0);
		gfx.lineTo(screenWidth, screenHeight);
		gfx.lineTo(0, screenHeight);
		gfx.lineTo(0, 0);
		gfx.endFill();

		//draw white arrow
		var halfWidth:UInt = Std.int(screenWidth / 2);
		var halfHeight:UInt = Std.int(screenHeight / 2);
		var helper:UInt = Std.int(FlxU.min(halfWidth, halfHeight) / 3);
		gfx.moveTo(halfWidth - helper, halfHeight - helper);
		gfx.beginFill(0xffffff, 0.65);
		gfx.lineTo(halfWidth + helper, halfHeight);
		gfx.lineTo(halfWidth - helper, halfHeight + helper);
		gfx.lineTo(halfWidth - helper, halfHeight - helper);
		gfx.endFill();

		var logo:Bitmap = Type.createInstance(ImgLogo, []);
		logo.scaleX = Std.int(helper / 10);
		if (logo.scaleX < 1) {
			logo.scaleX = 1;
		}
		logo.scaleY = logo.scaleX;
		logo.x -= logo.scaleX;
		logo.alpha = 0.35;
		_focus.addChild(logo);

		addChild(_focus);
	}
}


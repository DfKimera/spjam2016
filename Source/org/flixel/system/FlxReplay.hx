package org.flixel.system ;

import org.flixel.FlxG;
import org.flixel.system.replay.FrameRecord;

/**
 * The replay object both records and replays game recordings,
 * as well as handle saving and loading replays to and from files.
 * Gameplay recordings are essentially a list of keyboard and mouse inputs,
 * but since Flixel is fairly deterministic, we can use these to play back
 * recordings of gameplay with a decent amount of fidelity.
 *
 * @author	Adam Atomic
 */
 class FlxReplay {
	/**
	 * The random number generator seed value for this recording.
	 */
	public var seed:Float = Math.NaN;
	/**
	 * The current frame for this recording.
	 */
	public var frame:Int = 0;
	/**
	 * The number of frames in this recording.
	 */
	public var frameCount:Int = 0;
	/**
	 * Whether the replay has finished playing or not.
	 */
	public var finished:Bool = false;

	/**
	 * Internal container for all the frames in this replay.
	 */
	var _frames:Array<ASAny>;
	/**
	 * Internal tracker for max number of frames we can fit before growing the <code>_frames</code> again.
	 */
	var _capacity:Int = 0;
	/**
	 * Internal helper variable for keeping track of where we are in <code>_frames</code> during recording or replay.
	 */
	var _marker:Int = 0;

	/**
	 * Instantiate a new replay object.  Doesn't actually do much until you call create() or load().
	 */
	public function new() {
		seed = 0;
		frame = 0;
		frameCount = 0;
		finished = false;
		_frames = null;
		_capacity = 0;
		_marker = 0;
	}

	/**
	 * Clean up memory.
	 */
	public function destroy() {
		if (_frames == null) {
			return;
		}
		var i= frameCount - 1;
		while (i >= 0) {
			ASCompat.dynamicAs(_frames[i--] , FrameRecord).destroy();
		}
		_frames = null;
	}

	/**
	 * Create a new gameplay recording.  Requires the current random number generator seed.
	 *
	 * @param	Seed	The current seed from the random number generator.
	 */
	public function create(Seed:Float) {
		destroy();
		init();
		seed = Seed;
		rewind();
	}

	/**
	 * Load replay data from a <code>String</code> object.
	 * Strings can come from embedded assets or external
	 * files loaded through the debugger overlay.
	 *
	 * @param	FileContents	A <code>String</code> object containing a gameplay recording.
	 */
	public function load(FileContents:String) {
		init();

		var lines:Array<ASAny> = (cast FileContents.split("\n"));

		seed = ASCompat.toNumber(lines[0]);

		var line:String;
		var i:UInt = 1;
		var l:UInt = lines.length;
		while (i < l) {
			line = ASCompat.toString(lines[i++]);
			if (line.length > 3) {
				_frames[frameCount++] = new FrameRecord().load(line);
				if (frameCount >= _capacity) {
					_capacity *= 2;
					_frames.resize(_capacity);
				}
			}
		}

		rewind();
	}

	/**
	 * Common initialization terms used by both <code>create()</code> and <code>load()</code> to set up the replay object.
	 */
	function init() {
		_capacity = 100;
		_frames = Utils.makeArray(_capacity);
		frameCount = 0;
	}

	/**
	 * Save the current recording data off to a <code>String</code> object.
	 * Basically goes through and calls <code>FrameRecord.save()</code> on each frame in the replay.
	 *
	 * return	The gameplay recording in simple ASCII format.
	 */
	public function save():String {
		if (frameCount <= 0) {
			return null;
		}
		var output= seed + "\n";
		var i:UInt = 0;
		while (i < (frameCount : UInt)) {
			output += _frames[i++].save() + "\n";
		}
		return output;
	}

	/**
	 * Get the current input data from the input managers and store it in a new frame record.
	 */
	public function recordFrame() {
		var keysRecord= FlxG.keys.record();
		var mouseRecord= FlxG.mouse.record();
		if ((keysRecord == null) && (mouseRecord == null)) {
			frame++;
			return;
		}
		_frames[frameCount++] = new FrameRecord().create(frame++, keysRecord, mouseRecord);
		if (frameCount >= _capacity) {
			_capacity *= 2;
			_frames.resize(_capacity);
		}
	}

	/**
	 * Get the current frame record data and load it into the input managers.
	 */
	public function playNextFrame() {
		FlxG.resetInput();

		if (_marker >= frameCount) {
			finished = true;
			return;
		}
		if (ASCompat.dynamicAs(_frames[_marker] , FrameRecord).frame != frame++) {
			return;
		}

		var fr:FrameRecord = _frames[_marker++];
		if (fr.keys != null) {
			FlxG.keys.playback(fr.keys);
		}
		if (fr.mouse != null) {
			FlxG.mouse.playback(fr.mouse);
		}
	}

	/**
	 * Reset the replay back to the first frame.
	 */
	public function rewind() {
		_marker = 0;
		frame = 0;
		finished = false;
	}
}


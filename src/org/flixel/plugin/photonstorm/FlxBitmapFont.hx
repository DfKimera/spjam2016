/**
 * FlxBitmapFont
 * -- Part of the Flixel Power Tools set
 *
 * v1.4 Changed width/height to characterWidth/Height to avoid confusion and added setFixedWidth
 * v1.3 Exposed character width / height values
 * v1.2 Updated for the Flixel 2.5 Plugin system
 *
 * @version 1.4 - June 21st 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
 * @see Requires FlxMath
 */

package org.flixel.plugin.photonstorm ;

import org.flixel.*;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

 class FlxBitmapFont extends FlxSprite {
	/**
	 * Alignment of the text when multiLine = true or a fixedWidth is set. Set to FlxBitmapFont.ALIGN_LEFT (default), FlxBitmapFont.ALIGN_RIGHT or FlxBitmapFont.ALIGN_CENTER.
	 */
	public var align:String = "left";

	/**
	 * If set to true all carriage-returns in text will form new lines (see align). If false the font will only contain one single line of text (the default)
	 */
	public var multiLine:Bool = false;

	/**
	 * Automatically convert any text to upper case. Lots of old bitmap fonts only contain upper-case characters, so the default is true.
	 */
	public var autoUpperCase:Bool = true;

	/**
	 * Adds horizontal spacing between each character of the font, in pixels. Default is 0.
	 */
	public var customSpacingX:Float = 0;

	/**
	 * Adds vertical spacing between each line of multi-line text, set in pixels. Default is 0.
	 */
	public var customSpacingY:UInt = 0;

	var _text:String;

	/**
	 * Align each line of multi-line text to the left.
	 */
	public static inline final ALIGN_LEFT= "left";

	/**
	 * Align each line of multi-line text to the right.
	 */
	public static inline final ALIGN_RIGHT= "right";

	/**
	 * Align each line of multi-line text in the center.
	 */
	public static inline final ALIGN_CENTER= "center";

	/**
	 * Text Set 1 = !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
	 */
	public static inline final TEXT_SET1= " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

	/**
	 * Text Set 2 =  !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ
	 */
	public static inline final TEXT_SET2= " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ";

	/**
	 * Text Set 3 = ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
	 */
	public static inline final TEXT_SET3= "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ";

	/**
	 * Text Set 4 = ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789
	 */
	public static inline final TEXT_SET4= "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789";

	/**
	 * Text Set 5 = ABCDEFGHIJKLMNOPQRSTUVWXYZ.,/() '!?-*:0123456789
	 */
	public static inline final TEXT_SET5= "ABCDEFGHIJKLMNOPQRSTUVWXYZ.,/() '!?-*:0123456789";

	/**
	 * Text Set 6 = ABCDEFGHIJKLMNOPQRSTUVWXYZ!?:;0123456789\"(),-.'
	 */
	public static inline final TEXT_SET6= "ABCDEFGHIJKLMNOPQRSTUVWXYZ!?:;0123456789\"(),-.' ";

	/**
	 * Text Set 7 = AGMSY+:4BHNTZ!;5CIOU.?06DJPV,(17EKQW\")28FLRX-'39
	 */
	public static inline final TEXT_SET7= "AGMSY+:4BHNTZ!;5CIOU.?06DJPV,(17EKQW\")28FLRX-'39";

	/**
	 * Text Set 8 = 0123456789 .ABCDEFGHIJKLMNOPQRSTUVWXYZ
	 */
	public static inline final TEXT_SET8= "0123456789 .ABCDEFGHIJKLMNOPQRSTUVWXYZ";

	/**
	 * Text Set 9 = ABCDEFGHIJKLMNOPQRSTUVWXYZ()-0123456789.:,'\"?!
	 */
	public static inline final TEXT_SET9= "ABCDEFGHIJKLMNOPQRSTUVWXYZ()-0123456789.:,'\"?!";

	/**
	 * Text Set 10 = ABCDEFGHIJKLMNOPQRSTUVWXYZ
	 */
	public static inline final TEXT_SET10= "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

	/**
	 * Text Set 11 = ABCDEFGHIJKLMNOPQRSTUVWXYZ.,\"-+!?()':;0123456789
	 */
	public static inline final TEXT_SET11= "ABCDEFGHIJKLMNOPQRSTUVWXYZ.,\"-+!?()':;0123456789";

	/**
	 * Internval values. All set in the constructor. They should not be changed after that point.
	 */
	var fontSet:BitmapData;
	var offsetX:UInt = 0;
	var offsetY:UInt = 0;
	public var characterWidth:UInt = 0;
	public var characterHeight:UInt = 0;
	var characterSpacingX:UInt = 0;
	var characterSpacingY:UInt = 0;
	var characterPerRow:UInt = 0;
	var grabData:Array<ASAny>;
	var fixedWidth:UInt = 0;

	/**
	 * Loads 'font' and prepares it for use by future calls to .text
	 *
	 * @param	font			The font set graphic class (as defined by your embed)
	 * @param	characterWidth	The width of each character in the font set.
	 * @param	characterHeight	The height of each character in the font set.
	 * @param	chars			The characters used in the font set, in display order. You can use the TEXT_SET consts for common font set arrangements.
	 * @param	charsPerRow		The number of characters per row in the font set.
	 * @param	xSpacing		If the characters in the font set have horizontal spacing between them set the required amount here.
	 * @param	ySpacing		If the characters in the font set have vertical spacing between them set the required amount here
	 * @param	xOffset			If the font set doesn't start at the top left of the given image, specify the X coordinate offset here.
	 * @param	yOffset			If the font set doesn't start at the top left of the given image, specify the Y coordinate offset here.
	 */
	public function new(font:Class<Dynamic>, characterWidth:UInt, characterHeight:UInt, chars:String, charsPerRow:UInt, xSpacing:UInt = 0, ySpacing:UInt = 0, xOffset:UInt = 0, yOffset:UInt = 0){
		super();
		//	Take a copy of the font for internal use
		fontSet = Type.createInstance(font, []).bitmapData;

		this.characterWidth = characterWidth;
		this.characterHeight = characterHeight;
		characterSpacingX = xSpacing;
		characterSpacingY = ySpacing;
		characterPerRow = charsPerRow;
		offsetX = xOffset;
		offsetY = yOffset;

		grabData = [];

		//	Now generate our rects for faster copyPixels later on
		var currentX= offsetX;
		var currentY= offsetY;
		var r:UInt = 0;

		var c:UInt = 0;while (c < (chars.length : UInt)) {
			//	The rect is hooked to the ASCII value of the character
			grabData[chars.charCodeAt(c)] = new Rectangle(currentX, currentY, characterWidth, characterHeight);

			r++;

			if (r == characterPerRow) {
				r = 0;
				currentX = offsetX;
				currentY += characterHeight + characterSpacingY;
			} else {
				currentX += characterWidth + characterSpacingX;
			}
c++;
		}
	}

	/**
	 * Set this value to update the text in this sprite. Carriage returns are automatically stripped out if multiLine is false. Text is converted to upper case if autoUpperCase is true.
	 *
	 * @return	void
	 */
	
	@:flash.property public var text(get,set):String;
function  set_text(content:String):String{
		var newText:String;

		if (autoUpperCase) {
			newText = content.toUpperCase();
		} else {
			newText = content;
		}

		// Smart update: Only change the bitmap data if the string has changed
		if (newText != _text) {
			_text = newText;

			removeUnsupportedCharacters(multiLine);

			buildBitmapFontText();
		}
return content;
	}

	/**
	 * If you need this FlxSprite to have a fixed width and custom alignment you can set the width here.<br>
	 * If text is wider than the width specified it will be cropped off.
	 *
	 * @param	width			Width in pixels of this FlxBitmapFont. Set to zero to disable and re-enable automatic resizing.
	 * @param	lineAlignment	Align the text within this width. Set to FlxBitmapFont.ALIGN_LEFT (default), FlxBitmapFont.ALIGN_RIGHT or FlxBitmapFont.ALIGN_CENTER.
	 */
	public function setFixedWidth(width:Int, lineAlignment:String = "left") {
		fixedWidth = width;
		align = lineAlignment;
	}
function  get_text():String {
		return _text;
	}

	/**
	 * A helper function that quickly sets lots of variables at once, and then updates the text.
	 *
	 * @param	content				The text of this sprite
	 * @param	multiLines			Set to true if you want to support carriage-returns in the text and create a multi-line sprite instead of a single line (default is false).
	 * @param	characterSpacing	To add horizontal spacing between each character specify the amount in pixels (default 0).
	 * @param	lineSpacing			To add vertical spacing between each line of text, set the amount in pixels (default 0).
	 * @param	lineAlignment		Align each line of multi-line text. Set to FlxBitmapFont.ALIGN_LEFT (default), FlxBitmapFont.ALIGN_RIGHT or FlxBitmapFont.ALIGN_CENTER.
	 * @param	allowLowerCase		Lots of bitmap font sets only include upper-case characters, if yours needs to support lower case then set this to true.
	 */
	public function setText(content:String, multiLines:Bool = false, characterSpacing:Float = 0, lineSpacing:UInt = 0, lineAlignment:String = "left", allowLowerCase:Bool = false) {
		customSpacingX = characterSpacing;
		customSpacingY = lineSpacing;
		align = lineAlignment;
		multiLine = multiLines;

		if (allowLowerCase) {
			autoUpperCase = false;
		} else {
			autoUpperCase = true;
		}

		if (content.length > 0) {
			text = content;
		}
	}

	/**
	 * Updates the BitmapData of the Sprite with the text
	 *
	 * @return	void
	 */
	function buildBitmapFontText() {
		var temp:BitmapData;
		var cx= 0;
		var cy= 0;

		if (multiLine) {
			var lines:Array<ASAny> = (cast _text.split("\n"));

			if (fixedWidth > 0) {
				temp = new BitmapData(fixedWidth, (lines.length * (characterHeight + customSpacingY)) - customSpacingY, true, 0xf);
			} else if (customSpacingX > 0) {
				temp = new BitmapData(Std.int(getLongestLine() * (characterWidth + customSpacingX)), (lines.length * (characterHeight + customSpacingY)) - customSpacingY, true, 0xf);
			} else {
				temp = new BitmapData(getLongestLine() * characterWidth, (lines.length * (characterHeight + customSpacingY)) - customSpacingY, true, 0xf);
			}

			//	Loop through each line of text
			var i:UInt = 0;while (i < (lines.length : UInt)) {
				//	This line of text is held in lines[i] - need to work out the alignment
				switch (align) {
					case ALIGN_LEFT:
						cx = 0;
						

					case ALIGN_RIGHT:
						cx = Std.int(temp.width - (ASCompat.toNumber(lines[i].length) * (characterWidth + customSpacingX)));
						

					case ALIGN_CENTER:
						cx = Std.int((temp.width / 2) - ((ASCompat.toNumber(lines[i].length) * (characterWidth + customSpacingX)) / 2));
						cx += Std.int(customSpacingX / 2);
						
				}

				//	Sanity checks
				if (cx < 0) {
					cx = 0;
				}

				pasteLine(temp, lines[i], cx, cy, Std.int(customSpacingX));

				cy += characterHeight + customSpacingY;
i++;
			}
		} else {
			if (fixedWidth > 0) {
				temp = new BitmapData(fixedWidth, characterHeight, true, 0xf);
			} else if (customSpacingX > 0) {
				temp = new BitmapData(Std.int(_text.length * (characterWidth + customSpacingX)), characterHeight, true, 0xf);
			} else {
				temp = new BitmapData(_text.length * characterWidth, characterHeight, true, 0xf);
			}

			switch (align) {
				case ALIGN_LEFT:
					cx = 0;
					

				case ALIGN_RIGHT:
					cx = Std.int(temp.width - (_text.length * (characterWidth + customSpacingX)));
					

				case ALIGN_CENTER:
					cx = Std.int((temp.width / 2) - ((_text.length * (characterWidth + customSpacingX)) / 2));
					cx += Std.int(customSpacingX / 2);
					
			}

			pasteLine(temp, _text, cx, 0, Std.int(customSpacingX));
		}

		pixels = temp;
	}

	/**
	 * Returns a single character from the font set as an FlxSprite.
	 *
	 * @param	char	The character you wish to have returned.
	 *
	 * @return	An <code>FlxSprite</code> containing a single character from the font set.
	 */
	public function getCharacter(char:String):FlxSprite {
		var output= new FlxSprite();

		var temp= new BitmapData(characterWidth, characterHeight, true, 0xf);

		if (Std.is(grabData[char.charCodeAt(0)] , Rectangle) && char.charCodeAt(0) != 32) {
			temp.copyPixels(fontSet, grabData[char.charCodeAt(0)], new Point(0, 0));
		}

		output.pixels = temp;

		return output;
	}

	/**
	 * Returns a single character from the font set as bitmapData
	 *
	 * @param	char	The character you wish to have returned.
	 *
	 * @return	<code>bitmapData</code> containing a single character from the font set.
	 */
	public function getCharacterAsBitmapData(char:String):BitmapData {
		var temp= new BitmapData(characterWidth, characterHeight, true, 0xf);

		//if (grabData[char.charCodeAt(0)] is Rectangle && char.charCodeAt(0) != 32)
		if (Std.is(grabData[char.charCodeAt(0)] , Rectangle)) {
			temp.copyPixels(fontSet, grabData[char.charCodeAt(0)], new Point(0, 0));
		}

		return temp;
	}

	/**
	 * Internal function that takes a single line of text (2nd parameter) and pastes it into the BitmapData at the given coordinates.
	 * Used by getLine and getMultiLine
	 *
	 * @param	output			The BitmapData that the text will be drawn onto
	 * @param	line			The single line of text to paste
	 * @param	x				The x coordinate
	 * @param	y
	 * @param	customSpacingX
	 */
	function pasteLine(output:BitmapData, line:String, x:UInt = 0, y:UInt = 0, customSpacingX:UInt = 0) {
		var c:UInt = 0;while (c < (line.length : UInt)) {
			//	If it's a space then there is no point copying, so leave a blank space
			if (line.charAt(c) == " ") {
				x += characterWidth + customSpacingX;
			} else {
				//	If the character doesn't exist in the font then we don't want a blank space, we just want to skip it
				if (Std.is(grabData[line.charCodeAt(c)] , Rectangle)) {
					output.copyPixels(fontSet, grabData[line.charCodeAt(c)], new Point(x, y), null, null, true);

					x += characterWidth + customSpacingX;

					if (x > (output.width : UInt)) {
						break;
					}
				}
			}
c++;
		}
	}

	/**
	 * Works out the longest line of text in _text and returns its length
	 *
	 * @return	A value
	 */
	function getLongestLine():UInt {
		var longestLine:UInt = 0;

		if (_text.length > 0) {
			var lines:Array<ASAny> = (cast _text.split("\n"));

			var i:UInt = 0;while (i < (lines.length : UInt)) {
				if (lines[i].length > longestLine) {
					longestLine = lines[i].length;
				}
i++;
			}
		}

		return longestLine;
	}

	/**
	 * Internal helper function that removes all unsupported characters from the _text String, leaving only characters contained in the font set.
	 *
	 * @param	stripCR		Should it strip carriage returns as well? (default = true)
	 *
	 * @return	A clean version of the string
	 */
	function removeUnsupportedCharacters(stripCR:Bool = true):String {
		var newString= "";

		var c:UInt = 0;while (c < (_text.length : UInt)) {
			if (Std.is(grabData[_text.charCodeAt(c)] , Rectangle) || _text.charCodeAt(c) == 32 || (stripCR == false && _text.charAt(c) == "\n")) {
				newString = newString + _text.charAt(c);
			}
c++;
		}

		return newString;
	}

}


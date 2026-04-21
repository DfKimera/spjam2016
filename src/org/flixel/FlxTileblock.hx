package org.flixel ;

/**
 * This is a basic "environment object" class, used to create simple walls and floors.
 * It can be filled with a random selection of tiles to quickly add detail.
 *
 * @author Adam Atomic
 */
 class FlxTileblock extends FlxSprite {
	/**
	 * Creates a new <code>FlxBlock</code> object with the specified position and size.
	 *
	 * @param	X			The X position of the block.
	 * @param	Y			The Y position of the block.
	 * @param	Width		The width of the block.
	 * @param	Height		The height of the block.
	 */
	public function new(X:Int, Y:Int, Width:UInt, Height:UInt) {
		super(X, Y);
		makeGraphic(Width, Height, 0, true);
		active = false;
		immovable = true;
	}

	/**
	 * Fills the block with a randomly arranged selection of graphics from the image provided.
	 *
	 * @param	TileGraphic 	The graphic class that contains the tiles that should fill this block.
	 * @param	TileWidth		The width of a single tile in the graphic.
	 * @param	TileHeight		The height of a single tile in the graphic.
	 * @param	Empties			The number of "empty" tiles to add to the auto-fill algorithm (e.g. 8 tiles + 4 empties = 1/3 of block will be open holes).
	 */
	public function loadTiles(TileGraphic:String, TileWidth:UInt = 0, TileHeight:UInt = 0, Empties:UInt = 0):FlxTileblock {
		if (TileGraphic == null) {
			return this;
		}

		//First create a tile brush
		var sprite= new FlxSprite().loadGraphic(TileGraphic, true, false, TileWidth, TileHeight);
		var spriteWidth:UInt = Std.int(sprite.width);
		var spriteHeight:UInt = Std.int(sprite.height);
		var total= sprite.frames + Empties;

		//Then prep the "canvas" as it were (just doublechecking that the size is on tile boundaries)
		var regen= false;
		if (width % sprite.width != 0) {
			width = Std.int(width / spriteWidth + 1) * spriteWidth;
			regen = true;
		}
		if (height % sprite.height != 0) {
			height = Std.int(height / spriteHeight + 1) * spriteHeight;
			regen = true;
		}
		if (regen) {
			makeGraphic(Std.int(width), Std.int(height), 0, true);
		} else {
			this.fill(0);
		}

		//Stamp random tiles onto the canvas
		var row:UInt = 0;
		var column:UInt;
		var destinationX:UInt;
		var destinationY:UInt = 0;
		var widthInTiles:UInt = Std.int(width / spriteWidth);
		var heightInTiles:UInt = Std.int(height / spriteHeight);
		while (row < heightInTiles) {
			destinationX = 0;
			column = 0;
			while (column < widthInTiles) {
				if (FlxG.random() * total > Empties) {
					sprite.randomFrame();
					sprite.drawFrame();
					stamp(sprite, destinationX, destinationY);
				}
				destinationX += spriteWidth;
				column++;
			}
			destinationY += spriteHeight;
			row++;
		}

		return this;
	}
}


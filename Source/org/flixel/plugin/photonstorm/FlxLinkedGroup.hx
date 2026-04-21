package org.flixel.plugin.photonstorm ;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;

 class FlxLinkedGroup extends FlxGroup {
	//private var queue


	public function new(MaxSize:UInt = 0) {
		super(MaxSize);
	}

	public function addX(newX:Int) {
		for (_tmp_ in members) {
var s:FlxSprite  = _tmp_;
			s.x += newX;
		}
	}

	public function angle(newX:Int) {
		for (_tmp_ in members) {
var s:FlxSprite  = _tmp_;
			s.angle += newX;
		}
	}

}


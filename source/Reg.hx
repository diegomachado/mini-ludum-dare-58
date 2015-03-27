package;

import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	public static var scoreBoardFont = "assets/data/ozone.ttf";

	public static var hitSounds:Array<String> = ["assets/sounds/hit1.wav",
												 "assets/sounds/hit2.wav",
												 "assets/sounds/hit3.wav"];

	public static var reboundSounds:Array<String> = ["assets/sounds/rebound1.wav",
												     "assets/sounds/rebound2.wav",
												 	 "assets/sounds/rebound3.wav",
												 	 "assets/sounds/rebound4.wav"];

	public static var scores:Array<Int> = [0, 0];
}
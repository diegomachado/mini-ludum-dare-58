package;

import flixel.util.FlxSignal;

class Reg
{
	public static var is2Players:Bool = false;

	public static inline var WIN_SCORE:Int = 10;
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
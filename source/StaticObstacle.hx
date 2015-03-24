package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxRandom;

import Math;

class StaticObstacle extends FlxSprite
{
	private static inline var VISIBLE_DURATION:Float = 3;
	private static inline var VISIBLE_DELAY_MIN:Float = 3;
	private static inline var VISIBLE_DELAY_MAX:Float = 6;

	var _visibleTimer = new FlxTimer();
	var _delayTimer = new FlxTimer();
	var _delay:Float;
	var _isDelaying = false;

	public function new()
	{
		super(0, 0);

		makeGraphic(20, 20, FlxColor.WHITE);
		immovable = true;
		solid = visible = false;
		centerOrigin();

		_delay = FlxRandom.floatRanged(VISIBLE_DELAY_MIN, VISIBLE_DELAY_MAX);
	}

	public override function update()
	{
		if(!_isDelaying && !visible)
		{
			_delayTimer.start(_delay, goVisible, 1);
			_isDelaying = true;
		}

		super.update();
	}

	public function goVisible(timer:FlxTimer)
	{
		_isDelaying = false;
		solid = visible = true;
		_visibleTimer.start(VISIBLE_DURATION, goInvisible, 1);
	}

	public function goInvisible(timer:FlxTimer)
	{
		solid = visible = false;	
		_delay = FlxRandom.floatRanged(VISIBLE_DELAY_MIN, VISIBLE_DELAY_MAX);
	}

	public override function destroy()
	{
		super.destroy();
	}
}
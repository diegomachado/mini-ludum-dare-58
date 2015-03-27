package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxRandom;

import Math;

class Manhole extends FlxSprite
{
	private static inline var VISIBLE_DURATION:Float = 3;
	private static inline var VISIBLE_DELAY_MIN:Float = 3;
	private static inline var VISIBLE_DELAY_MAX:Float = 6;

	var _visibleTimer = new FlxTimer();
	var _delayTimer = new FlxTimer();
	var _delay:Float;
	var _isDelaying = false;
	var _isOpen = false;

	public function new()
	{
		super(0, 0);
		immovable = true;
		solid = _isOpen = false;

		loadGraphic("assets/images/manhole.png", true, 74, 74);
		animation.add("closed", [0]);
		animation.add("open", [1, 2], 1, true);

		offset.set(15, 28);
		width = height = 44;

		_delay = FlxRandom.floatRanged(VISIBLE_DELAY_MIN, VISIBLE_DELAY_MAX);
	}

	public override function update()
	{
		if(_isDelaying)
			animation.play("closed");
		else
			animation.play("open");

		if(!_isDelaying && !_isOpen)
		{
			_delayTimer.start(_delay, goVisible, 1);
			_isDelaying = true;
		}

		super.update();
	}

	public function goVisible(timer:FlxTimer)
	{
		_isDelaying = false;
		solid = _isOpen = true;
		_visibleTimer.start(VISIBLE_DURATION, goInvisible, 1);
	}

	public function goInvisible(timer:FlxTimer)
	{
		solid = _isOpen = false;	
		_delay = FlxRandom.floatRanged(VISIBLE_DELAY_MIN, VISIBLE_DELAY_MAX);
	}

	public override function destroy()
	{
		super.destroy();
	}
}
package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;

import Math;

class DynamicObstacle extends FlxSprite
{
	private static inline var TWEEN_MIN:Float = 1;
	private static inline var TWEEN_MAX:Float = 2;
	private static inline var DELAY_MIN:Float = 5;
	private static inline var DELAY_MAX:Float = 10;

	var _tweenTime:Float;
	
	public var startY:Float;
	public var endY:Float;

	var _delay:Float;
	var _delayTimer = new FlxTimer();
	var _isDelaying = false;
	
	public function new()
	{
		super(0, 0);

		makeGraphic(50, 70, FlxColor.WHITE);
		immovable = true;
		centerOrigin();

		_tweenTime = FlxRandom.floatRanged(TWEEN_MIN, TWEEN_MAX);
		_delay = FlxRandom.floatRanged(DELAY_MIN, DELAY_MAX);

		FlxG.watch.add(this, "_tweenTime");
		FlxG.watch.add(this, "startY");
		FlxG.watch.add(this, "endY");
	}

	public override function update()
	{
		if(!_isDelaying)
		{
			_delayTimer.start(_delay, onDelayEnds, 0);
			_isDelaying = true;
		}

		super.update();
	}

	public function onDelayEnds(timer:FlxTimer)
	{
		_isDelaying = false;

		FlxTween.tween(this, {y: endY}, _tweenTime, {complete: resetPosition});

		_delay = FlxRandom.floatRanged(DELAY_MIN, DELAY_MAX);
	}

	public function resetPosition(tween:FlxTween)
	{
	    y = startY;
	}

	public override function destroy()
	{
		super.destroy();
	}
}
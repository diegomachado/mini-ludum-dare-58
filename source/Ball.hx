package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

class Ball extends FlxSprite
{
	private static inline var MOVE_SPEED:Float = 300;

	function new(x:Float, y:Float)
	{
		super(x, y);

		makeGraphic(10, 10, FlxColor.WHITE);
		centerOrigin();

		elasticity = 1;		

		velocity.set(FlxRandom.sign(50) * MOVE_SPEED,
					 FlxRandom.sign(50) * MOVE_SPEED);

		FlxG.watch.add(this, "velocity");
	}

	public override function update()
	{
		super.update();

		if(y < 0 || y > FlxG.height)
		{
			velocity.y *= -1;
		}

		if(x < 0 || x > FlxG.width)
		{
			velocity.x *= -1;
		}
	}

	public override function destroy()
	{
		super.destroy();
	}
}
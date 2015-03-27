package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;

class Ball extends FlxSprite
{
	private static inline var MOVE_SPEED:Float = 250;

	function new(x:Float, y:Float)
	{
		super(x, y);

		loadRotatedGraphic("assets/images/ball.png", 16);
		animation.add("spinRight", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 20, true);
		animation.add("spinLeft", [15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 20, true);

		maxVelocity.set(900, 500);

		elasticity = 1;		

		velocity.set(FlxRandom.sign(50) * MOVE_SPEED,
					 FlxRandom.sign(50) * MOVE_SPEED);

		FlxG.watch.add(this, "velocity");
	}

	public override function update()
	{
		if(velocity.x > 0)
			animation.play("spinRight");
		else
			animation.play("spinLeft");

		if(y <= 0 || (y + height ) >= (FlxG.height - 18))
		{
			velocity.y *= -1;

			FlxG.sound.play(Reg.reboundSounds[FlxRandom.intRanged(0, Reg.reboundSounds.length - 1)]);
		}

		if(x < 20 || (x + width) > (FlxG.width - 20))
		{
			velocity.x *= -1;

			if(x <= 20)
			{
				Reg.scores[1]++;
	    		FlxG.camera.flash(FlxColor.BLUE, 0.05);
			}
			if((x + width) >= (FlxG.width - 20))
			{
				Reg.scores[0]++;
	    		FlxG.camera.flash(FlxColor.RED, 0.05);
			}

			FlxG.sound.play(Reg.reboundSounds[FlxRandom.intRanged(0, Reg.reboundSounds.length - 1)]);
			FlxG.camera.shake(0.002, 0.2);
		}

		super.update();
	}

	public function reboundHorizontally(power:Int)
	{
		var direction = FlxMath.signOf(velocity.x);
		velocity.x = power * MOVE_SPEED * direction * -1;
	}

	public function reboundVertically()
	{
		velocity.y *= -1;

	}

	public override function destroy()
	{
		super.destroy();
	}
}
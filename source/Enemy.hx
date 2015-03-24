package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.tweens.FlxTween;

class Enemy extends FlxSprite
{
	private static inline var MOVE_SPEED:Float = 400;
	private static inline var MAX_SPEED:Float = 600;
	public var ball:Ball;

	public function new(x:Float, y:Float, ball:Ball)
	{
		super(x, y);
		makeGraphic(20, 40, FlxColor.RED);	
		immovable = true;
		maxVelocity.set(MAX_SPEED, MAX_SPEED);

		this.ball = ball;

		FlxG.watch.add(this, "x");
		FlxG.watch.add(this, "y");
	}

	public override function update()
	{
		velocity.y = 0;

		//unbeatable
		//y = ball.y

		if(ball.x >= FlxG.width / 2 && ball.velocity.x > 0)
		{
			if (ball.y > y)
				velocity.y = MOVE_SPEED;
			else if (ball.y < y)
				velocity.y = -MOVE_SPEED;
		}

	    super.update();
		
		y = FlxMath.bound(y, 0, FlxG.height - height);
	}

	public override function destroy()
	{
		super.destroy();
	}
}
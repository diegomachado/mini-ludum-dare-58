package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

class Enemy extends FlxGroup
{
	private static inline var MOVE_SPEED:Float = 400;
	private static inline var ATTACK_DURATION:Float = 0.2;
	private static inline var REACTION_DISTANCE:Float = 0.35;

	private var _attackPowerChances:Array<Float> = [5, 50, 40, 5];
	
	public var body:FlxSprite;
	public var attackArea:FlxSprite;

	var _attackTimer = new FlxTimer();
	var _isAttacking = false;
	var _hasAttackOverlaped = false;
	var _attackDirection:Int;

	public var ball:Ball;

	public function new(x:Float, y:Float, ball:Ball)
	{
		super();

		body = new FlxSprite(x, y);
		body.makeGraphic(20, 40, FlxColor.RED);
		body.immovable = true;
		add(body);

		attackArea = new FlxSprite(x - 40, y);
		attackArea.makeGraphic(40, 40, FlxColor.RED);
		attackArea.solid = false;
		attackArea.visible = false;
		attackArea.alpha = 0.8;
		add(attackArea);

		this.ball = ball;
	}

	public override function update()
	{
		body.velocity.y = attackArea.velocity.y = 0;

		if(ball.x >= FlxG.width * (1 - REACTION_DISTANCE) && ball.velocity.x > 0)
		{
			if (ball.y > body.y)
			{
				body.velocity.y = MOVE_SPEED;
				attackArea.velocity.y = MOVE_SPEED;
			}
			else if (ball.y < body.y)
			{
				body.velocity.y = -MOVE_SPEED;
				attackArea.velocity.y = -MOVE_SPEED;
			}
		}

		if(!_isAttacking)
		{
			if(ball.velocity.x > 0)
			{
				if(attackArea.overlaps(ball) && !_hasAttackOverlaped)
				{
	    			_isAttacking = true;
			    	_attackTimer.start(ATTACK_DURATION, onAttackEnds, 1);

			    	var attackPower = FlxRandom.weightedPick(_attackPowerChances);
			    	var reboundVerticallyChance = FlxRandom.chanceRoll(50);

			    	if(attackPower != 0 )
			    	{
						attackArea.visible = true;

				    	if(reboundVerticallyChance) 
				    		ball.reboundVertically();
				    	
				    	ball.reboundHorizontally(attackPower);
			    	}
				}
			}
		}

		FlxG.collide(this, ball);

	    super.update();
		
		body.y = FlxMath.bound(body.y, 0, FlxG.height - body.height);
		attackArea.y = FlxMath.bound(attackArea.y, 0, FlxG.height - attackArea.height);
	}

	private function onAttackEnds(timer:FlxTimer)
	{
	    _isAttacking = false;
	    attackArea.visible = false;
	}

	public override function destroy()
	{
		super.destroy();
	}
}
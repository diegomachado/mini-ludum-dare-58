package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

class Enemy extends FlxGroup
{
	private static inline var MOVE_SPEED:Float = 400;
	private static inline var ATTACK_DURATION:Float = 0.3;
	private static inline var REACTION_DISTANCE:Float = 0.45;

	private var _attackPowerChances:Array<Float> = [5, 50, 40, 5];
	
	public var body:FlxSprite;
	public var attackArea:FlxObject;

	var _attackTimer = new FlxTimer();
	var _isAttacking = false;
	var _hasAttackOverlaped = false;
	var _attackDirection:Int;

	public var ball:Ball;

	public function new(x:Float, y:Float, ball:Ball)
	{
		super();

		body = new FlxSprite(x, y);
		body.immovable = true;

		body.loadGraphic("assets/images/players.png", true, 80, 80);
		body.width = 15;
		body.height = 74;
		body.offset.set(47, 6);
		body.flipX = true;

		body.animation.add("idle", [5]);
		body.animation.add("running", [5, 6], 8, true);
		body.animation.add("swinging", [7, 8, 9], 10);

		add(body);

		attackArea = new FlxObject(x - 50, y);
		attackArea.width = 50;
		attackArea.height = 74;
		attackArea.solid = false;
		add(attackArea);

		this.ball = ball;
	}

	public override function update()
	{
		body.velocity.y = attackArea.velocity.y = 0;

		if(!_isAttacking)
		{
			if(ball.x >= FlxG.width * (1 - REACTION_DISTANCE) && ball.velocity.x > 0)
			{
				if (ball.y > body.y)
					body.velocity.y = attackArea.velocity.y = MOVE_SPEED;
				else if (ball.y < body.y)
					body.velocity.y = attackArea.velocity.y = -MOVE_SPEED;
			}
		}

		body.animation.play("idle");

    	if(body.velocity.y != 0)
			body.animation.play("running");

		if(_isAttacking)
			body.animation.play("swinging");

		if(!_isAttacking && ball.velocity.x > 0)
		{
			if(attackArea.overlaps(ball) && !_hasAttackOverlaped)
			{
    			_isAttacking = true;
		    	_attackTimer.start(ATTACK_DURATION, onAttackEnds, 1);

		    	var attackPower = FlxRandom.weightedPick(_attackPowerChances);
		    	var reboundVerticallyChance = FlxRandom.chanceRoll(50);

		    	if(attackPower != 0)
		    	{
		    		FlxG.camera.shake(0.0015 * attackPower, 0.2);
		    		FlxG.sound.play(Reg.hitSounds[attackPower - 1]);

		    		if(attackPower == 3)
	    				FlxG.camera.flash(FlxColor.WHITE, 0.1);
	    			
			    	if(reboundVerticallyChance) 
			    		ball.reboundVertically();
			    	
			    	ball.reboundHorizontally(attackPower);
		    	}
			}
		}

		// FlxG.collide(this, ball);

	    super.update();
		
		body.y = FlxMath.bound(body.y, 0, FlxG.height - body.height);
		attackArea.y = FlxMath.bound(attackArea.y, 0, FlxG.height - attackArea.height);
	}

	private function onAttackEnds(timer:FlxTimer)
	{
	    _isAttacking = false;
	}

	public override function destroy()
	{
		super.destroy();
	}
}
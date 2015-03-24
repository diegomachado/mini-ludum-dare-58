package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;

import Math;

class Player extends FlxGroup
{
	private static inline var MOVE_SPEED:Float = 400;
	private static inline var ATTACK_DURATION:Float = 0.2;
	private static inline var ATTACK_FACTOR:Float = 2.5;
	
	public var body:FlxSprite;
	public var attackArea:FlxSprite;
	var _attackTimer:FlxTimer = new FlxTimer();
	var _isAttacking:Bool = false;
	var _hasAttackOverlaped:Bool = false;
	var _attackDirection:Int;

	public var ball:Ball;

	public function new(x:Float, y:Float, ball:Ball)
	{
		super();

		body = new FlxSprite(x, y);
		body.makeGraphic(20, 40, FlxColor.BLUE);
		body.immovable = true;
		add(body);

		attackArea = new FlxSprite(x + body.width, y);
		attackArea.makeGraphic(40, 40, FlxColor.BLUE);
		attackArea.solid = false;
		attackArea.visible = false;
		attackArea.alpha = 0.8;
		add(attackArea);

		this.ball = ball;
	}

	public override function update()
	{
		body.velocity.y = attackArea.velocity.y = 0;

	    if(FlxG.keys.pressed.UP)
	    {
	    	body.velocity.y = -MOVE_SPEED;
	    	attackArea.velocity.y = -MOVE_SPEED;
	    }
	    else if(FlxG.keys.pressed.DOWN)
	    {
	    	body.velocity.y = MOVE_SPEED;
	    	attackArea.velocity.y = MOVE_SPEED;
	    }

	    if((FlxG.keys.justPressed.A || FlxG.keys.justPressed.Z) && !_isAttacking)
	    {
	    	attackArea.visible = true;
	    	_isAttacking = true;
	    	_hasAttackOverlaped = false;
	    	_attackTimer.start(ATTACK_DURATION, onAttackEnds, 1);

	    	if(FlxG.keys.justPressed.A)
	    		_attackDirection = FlxObject.UP;
	    	else if(FlxG.keys.justPressed.Z)
	    		_attackDirection = FlxObject.DOWN;
	    }

	    if(_isAttacking)
	    {
	    	if(attackArea.overlaps(ball) && !_hasAttackOverlaped)
	    	{
	    		_hasAttackOverlaped = true;

				if(_attackDirection == FlxObject.UP && ball.velocity.y > 0 ) 
					ball.reboundVertically();

				if(_attackDirection == FlxObject.DOWN && ball.velocity.y < 0 ) 
					ball.reboundVertically();

				if(ball.velocity.x < 0)
				{
					var attackDistance = ball.x - attackArea.x;
					var attackPower = Math.round(ATTACK_FACTOR * (1 - attackDistance / attackArea.width));
					attackPower = Std.int(FlxMath.bound(attackPower, 1, ATTACK_FACTOR));
					
					ball.reboundHorizontally(attackPower);
				}
	    	}
	    }

	    FlxG.collide(this, ball);

	    super.update();
		
		body.y = FlxMath.bound(body.y, 0, FlxG.height - body.height);
		attackArea.y = FlxMath.bound(attackArea.y, 0, FlxG.height - attackArea.height);
	}

	public function onAttackEnds(timer:FlxTimer)
	{
	    attackArea.visible = false;
	    _isAttacking = false;
	}

	public override function destroy()
	{
		super.destroy();
	}
}
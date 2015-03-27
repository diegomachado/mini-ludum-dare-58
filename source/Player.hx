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
	private static inline var ATTACK_DURATION:Float = 0.3;
	private static inline var ATTACK_FACTOR:Float = 3;
	
	public var body:FlxSprite;
	public var attackArea:FlxObject;
	var _attackTimer:FlxTimer = new FlxTimer();
	var _isAttacking:Bool = false;
	var _hasAttackOverlaped:Bool = false;
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
		body.offset.set(18, 6);

		body.animation.add("idle", [0]);
		body.animation.add("running", [0, 1], 8, true);
		body.animation.add("swinging", [2, 3, 4], 10);

		add(body);

		attackArea = new FlxObject(x + 16, y);
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
	    	if(FlxG.keys.pressed.UP)
    	    	body.velocity.y = attackArea.velocity.y = -MOVE_SPEED;
    	    else if(FlxG.keys.pressed.DOWN)
    	    	body.velocity.y = attackArea.velocity.y = MOVE_SPEED;
    	}

		body.animation.play("idle");

    	if(body.velocity.y != 0)
			body.animation.play("running");

	    if(FlxG.keys.pressed.A || FlxG.keys.pressed.Z)
	

	    if((FlxG.keys.justPressed.A || FlxG.keys.justPressed.Z) && !_isAttacking)
	    {
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
			body.animation.play("swinging");

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

					FlxG.camera.shake(0.0015 * attackPower, 0.2);
	    			FlxG.sound.play(Reg.hitSounds[attackPower - 1]);

	    			if(attackPower == 3)
	    				FlxG.camera.flash(FlxColor.WHITE, 0.1);

					ball.reboundHorizontally(attackPower);
				}
	    	}
	    }

	    // FlxG.collide(this, ball);

	    super.update();
		
		body.y = FlxMath.bound(body.y, 0, FlxG.height - body.height);
		attackArea.y = FlxMath.bound(attackArea.y, 0, FlxG.height - attackArea.height);
	}

	public function onAttackEnds(timer:FlxTimer)
	{
	    _isAttacking = false;
	}

	public override function destroy()
	{
		super.destroy();
	}
}
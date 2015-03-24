package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;

class Player extends FlxGroup
{
	private static inline var MOVE_SPEED:Float = 400;
	private static inline var ATTACK_DURATION:Float = 0.2;
	public var body:FlxSprite;
	public var ball:Ball;

	public var attackArea:FlxSprite;
	var _attackTimer:FlxTimer = new FlxTimer();
	var _isAttacking:Bool = false;
	var _hasAttackOverlaped:Bool = false;

	public function new(x:Float, y:Float, ball:Ball)
	{
		super();

		body = new FlxSprite(x, y);
		body.makeGraphic(20, 40, FlxColor.BLUE);
		body.immovable = true;
		add(body);

		attackArea = new FlxSprite(x + body.width, y);
		attackArea.makeGraphic(40, 40, FlxColor.MEDIUM_BLUE);
		attackArea.solid = false;
		attackArea.visible = false;
		attackArea.alpha = 0.4;
		add(attackArea);

		this.ball = ball;

		FlxG.watch.add(body, "x");
		FlxG.watch.add(body, "y");
		FlxG.watch.add(attackArea, "x");
		FlxG.watch.add(attackArea, "y");
		FlxG.watch.add(_attackTimer, "finished");
	}

	public override function update()
	{
		body.velocity.y = 0;
		attackArea.velocity.y = 0;

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

	    if(FlxG.keys.justPressed.SPACE && !_isAttacking)
	    {
	    	attackArea.visible = true;
	    	_isAttacking = true;
	    	_hasAttackOverlaped = false;
	    	_attackTimer.start(ATTACK_DURATION, onAttackEnds, 1);
	    }

	    if(_isAttacking)
	    {
	    	if(attackArea.overlaps(ball) && !_hasAttackOverlaped)
	    	{
	    		_hasAttackOverlaped = true;
	    		ball.velocity.x *= -1;
	    	}
	    }

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
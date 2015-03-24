package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.FlxObject;

class PlayState extends FlxState
{
	var player:Player;
	var enemy:Enemy;
	var ball:Ball;

	override public function create()
	{
		ball = new Ball(FlxG.width / 2 , FlxG.height / 2);
		add(ball);

		player = new Player(10, FlxG.height / 2, ball);
		add(player);

		enemy = new Enemy(FlxG.width - 30, FlxG.height / 2, ball);
		add(enemy);

		super.create();
	}
	
	override public function update()
	{
		if(FlxG.keys.pressed.R)
		{
			FlxG.resetState();
		}

		FlxG.collide(player, ball);
		FlxG.collide(enemy, ball);
		
		super.update();
	}

	override public function destroy()
	{
		super.destroy();
	}
}
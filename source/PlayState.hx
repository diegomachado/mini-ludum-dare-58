package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.FlxObject;
import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	var player:Player;
	var enemy:Enemy;
	var ball:Ball;

	var staticObstacles = new FlxGroup();
	var dynamicObstacles = new FlxGroup();

	var player1Score:FlxText;
	var player2Score:FlxText;

	override public function create()
	{
		ball = new Ball(FlxG.width / 2 , FlxG.height / 2);
		add(ball);

		player = new Player(0, FlxG.height / 2, ball);
		add(player);

		enemy = new Enemy(FlxG.width - 20, FlxG.height / 2, ball);
		add(enemy);

		generateStaticObstacles();
		generateDynamicObstacles();

		player1Score = new FlxText(0, 0, -1, Std.string(Reg.scores[0]), 100);
		player1Score.x = FlxG.width / 4 - player1Score.width / 2;
		player1Score.y = FlxG.height / 2 - player1Score.height / 2;
		player1Score.alpha = 0.3;
		add(player1Score);

		player2Score = new FlxText(0, 0, -1, Std.string(Reg.scores[1]), 100);
		player2Score.x = FlxG.width / 4 * 3 - player2Score.width / 2;
		player2Score.y = FlxG.height / 2 - player2Score.height / 2;
		player2Score.alpha = 0.3;
		add(player2Score);

		super.create();
	}
	
	override public function update()
	{
		if(FlxG.keys.pressed.R)
		{
			FlxG.resetState();
		}

		player1Score.text = Std.string(Reg.scores[0]);
		player2Score.text = Std.string(Reg.scores[1]);

		FlxG.collide(ball, staticObstacles);
		FlxG.collide(ball, dynamicObstacles);

		super.update();
	}

	public function generateStaticObstacles()
	{
		var staticObstacle = new StaticObstacle();
		staticObstacle.x = FlxG.width / 4;
		staticObstacle.y = FlxG.height / 2;
		staticObstacles.add(staticObstacle);

		staticObstacle = new StaticObstacle();
		staticObstacle.x = FlxG.width / 2;
		staticObstacle.y = FlxG.height / 4;
		staticObstacles.add(staticObstacle);

		staticObstacle = new StaticObstacle();
		staticObstacle.x = FlxG.width / 2;
		staticObstacle.y = FlxG.height / 4 * 3;
		staticObstacles.add(staticObstacle);

		staticObstacle = new StaticObstacle();
		staticObstacle.x = FlxG.width / 4 * 3;
		staticObstacle.y = FlxG.height / 2;
		staticObstacles.add(staticObstacle);

		add(staticObstacles);
	}

	public function generateDynamicObstacles()
	{
	    var dynamicObstacle = new DynamicObstacle();
	    dynamicObstacle.x = FlxG.width / 8 * 3;
	    dynamicObstacle.y = dynamicObstacle.startY = -dynamicObstacle.height;
	    dynamicObstacle.endY = FlxG.height + dynamicObstacle.height;
	    dynamicObstacles.add(dynamicObstacle);

		dynamicObstacle = new DynamicObstacle();
	    dynamicObstacle.x = FlxG.width / 8 * 5;
	    dynamicObstacle.y = dynamicObstacle.startY = FlxG.height + dynamicObstacle.height;
	    dynamicObstacle.endY = -dynamicObstacle.height;
	    dynamicObstacles.add(dynamicObstacle);

	    add(dynamicObstacles);
	}

	override public function destroy()
	{
		super.destroy();
	}
}
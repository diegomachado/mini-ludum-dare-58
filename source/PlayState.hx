package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;

class PlayState extends FlxState
{
	var player:Player;
	var enemy:Enemy;
	var ball:Ball;

	var manholes = new FlxGroup();
	var cars = new FlxGroup();

	var player1Score:FlxText;
	var player2Score:FlxText;

	override public function create()
	{
		#if !FLX_NO_MOUSE
			FlxG.mouse.visible = false;
		#end

		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		FlxG.sound.playMusic("assets/music/music.mp3", 0.5);

		var city = new FlxSprite(0, 0);
		city.loadGraphic("assets/images/city.png");
		add(city);

		generateManholes();
		generateCars();

		ball = new Ball(FlxG.width / 2 , FlxG.height / 2);
		add(ball);

		player = new Player(78, FlxG.height / 2 - 40, ball);
		add(player);

		enemy = new Enemy(FlxG.width - 93, FlxG.height / 2, ball);
		add(enemy);

		var hud = new FlxSprite(0, 505);
		hud.loadGraphic("assets/images/hud.png");
		add(hud);

		player1Score = new FlxText(407, 490, -1, Std.string(Reg.scores[0]), 100);
		player1Score.setFormat(Reg.scoreBoardFont, 100, FlxColor.YELLOW, "center");
		add(player1Score);

		player2Score = new FlxText(541, 490, -1, Std.string(Reg.scores[1]), 100);
		player2Score.setFormat(Reg.scoreBoardFont, 100, FlxColor.YELLOW, "center");
		add(player2Score);

		super.create();
	}
	
	override public function update()
	{
		if(FlxG.keys.pressed.R)
		{
			Reg.scores = [0, 0];
			FlxG.resetState();
		}

		player1Score.text = Std.string(Reg.scores[0]);
		player2Score.text = Std.string(Reg.scores[1]);

		FlxG.collide(ball, manholes, ballRebound);
		FlxG.collide(ball, cars, ballRebound);

		super.update();
	}

	public function generateManholes()
	{
		var manhole = new Manhole();
		manhole.x = FlxG.width / 4 - manhole.width / 2;
		manhole.y = FlxG.height / 2 - manhole.height;
		manholes.add(manhole);

		manhole = new Manhole();
		manhole.x = FlxG.width / 2 - manhole.width / 2;
		manhole.y = FlxG.height / 4 - manhole.height;
		manholes.add(manhole);

		manhole = new Manhole();
		manhole.x = FlxG.width / 2 - manhole.width / 2;
		manhole.y = FlxG.height / 4 * 3 - manhole.height;
		manholes.add(manhole);

		manhole = new Manhole();
		manhole.x = FlxG.width / 4 * 3 - manhole.width / 2;
		manhole.y = FlxG.height / 2 - manhole.height;
		manholes.add(manhole);

		add(manholes);
	}

	public function generateCars()
	{
	    var car = new Car(FlxObject.UP, 1);
	    cars.add(car);

		car = new Car(FlxObject.DOWN, 2);
	    cars.add(car);

	    add(cars);
	}

	public function ballRebound(obstacle:FlxObject, ball:FlxObject)
	{
		FlxG.sound.play(Reg.reboundSounds[FlxRandom.intRanged(0, Reg.reboundSounds.length - 1)]);
	}

	override public function destroy()
	{
		super.destroy();
	}
}
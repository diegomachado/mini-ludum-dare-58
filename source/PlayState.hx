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
import flixel.addons.effects.FlxTrail;
import flixel.effects.particles.FlxEmitterExt;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.TweenOptions;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxEase.EaseFunction;

class PlayState extends FlxState
{
	var redPlayer:RedPlayer;
	var bluePlayer:BluePlayer;
	var blueComputer:BlueComputer;
	
	var ball:Ball;
	var ballTrail:FlxTrail;
	var ballEmitter:FlxEmitterExt;

	var manholes = new FlxGroup();
	var cars = new FlxGroup();

	var redScore:FlxText;
	var blueScore:FlxText;

	override public function create()
	{
		#if !FLX_NO_MOUSE
			FlxG.mouse.visible = false;
		#end

		FlxG.camera.fade(FlxColor.BLACK, .33, true);

		var city = new FlxSprite(0, 0);
		city.loadGraphic("assets/images/city.png");
		add(city);

		generateManholes();
		generateCars();

		ball = new Ball(FlxG.width / 2 , FlxG.height / 2, this);
		ballTrail = new FlxTrail(ball, "assets/images/ball.png", 5, 2, 0.3, 0.1);
		add(ballTrail);
		add(ball);
		
		ballEmitter = new FlxEmitterExt(ball.x, ball.y);
		ballEmitter.setRotation(0, 0);
		ballEmitter.setMotion(0, 1, 0.2, 360, 30, 1);
		ballEmitter.makeParticles("assets/images/ballParticles.png", 20, 0, true, 0);
		ballEmitter.setAlpha(1, 1, 0, 0);
		add(ballEmitter);

		Signals.ballHitSignal.add(ballHitExplosion);

		redPlayer = new RedPlayer(78, FlxG.height / 2 - 40, ball);
		add(redPlayer);

		if(Reg.is2Players)
		{
			bluePlayer = new BluePlayer(FlxG.width - 93, FlxG.height / 2, ball);
			add(bluePlayer);
		}
		else
		{
			blueComputer = new BlueComputer(FlxG.width - 93, FlxG.height / 2, ball);
			add(blueComputer);
		}

		var hud = new FlxSprite(0, 505);
		hud.loadGraphic("assets/images/hud.png");
		add(hud);

		redScore = new FlxText(407, 490, -1, Std.string(Reg.scores[0]), 100);
		redScore.setFormat(Reg.scoreBoardFont, 100, 0xFFC93D3F, "center");
		add(redScore);

		blueScore = new FlxText(541, 490, -1, Std.string(Reg.scores[1]), 100);
		blueScore.setFormat(Reg.scoreBoardFont, 100, 0xFF4E72C7, "center");
		add(blueScore);

		super.create();
	}
	
	override public function update()
	{
		if(FlxG.keys.pressed.R)
		{
			Reg.scores = [0, 0];
			FlxG.resetState();
		}

		if(FlxG.keys.pressed.ESCAPE)
		{
			Reg.scores = [0, 0];
			FlxG.switchState(new MenuState());
		}

		redScore.text = Std.string(Reg.scores[0]);
		blueScore.text = Std.string(Reg.scores[1]);

		FlxG.collide(ball, manholes, ballRebound);
		FlxG.collide(ball, cars, ballRebound);

		super.update();
	}

	public function redWin()
	{
	    var redWinsText = new FlxText(0, -100, FlxG.width, "Red Wins!");
	    redWinsText.setFormat(null, 48, 0xFFC93D3F, "center", FlxText.BORDER_OUTLINE, FlxColor.WHITE);
	    redWinsText.borderSize = 5;
	    add(redWinsText);

	    var tweenOptions = { 
	    						ease:FlxEase.bounceOut,
	    						complete: showRestart
	    					};

	    FlxTween.tween(redWinsText, { y: FlxG.height / 2 - 100 }, 1.5, tweenOptions); 
	}

	public function blueWin()
	{
		var blueWinsText = new FlxText(0, -100, FlxG.width, "Blue Wins!");
	    blueWinsText.setFormat(null, 48, 0xFF4E72C7, "center", FlxText.BORDER_OUTLINE, FlxColor.WHITE);
	    blueWinsText.borderSize = 5;
	    add(blueWinsText);

	    var tweenOptions = { 
	    						ease:FlxEase.bounceOut,
	    						complete: showRestart
	    					};

	    FlxTween.tween(blueWinsText, { y: FlxG.height / 2 - 100 }, 1.5, tweenOptions); 
	}

	public function showRestart(tween:FlxTween)
	{
		var restartText = new FlxText(0, FlxG.height / 2, FlxG.width, "Press R to restart");
	    restartText.setFormat(null, 35, FlxColor.WHITE, "center", FlxText.BORDER_OUTLINE, 0xFF393939);
	    restartText.borderSize = 5;
	    add(restartText);
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

	public function ballHitExplosion(ball:Ball)
	{
		ballEmitter.x = ball.x;
		ballEmitter.y = ball.y;
		ballEmitter.start(true, 2, 0, 400);
		ballEmitter.update();
	}

	override public function destroy()
	{
		super.destroy();
   		Signals.ballHitSignal.remove(ballHitExplosion);
	}
}
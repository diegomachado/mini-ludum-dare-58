package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.plugin.MouseEventManager;

class MenuState extends FlxState
{
	var logo:FlxSprite;

	override public function create():Void
	{
		#if !FLX_NO_MOUSE
			FlxG.mouse.visible = true;
		#end

		FlxG.sound.playMusic("assets/music/music.mp3", 0.8);

		var city = new FlxSprite(0, 0);
		city.loadGraphic("assets/images/city.png");
		add(city);

		var logo = new FlxSprite(106, -165);
		logo.loadGraphic("assets/images/logo.png");
		add(logo);

	    var tweenOptions = { ease:FlxEase.bounceOut, complete: createButtons };

	    FlxTween.tween(logo, { y: FlxG.height / 2 - 170 }, 1.5, tweenOptions); 

		super.create();
	}

	public function createButtons(tween:FlxTween)
	{
		var playerVsComputer = new FlxSprite(FlxG.width / 2 - 190 - 95, FlxG.height / 2 + 50);
		playerVsComputer.loadGraphic("assets/images/buttons.png", true, 190, 45);
		playerVsComputer.animation.add("blue", [0]);
		playerVsComputer.animation.play("blue");
		add(playerVsComputer);

		var playerVsComputerText = new FlxText(FlxG.width / 2 - 190 - 95 + 8, FlxG.height / 2 + 50 + 14, -1, "Player VS Computer", 20);
		playerVsComputerText.setFormat( null, 14, 0xFF393939, "center");
		add(playerVsComputerText);

		var playerVsPlayer = new FlxSprite(FlxG.width / 2 + 95, FlxG.height / 2 + 50);
		playerVsPlayer.loadGraphic("assets/images/buttons.png", true, 190, 45);
		playerVsPlayer.animation.add("red", [1]);
		playerVsPlayer.animation.play("red");
		add(playerVsPlayer);

		var playerVsPlayerText = new FlxText(FlxG.width / 2  + 95 + 20, FlxG.height / 2 + 50 + 14, -1, "Player VS Player", 20);
		playerVsPlayerText.setFormat( null, 14, 0xFF393939, "center");
		add(playerVsPlayerText);

		MouseEventManager.add(playerVsComputer, playerVsComputerClicked, null, null, null);
		MouseEventManager.add(playerVsPlayer, playerVsPlayerClicked, null, null, null);
	}

	public function playerVsComputerClicked(sprite:FlxSprite)
	{
		Reg.is2Players = false;
		FlxG.switchState(new PlayState());
	}

	public function playerVsPlayerClicked(sprite:FlxSprite)
	{
		Reg.is2Players = true;
		FlxG.switchState(new PlayState());
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}	
}
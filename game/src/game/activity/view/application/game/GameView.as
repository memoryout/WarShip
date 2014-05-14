package game.activity.view.application.game
{
	import flash.display.Sprite;
	
	public class GameView extends Sprite
	{
		
		
		public function GameView()
		{
			super();
			
			new GameViewMediator(this);
		}
				
	}
}
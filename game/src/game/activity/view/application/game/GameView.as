package game.activity.view.application.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import game.activity.BaseMediator;
	
	public class GameView extends Sprite
	{
		private var _skin:			MovieClip;
		
		public function GameView()
		{
			createViewComponents();
		}
		
		
		private function createViewComponents():void
		{
			var classInstance:Class = BaseMediator.getSourceClass("viewGame");
			
			if(classInstance)
			{
				_skin = new classInstance();
				this.addChild( _skin );
			}
		}
				
	}
}
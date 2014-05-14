package game.activity.view.application
{
	import flash.display.Sprite;
	
	import game.activity.view.application.game.GameView;
	
	public class ApplicationView extends Sprite
	{
		private var _gameView:				GameView;
		
		private var _mediator:				ApplicationMediator;
		
		public function ApplicationView()
		{
			super();
			
			_mediator = new ApplicationMediator(this);
		}
		
		
		private function startGameVSComputer():void
		{
			_mediator.startGameVSComputer();
		}
		
		
		public function createGameView():void
		{
			_gameView = new GameView();
			this.addChild( _gameView );
		}
	}
}
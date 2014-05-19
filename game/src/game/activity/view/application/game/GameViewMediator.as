package game.activity.view.application.game
{
	import game.activity.BaseMediator;
	import game.application.ProxyList;
	import game.application.interfaces.IMainApplicationProxy;
	import game.core.IGameProxy;
	
	public class GameViewMediator extends BaseMediator
	{
		private var _gameView:				GameView;
		
		private var _gameProxy:				IGameProxy;
		
		public function GameViewMediator(viewComponent:GameView)
		{
			super();
			
			_gameView = viewComponent;
			
			var mainApp:IMainApplicationProxy = this.facade.retrieveProxy(ProxyList.MAIN_APPLICATION_PROXY) as IMainApplicationProxy;
			
			_gameProxy = mainApp.getCurrentGame();
		}
	}
}
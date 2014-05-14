package game.activity.view.application.game
{
	import game.application.ProxyList;
	import game.application.interfaces.IMainApplicationProxy;
	import game.core.IGameProxy;
	
	import org.puremvc.patterns.mediator.Mediator;
	
	public class GameViewMediator extends Mediator
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